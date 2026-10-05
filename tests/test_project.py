import json
import os
import shutil
import struct
import sys
import tempfile
import unittest
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
sys.path.insert(0, str(Path(__file__).resolve().parent))
from build import build, encode_icon, collect_frames, record, ROOT
from d64 import make_disk, read_disk
from machine import Machine


class ProjectTests(unittest.TestCase):
    def test_disk_roundtrip_and_bam(self):
        data = make_disk([('A', bytes(range(256)), 'SEQ'), ('B', b'123', 'PRG')])
        self.assertEqual(len(data), 174848)
        self.assertEqual(read_disk(data), {'A': bytes(range(256)), 'B': b'123'})
        self.assertEqual(sum(data[0x16500 + 4 + i * 4] for i in range(35)), 678)

    def test_games_fit_and_catalog_matches_disk(self):
        manifest = json.loads((ROOT / 'build/manifest.json').read_text())
        disk = read_disk((ROOT / 'release/sector-256.d64').read_bytes())
        self.assertEqual(disk['INDEX.DAT'][:6], b'S256\x01\x60')
        for i, game in enumerate(manifest['programs']):
            self.assertLessEqual(game['size'], 256)
            prg = (ROOT / 'build' / (game['name'] + '.prg')).read_bytes()
            container = disk[f"P{game['pack']:03}.DAT"][2:]
            self.assertEqual(container[game['offset']:game['offset'] + game['size']], prg[2:])
            self.assertEqual(disk['INDEX.DAT'][8 + i * 96:8 + (i + 1) * 96], record(**game))

    def test_launcher_category_and_selection(self):
        machine = Machine()
        machine.boot()
        self.assertEqual(machine.var('page_count'), 4)
        self.assertEqual(bytes(machine.memory[0x4800:0x4808]), b'GAMES   ')
        machine.key(13)
        self.assertEqual(machine.var('category_mode'), 0)
        self.assertEqual(machine.var('page_count'), 3)
        machine.key(0x1d)
        self.assertEqual(machine.var('selected'), 1)
        machine.key('H')
        self.assertEqual(machine.var('selected'), 0)
        machine.key('T')
        self.assertEqual(bytes(machine.memory[0x4800:0x4808]), b'TICTACTO')
        machine.key(0x87)
        self.assertEqual(machine.var('category_mode'), 1)
        machine.key(0x1d)
        machine.key(13)
        self.assertEqual(machine.var('page_count'), 2)
        self.assertEqual(bytes(machine.memory[0x4800:0x4808]), b'MAZEGEN ')
        machine.key(0x87)
        self.assertEqual(machine.var('page_count'), 4)

    def test_short_names_center_under_icons(self):
        machine = Machine()
        machine.boot()
        font = [255] * 2048
        font[32*8:33*8] = [0] * 8
        machine.memory[0x5800:0x6000] = font
        machine.call('draw_page')

        def occupied(start):
            return [any(machine.memory[0x6000 + 6*320 + (start+i)*8:
                                       0x6000 + 6*320 + (start+i+1)*8])
                    for i in range(8)]

        self.assertEqual(occupied(1), [False] + [True]*5 + [False]*2)  # GAMES
        self.assertEqual(occupied(31), [False]*2 + [True]*3 + [False]*3)  # LAB
        machine.key(0x1d)
        machine.key(0x1d)
        machine.key(13)
        self.assertEqual(occupied(1), [False] + [True]*6 + [False])  # CUBE3D
        self.assertEqual(occupied(11), [False] + [True]*5 + [False]*2)  # DANCE
        self.assertEqual(occupied(21), [False]*2 + [True]*4 + [False]*2)  # SNOW

    def test_pagination_and_letter_jump_for_700_records(self):
        machine = Machine()
        records = [record(f'A{i:07}', 'PAGING TEST', 0, 0, 1, 0, 0, i + 4, 10) for i in range(700)]
        machine.files['INDEX.DAT'] = b'S256\x01\x60' + struct.pack('<H', len(records)) + b''.join(records)
        frame = machine.files['ICONS.DAT'][8 + 4*36:8 + 5*36]
        machine.files['ICONS.DAT'] = b'SICO\x01\x24' + struct.pack('<H', 704) + machine.files['ICONS.DAT'][8:8 + 4*36] + frame * 700
        machine.boot()
        machine.key(13)
        self.assertEqual(machine.var('page_count'), 12)
        self.assertEqual(machine.var('has_next'), 1)
        machine.key(0x86)
        self.assertEqual(machine.word('page_skip'), 12)
        machine.key(0x85)
        self.assertEqual(machine.word('page_skip'), 0)
        machine.set_var('page_skip', 0xb4)
        machine.memory[machine.labels['page_skip'] + 1] = 2  # 692
        machine.call('load_page')
        self.assertEqual(machine.var('page_count'), 8)
        self.assertEqual(machine.var('has_next'), 0)
        machine.key('Z')
        self.assertEqual(machine.word('page_skip'), 0)

    def test_animation_and_runstop(self):
        machine = Machine()
        machine.boot()
        machine.key(13)
        for _ in range(8):
            machine.video_tick()
        self.assertEqual(machine.memory[machine.labels['current_frames']], 1)
        machine.launch(0)
        machine.stop_game()
        self.assertEqual(machine.var('category_mode'), 0)
        machine.launch(1)
        machine.stop_game()
        self.assertEqual(machine.cpu.sp, 0xff)

    def test_monty_hall_reveal_choices_and_score(self):
        machine = Machine()
        machine.boot()
        machine.key(13)
        machine.memory[machine.labels['random_state']] = 1
        machine.launch(1)
        self.assertEqual(machine.memory[2], 2)
        score_address = 0xc000 + bytes(machine.memory[0xc000:0xc100]).find(b'W000 L000')
        self.assertGreaterEqual(score_address, 0xc000)
        machine.game_key('0')
        self.assertNotIn('OPEN ', machine.output)
        wins = losses = 0
        cases = [(prize, pick, switch)
                 for prize in range(3) for pick in range(3)
                 for switch in (False, True)]
        for index, (prize, pick, switch) in enumerate(cases):
            machine.memory[2] = prize
            machine.game_key(str(pick + 1))
            opened = machine.memory[4]
            self.assertNotIn(opened, (prize, pick))
            machine.game_key('X')
            machine.game_key('S' if switch else 'K')
            final = 3 - pick - opened if switch else pick
            wins += final == prize
            losses += final != prize
            self.assertEqual(bytes(machine.memory[score_address:score_address+9]),
                             f'W{wins:03} L{losses:03}'.encode())
            if index + 1 < len(cases):
                seed = index % 3 + 1
                machine.memory[machine.labels['random_state']] = seed
                machine.game_key(13)
                self.assertEqual(machine.memory[2], (2 * seed) % 3)
        self.assertEqual((wins, losses), (9, 9))
        machine.game_key(13)
        machine.memory[score_address+1:score_address+4] = b'099'
        machine.memory[2] = 0
        machine.game_key('1')
        machine.game_key('K')
        self.assertEqual(bytes(machine.memory[score_address:score_address+4]), b'W100')
        machine.stop_game()
        self.assertEqual(machine.var('category_id'), 0)
        self.assertEqual(machine.var('selected'), 1)

    def test_four_frame_animation_fast_and_slow(self):
        machine = Machine()
        machine.boot()
        machine.key(13)
        frame = machine.files['ICONS.DAT'][8 + 4*36:8 + 5*36]
        machine.files['ICONS.DAT'] = b'SICO\x01\x24' + struct.pack('<H', 8) + machine.files['ICONS.DAT'][8:8 + 4*36] + frame * 4
        entry = record('ANIMATE', 'FOUR FRAMES', 0, 0, 1, 0, 0, 4, 0xc0)
        machine.files['INDEX.DAT'] = b'S256\x01\x60\x01\x00' + entry
        machine.call('load_page')
        for expected in (1, 2, 3, 0):
            machine.video_tick()
            self.assertEqual(machine.memory[machine.labels['current_frames']], expected)
        machine.memory[0x4800 + 81] = 0xc1
        for _ in range(4):
            machine.video_tick()
        self.assertEqual(machine.memory[machine.labels['current_frames']], 1)  # 80/16 = 5 transitions
        machine.memory[0x4800 + 81] = 0xff
        machine.call('load_icons')
        machine.memory[0x4800 + 81] = 0xff
        for _ in range(202):
            machine.video_tick()
        self.assertEqual(machine.memory[machine.labels['current_frames']], 0)
        self.assertEqual(machine.memory[machine.labels['elapsed_lo']], 24)  # 4040ms - 4032ms, in thirds

    def test_cube_icon_rotation_frames(self):
        frames, animation = collect_frames(ROOT / 'programs/CUBE3D', 8)
        self.assertEqual(len(frames), 4)
        self.assertEqual(len({frame[:32] for frame in frames}), 4)
        self.assertEqual(animation, 0xc8)
        machine = Machine()
        machine.boot()
        machine.key(0x1d)
        machine.key(0x1d)
        machine.key(13)
        self.assertEqual(bytes(machine.memory[0x4800:0x4808]), b'CUBE3D  ')
        self.assertEqual(machine.memory[machine.labels['frame_counts']], 4)
        seen = []
        for tick in range(1, 27):
            machine.video_tick()
            if tick in (7, 13, 20, 26):
                seen.append(machine.memory[machine.labels['current_frames']])
        self.assertEqual(seen, [1, 2, 3, 0])

    def test_nonblocking_input_and_explicit_exit(self):
        machine = Machine()
        machine.boot()
        machine.call('poll_key')
        self.assertEqual(machine.cpu.a, 0)
        machine.keys.append(65)
        machine.call('poll_key')
        self.assertEqual(machine.cpu.a, 65)
        machine.key(13)
        machine.launch(0)
        machine.cpu.pc = 0x100f
        machine.run_until(lambda: machine.cpu.pc == machine.labels['main_loop'])
        self.assertEqual(machine.cpu.sp, 0xff)

    def test_bitmap_lines_all_octants(self):
        machine = Machine()
        machine.boot()
        machine.call('bitmap_begin')
        def reference(x0, y0, x1, y1):
            result = set()
            dx, dy = abs(x1-x0), abs(y1-y0)
            sx, sy = (1 if x0<x1 else -1), (1 if y0<y1 else -1)
            error = dx-dy
            while True:
                result.add((x0,y0))
                if (x0,y0)==(x1,y1):
                    return result
                twice = 2*error
                if twice > -dy:
                    error -= dy
                    x0 += sx
                if twice < dx:
                    error += dx
                    y0 += sy
        for endpoints in [(0,0,255,199),(255,199,0,0),(0,199,255,0),(255,0,0,199),
                          (0,100,255,100),(100,0,100,199),(180,150,110,170),
                          (110,170,180,150),(100,100,100,100)]:
            machine.call('bitmap_new_frame')
            machine.memory[6:10] = list(endpoints)
            machine.call('bitmap_line')
            points = set()
            for y in range(200):
                for x in range(256):
                    address = 0xa000+(y//8)*320+(x//8)*8+y%8
                    if machine.memory[address] & (128>>(x%8)):
                        points.add((x,y))
            self.assertEqual(points, reference(*endpoints))

    def test_cube_rotation_buffers_and_return(self):
        machine = Machine()
        machine.boot()
        machine.key(0x1d)
        machine.key(0x1d)
        machine.key(13)
        self.assertEqual(bytes(machine.memory[0x4800:0x4808]), b'CUBE3D  ')
        machine.launch(0, wait_address=0x100c)
        previous = None
        for frame in range(16):
            machine.step()
            machine.run_until(lambda: machine.cpu.pc == 0x100c)
            self.assertEqual(machine.var('bitmap_frame_count'), frame+1)
            self.assertEqual(machine.memory[0xdd00] & 3, 1 if frame%2==0 else 2)
            xs, ys = machine.memory[0xc200:0xc208], machine.memory[0xc208:0xc210]
            self.assertEqual(xs[:4], xs[4:])
            self.assertEqual([y+64 for y in ys[:4]], ys[4:])
            self.assertEqual(xs[0]+xs[2], 320)
            self.assertEqual(xs[1]+xs[3], 320)
            self.assertTrue(all(100 <= x <= 220 for x in xs))
            self.assertTrue(all(40 <= y <= 160 for y in ys))
            if frame==0:
                previous = (xs[:],ys[:])
            elif frame==8:
                self.assertNotEqual((xs,ys), previous)
            bitmap = 0xa000 if frame%2==0 else 0x6000
            self.assertGreater(sum(b.bit_count() for b in machine.memory[bitmap:bitmap+8000]), 300)
            for x,y in zip(xs,ys):
                address = bitmap+(y//8)*320+(x//8)*8+y%8
                self.assertTrue(machine.memory[address] & (128>>(x%8)))
        machine.stop_game()
        self.assertEqual(machine.memory[0xdd00] & 3, 2)
        self.assertEqual(machine.cpu.sp, 0xff)
        self.assertEqual(machine.var('category_id'), 2)
        self.assertEqual(machine.var('selected'), 0)

    def test_dance_poses_and_return(self):
        frames, animation = collect_frames(ROOT / 'programs/DANCE', 7)
        self.assertEqual(len({frame[:32] for frame in frames}), 4)
        self.assertEqual(animation, 0xc7)
        machine = Machine()
        machine.boot()
        machine.key(0x1d)
        machine.key(0x1d)
        machine.key(13)
        machine.launch(1, wait_address=0x100c)
        poses = []
        for frame in range(20):
            machine.step()
            machine.run_until(lambda: machine.cpu.pc == 0x100c)
            if frame in (0, 5, 10, 15):
                poses.append(bytes(machine.memory[0xc21e:0xc22a]))
                bitmap = 0xa000 if frame % 2 == 0 else 0x6000
                self.assertGreater(sum(b.bit_count() for b in machine.memory[bitmap:bitmap+8000]), 400)
        self.assertEqual(len(set(poses)), 4)
        machine.stop_game()
        self.assertEqual(machine.var('category_id'), 2)
        self.assertEqual(machine.var('selected'), 1)

    def test_snowfall_speed_density_and_short_stacks(self):
        machine = Machine()
        machine.boot()
        machine.key(0x1d)
        machine.key(0x1d)
        machine.key(13)
        machine.launch(2, wait_address=0x100c)
        live_at_start = [(machine.memory[0xc200+i], machine.memory[0xc240+i])
                         for i in range(64)]
        for parity, width in ((0, 2), (1, 1)):
            x, y = next(position for i, position in enumerate(live_at_start)
                        if i % 2 == parity and
                        sum((other_x // 4, other_y) == (position[0] // 4, position[1])
                            for other_x, other_y in live_at_start) == 1)
            address = 0x6000 + (y // 8) * 320 + (x // 4 + 4) * 8 + y % 8
            self.assertEqual(machine.memory[address].bit_count(), width)
        start_fast = machine.memory[0xc240]
        start_slow = machine.memory[0xc241]
        for frame in range(500):
            machine.step()
            machine.run_until(lambda: machine.cpu.pc == 0x100c)
            if frame == 3:
                self.assertEqual(machine.memory[0xc240], start_fast + 4)
                self.assertEqual(machine.memory[0xc241], start_slow + 2)
        heights = machine.memory[0xc300:0xc380]
        self.assertGreater(sum(h > 0 for h in heights), 80)
        self.assertLessEqual(max(heights), 8)
        masks = (0xc0, 0x30, 0x0c, 0x03)
        for x, height in enumerate(heights):
            for offset in range(height):
                y = 199 - offset
                address = 0x6000 + (y // 8) * 320 + (x // 4 + 4) * 8 + y % 8
                self.assertEqual(machine.memory[address] & masks[x % 4], masks[x % 4])
                color = machine.memory[0x4000 + (y // 8) * 40 + x // 4 + 4]
                self.assertEqual(color >> 4, 1)
        column = machine.memory[0xc200]
        machine.memory[0xc300 + column] = 8
        machine.memory[0xc240] = 198
        machine.step()
        machine.run_until(lambda: machine.cpu.pc == 0x100c)
        self.assertEqual(machine.memory[0xc300 + column], 8)
        self.assertEqual(machine.memory[0xc240], 0)
        machine.stop_game()
        self.assertEqual(machine.var('category_id'), 2)
        self.assertEqual(machine.var('selected'), 2)

    def test_maze_connected_acyclic_and_regeneration(self):
        machine = Machine()
        machine.boot()
        machine.key(0x1d)
        machine.key(13)
        machine.launch(0)

        def check_maze():
            grid = [machine.memory[0x0450+y*40:0x0450+y*40+39] for y in range(21)]
            rooms = {(y, x) for y in range(1, 20, 2) for x in range(1, 38, 2)}
            graph = {room: set() for room in rooms}
            for y, x in rooms:
                self.assertEqual(grid[y][x], 32)
                for dy, dx in ((0, 2), (2, 0)):
                    neighbor = (y+dy, x+dx)
                    if neighbor in rooms and grid[y+dy//2][x+dx//2] == 32:
                        graph[y, x].add(neighbor)
                        graph[neighbor].add((y, x))
            self.assertEqual(sum(map(len, graph.values()))//2, 189)
            seen, pending = set(), [(19, 1)]
            while pending:
                room = pending.pop()
                if room not in seen:
                    seen.add(room)
                    pending.extend(graph[room] - seen)
            self.assertEqual(seen, rooms)  # connectivity + V-1 edges proves no cycles
            boundary = {(y, x) for y in range(21) for x in range(39)
                        if y in (0, 20) or x in (0, 38)}
            self.assertEqual({p for p in boundary if grid[p[0]][p[1]] == 32},
                             {(20, 1), (0, 37)})
            self.assertTrue(all(value in (32, 160) for row in grid for value in row))
            return bytes(value for row in grid for value in row)

        snapshots = {check_maze()}
        before = bytes(machine.memory[0x0400:0x07e8])
        machine.game_key('X')
        self.assertEqual(bytes(machine.memory[0x0400:0x07e8]), before)
        for _ in range(3):
            machine.game_key(' ')
            snapshots.add(check_maze())
        self.assertEqual(len(snapshots), 4)
        machine.stop_game()
        self.assertEqual(machine.var('category_id'), 1)
        self.assertEqual(machine.var('selected'), 0)
        self.assertEqual(machine.cpu.sp, 0xff)
        machine.launch(0, wait_address=0x100c)
        machine.stop_game()  # exit also works while carving the maze
        self.assertEqual(machine.cpu.sp, 0xff)
        self.assertEqual(bytes(machine.memory[0x4800:0x4808]), b'MAZEGEN ')

    def test_langtons_ant_rules_reset_and_return(self):
        machine = Machine()
        machine.boot()
        for _ in range(3):
            machine.key(0x1d)
        machine.key(13)
        self.assertEqual(machine.var('page_count'), 2)
        self.assertEqual(bytes(machine.memory[0x4800:0x4808]), b'ANT     ')
        machine.launch(0, wait_address=0x100c)

        grid = set()
        x, y, direction = 20, 12, 0
        vectors = ((0, -1), (1, 0), (0, 1), (-1, 0))
        for _ in range(8):
            for _ in range(8):
                position = (x, y)
                if position in grid:
                    grid.remove(position)
                    direction = (direction - 1) & 3
                else:
                    grid.add(position)
                    direction = (direction + 1) & 3
                dx, dy = vectors[direction]
                x, y = (x + dx) % 40, (y + dy) % 25
            machine.step()
            machine.run_until(lambda: machine.cpu.pc == 0x100c)
            actual = {(offset % 40, offset // 40)
                      for offset, value in enumerate(machine.memory[0xc400:0xc7e8])
                      if value}
            self.assertEqual(actual, grid)
            self.assertEqual(tuple(machine.memory[2:5]), (x, y, direction))
            self.assertEqual(machine.memory[0x0400 + y * 40 + x], 42)

        machine.keys.append(32)
        machine.step()
        machine.run_until(lambda: machine.cpu.pc == 0x100c)
        self.assertEqual(bytes(machine.memory[0xc400:0xc7e8]), bytes(1000))
        self.assertEqual(tuple(machine.memory[2:5]), (20, 12, 0))
        machine.stop_game()
        self.assertEqual(machine.var('category_id'), 3)
        self.assertEqual(machine.var('selected'), 0)
        self.assertEqual(machine.cpu.sp, 0xff)

    def test_life_blinker_randomize_and_return(self):
        machine = Machine()
        machine.boot()
        for _ in range(3):
            machine.key(0x1d)
        machine.key(13)
        machine.key(0x1d)
        self.assertEqual(machine.var('selected'), 1)
        self.assertEqual(bytes(machine.memory[0x4860:0x4868]), b'LIFE    ')
        machine.launch(1, wait_address=0x100c)

        machine.memory[0x0400:0x0800] = [32] * 1024
        for column in (19, 20, 21):
            machine.memory[0x0400 + 10 * 40 + column] = 0xa0
        machine.step()
        machine.run_until(lambda: machine.cpu.pc == 0x100c)
        live = {(offset // 40, offset % 40)
                for offset, value in enumerate(machine.memory[0x0400:0x07e8])
                if value == 0xa0}
        self.assertEqual(live, {(9, 20), (10, 20), (11, 20)})

        before = bytes(machine.memory[0x0400:0x07e8])
        machine.keys.append(32)
        machine.step()
        machine.run_until(lambda: machine.cpu.pc == 0x100c)
        self.assertNotEqual(bytes(machine.memory[0x0400:0x07e8]), before)
        machine.stop_game()
        self.assertEqual(machine.var('category_id'), 3)
        self.assertEqual(machine.var('selected'), 1)
        self.assertEqual(machine.cpu.sp, 0xff)

    def test_hangman_win_loss_and_repeated_guess(self):
        machine = Machine()
        machine.boot()
        machine.key(13)
        machine.launch(0)
        offset = machine.memory[2]
        words = b'SECTORPIXELSSPRITEGAMING'
        word = words[offset:offset + 6].decode()
        machine.game_key(word[0])
        remaining = machine.memory[4]
        machine.game_key(word[0])
        self.assertEqual(machine.memory[4], remaining)
        for letter in sorted(set(word[1:])):
            if letter != word[0]:
                machine.game_key(letter)
        self.assertEqual(machine.memory[4], 0)
        self.assertIn('W  W=WIN', machine.output)
        machine.game_key(13)
        offset = machine.memory[2]
        word = words[offset:offset + 6].decode()
        wrong = [c for c in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' if c not in word][:6]
        for letter in wrong:
            machine.game_key(letter)
        self.assertEqual(machine.memory[3], 6)
        self.assertIn('L  W=WIN', machine.output)
        machine.stop_game()

    def test_tictactoe_win_draw_and_occupied_cell(self):
        machine = Machine()
        machine.boot()
        machine.key(13)
        machine.launch(2)
        machine.game_key('1')
        machine.game_key('1')
        self.assertEqual(machine.memory[3], 1)
        for key in '4253':
            machine.game_key(key)
        self.assertIn('XW W=WIN', machine.output)
        machine.game_key(13)
        for key in '123546879':
            machine.game_key(key)
        self.assertEqual(machine.memory[3], 9)
        self.assertIn('D W=WIN', machine.output)
        machine.stop_game()

    def test_oversize_is_rejected_and_can_be_flagged(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory) / 'project'
            shutil.copytree(ROOT, root, ignore=shutil.ignore_patterns('build', '__pycache__'))
            source = root / 'programs/HANGMAN/main.asm'
            source.write_text(source.read_text() + '\n.fill 10,0\n')
            with self.assertRaisesRegex(ValueError, 'exceeds 256'):
                build(root=root, assembler=ASSEMBLER)
            result = build(True, root=root, assembler=ASSEMBLER)
            self.assertEqual(next(p for p in result['programs'] if p['name'] == 'HANGMAN')['flags'], 1)
            machine = Machine(root)
            machine.boot()
            machine.key(13)
            self.assertEqual(machine.var('selected_flags'), 1)
            self.assertEqual(machine.memory[0x4000 + 6*40 + 9], 0x20)
            self.assertEqual(machine.memory[0x4000 + 23*40 + 20], 0x20)

    def test_icon_color_and_frame_validation(self):
        from PIL import Image
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            image = Image.new('RGB', (16,16), (0,0,0))
            image.putpixel((1,1), (1,2,3))
            image.save(root / 'icon.png')
            with self.assertRaisesRegex(ValueError, 'palette'):
                encode_icon(root / 'icon.png')
            image = Image.new('RGB', (16,16), (0,0,0))
            image.save(root / 'icon.png')
            image.save(root / 'icon-3.png')
            with self.assertRaisesRegex(ValueError, 'contiguous'):
                collect_frames(root, 0)


ASSEMBLER = os.environ.get('SECTOR256_ASSEMBLER', '64tass')
if __name__ == '__main__':
    unittest.main()

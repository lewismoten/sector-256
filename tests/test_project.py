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
        disk = read_disk((ROOT / 'build/sector-256.d64').read_bytes())
        self.assertEqual(disk['INDEX.DAT'][:6], b'S256\x01\x60')
        for i, game in enumerate(manifest['programs']):
            self.assertLess(game['size'], 256)
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
        self.assertEqual(machine.var('page_count'), 2)
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
        self.assertEqual(machine.var('page_count'), 0)
        machine.key(0x87)
        self.assertEqual(machine.var('page_count'), 4)

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
        machine.launch(1)
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
            self.assertEqual(result['programs'][0]['flags'], 1)
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

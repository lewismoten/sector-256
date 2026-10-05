"""Execute SWATCH and verify triangle geometry, mixing and actual color writes."""
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from machine import Machine, labels, ROOT


class ColorWrites(list):
    def __init__(self, memory):
        super().__init__(memory)
        self.writes = []

    def __setitem__(self, key, value):
        if isinstance(key, int) and 0xd800 <= key < 0xdbe8:
            self.writes.append(key)
        super().__setitem__(key, value)


class SwatchTests(unittest.TestCase):
    def test_triangle_mixing_rates_hold_and_return(self):
        machine = Machine()
        machine.memory = ColorWrites(machine.memory)
        machine.cpu.memory = machine.memory
        symbols = labels(ROOT / 'build/SWATCH.labels')
        machine.boot()
        machine.key(0x1d)
        machine.key(13)
        machine.launch(1, wait_address=symbols['poll'])
        screen = 0x0400 + 3*40 + 8
        color = 0xd800 + 3*40 + 8
        mixed = {color+row*40+column for row in range(16) for column in range(row)}
        diagonal = {color+row*41 for row in range(16)}

        def frame(key=None):
            if key is not None:
                machine.keys.append(ord(key))
            machine.memory.writes.clear()
            machine.step()
            machine.run_until(lambda: machine.cpu.pc == symbols['raster_low'])
            machine.memory[0xd011] &= 0x7f
            machine.run_until(lambda: machine.cpu.pc == symbols['raster_high'])
            machine.memory[0xd011] |= 0x80
            machine.run_until(lambda: machine.cpu.pc == symbols['poll'])
            writes = machine.memory.writes
            if writes:
                self.assertEqual(len(writes), 120)
                self.assertEqual(set(writes), mixed)
            self.assertTrue(diagonal.isdisjoint(writes))

        def colors():
            return [machine.memory[color+row*40:color+row*40+16] for row in range(16)]

        def check_grid():
            phase, weight = machine.memory[2], machine.memory[5]
            for row in range(16):
                code = b'0123456789ABCDEF'[row] & 63
                start = 0x0400 + (row+3)*40
                self.assertEqual(machine.memory[start:start+40],
                                 [32]*7+[code]+[160]*(row+1)+[32]*(31-row))
                for column in range(16):
                    expected = row if phase < weight else column
                    if column == row:
                        expected = row
                    elif column > row:
                        expected = 1  # cleared color RAM; no visible glyph
                    self.assertEqual(colors()[row][column], expected)
                self.assertEqual(machine.memory[screen-1+row*40], code)
            header = 0x0400 + 2*40 + 8
            self.assertEqual(bytes(machine.memory[header:header+16]),
                             b'0123456789\x01\x02\x03\x04\x05\x06')

        check_grid()
        for weight in (2, 1, 3):
            if machine.memory[5] != weight:
                frame('M')
            samples = []
            for _ in range(4):
                frame()
                check_grid()
                samples.append(colors())
            for a in range(16):
                for b in range(a):
                    self.assertEqual(sum(grid[a][b] == a for grid in samples), weight)
                    self.assertEqual(sum(grid[a][b] == b for grid in samples), 4-weight)
            if weight == 2:
                self.assertTrue(all(samples[i][1][0] != samples[i+1][1][0] for i in range(3)))
        frame(' ')
        frozen = colors()
        for _ in range(5):
            frame()
            self.assertEqual(colors(), frozen)
            self.assertEqual(machine.memory.writes, [])
        frame('9')
        self.assertEqual(machine.memory[3], 9)
        frame(' ')
        phase = machine.memory[2]
        for _ in range(7):
            frame()
            self.assertEqual(machine.memory[2], phase)
        frame()
        self.assertNotEqual(machine.memory[2], phase)
        for rate in (2, 1):
            phase = machine.memory[2]
            frame(str(rate))
            for _ in range(rate-1):
                self.assertEqual(machine.memory[2], phase)
                frame()
            self.assertNotEqual(machine.memory[2], phase)
        frame('0')
        self.assertEqual(machine.memory[3], 1)
        frame()
        self.assertEqual(machine.memory[0x0404], ord('1'))
        self.assertEqual(machine.memory[0x0408], ord('3'))
        machine.stop_game()
        self.assertEqual(machine.var('category_id'), 1)
        self.assertEqual(machine.var('selected'), 1)
        self.assertEqual(machine.cpu.sp, 0xff)


if __name__ == '__main__':
    unittest.main()

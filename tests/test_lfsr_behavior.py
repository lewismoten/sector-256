"""Execute LFSR and verify each keypress displays the next register state."""
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from machine import Machine, ROOT


class LfsrBehaviorTests(unittest.TestCase):
    def test_keypresses_advance_the_displayed_register_state(self):
        source = ROOT / 'programs/TOOLS/LFSR/main.asm'
        with tempfile.TemporaryDirectory() as directory:
            program = Path(directory) / 'LFSR.prg'
            subprocess.run([
                '64tass', '--m6502', '--case-sensitive', '--long-branch', '--cbm-prg',
                '-I', str(ROOT / 'src'), '-o', str(program), str(source),
            ], check=True, capture_output=True, text=True)
            binary = program.read_bytes()

        machine = Machine()
        machine.boot()
        machine.memory[0xc000:0xc000 + len(binary) - 2] = binary[2:]
        machine.cpu.pc = 0xc000
        machine.run_until(lambda: machine.cpu.pc == 0x1000)

        def displayed_state():
            return bytes(machine.memory[0x0400 + 4 * 40:0x0400 + 4 * 40 + 8]).decode()

        states = [displayed_state()]
        for _ in range(2):
            machine.keys.append(ord('A'))
            machine.step()
            machine.run_until(lambda: not machine.keys and machine.cpu.pc == 0x1000)
            states.append(displayed_state())

        self.assertEqual(states, ['10100101', '01010111', '10101110'])
        machine.stop_game()
        self.assertEqual(machine.cpu.pc, machine.labels['main_loop'])


if __name__ == '__main__':
    unittest.main()

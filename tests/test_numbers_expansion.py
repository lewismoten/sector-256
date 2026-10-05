"""Focused checks for the three compact NUMBERS additions."""
import json
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

from PIL import Image
from py65.devices.mpu6502 import MPU

import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
from build import encode_icon


ROOT = Path(__file__).resolve().parents[1]
ASSEMBLER = shutil.which("64tass") or "64tass"
PROGRAMS = ("BIGADD", "FACTOR", "PRIMSPIR")


def assemble(path):
    with tempfile.TemporaryDirectory() as directory:
        output = Path(directory) / "program.prg"
        subprocess.run([
            ASSEMBLER, "--m6502", "--case-sensitive", "--long-branch", "--cbm-prg",
            "-I", str(ROOT / "src"), "-o", str(output), str(path),
        ], check=True, capture_output=True, text=True)
        binary = output.read_bytes()
    assert int.from_bytes(binary[:2], "little") == 0xC000
    return binary[2:]


def run_program(payload):
    cpu = MPU()
    cpu.memory[0xC000:0xC000 + len(payload)] = payload
    cpu.pc = 0xC000
    output = []
    for _ in range(200000):
        if cpu.pc == 0x1003:  # CLEAR
            cpu.pc = cpu.stPopWord() + 1
        elif cpu.pc == 0x1006:  # PUTCHAR
            output.append(chr(cpu.a))
            cpu.pc = cpu.stPopWord() + 1
        elif cpu.pc == 0x1000:  # WAITKEY marks a completed screen
            return "".join(output), cpu
        else:
            cpu.step()
    raise AssertionError("program did not reach WAITKEY")


def output_from(payload):
    return run_program(payload)[0]


class NumbersExpansionTests(unittest.TestCase):
    def test_compact_numbers_programs_are_assembled_and_described(self):
        for name in PROGRAMS:
            folder = ROOT / "programs" / "NUMBERS" / name
            payload = assemble(folder / "main.asm")
            self.assertLessEqual(len(payload), 256, name)
            self.assertIn('.include "api.inc"', (folder / "main.asm").read_text())
            self.assertIn("WAITKEY", (folder / "main.asm").read_text())
            metadata = json.loads((folder / "program.json").read_text())
            self.assertTrue(metadata["description"].isupper())
            self.assertLessEqual(len(metadata["description"]), 64)
            self.assertIn("RUN/STOP", (folder / "readme.md").read_text())

    def test_bigadd_computes_a_40_digit_sum(self):
        payload = assemble(ROOT / "programs" / "NUMBERS" / "BIGADD" / "main.asm")
        screen = output_from(payload)
        self.assertIn("1234567890123456789012345678901234567890", screen)
        self.assertIn("1111111111111111111111111111111111111111", screen)
        self.assertIn("2345679001234567900123456790012345679001", screen)

    def test_factor_is_a_16_bit_factorization_demonstrator(self):
        payload = assemble(ROOT / "programs" / "NUMBERS" / "FACTOR" / "main.asm")
        screen, cpu = run_program(payload)
        self.assertIn("65535 = 3 X 5 X 17 X 257", screen)
        self.assertEqual(bytes(cpu.memory[0x20:0x22]), b"\xff\xff")

    def test_primspir_renders_prime_marks_in_a_spiral_layout(self):
        payload = assemble(ROOT / "programs" / "NUMBERS" / "PRIMSPIR" / "main.asm")
        screen = output_from(payload)
        self.assertIn("ULAM PRIME SPIRAL 1-121", screen)
        rows = [row for row in screen.split("\r") if set(row) <= {".", "*"}]
        self.assertEqual(len(rows), 11)
        self.assertEqual(rows[5][5], ".")  # 1 at the center is not prime.
        self.assertEqual(sum(row.count("*") for row in rows), 30)  # primes through 121.

    def test_artwork_is_legal_opaque_and_representative(self):
        icons = []
        for name in PROGRAMS:
            folder = ROOT / "programs" / "NUMBERS" / name
            encoded = encode_icon(folder / "icon.png")
            icons.append(encoded)
            preview = Image.open(folder / "preview.png").convert("RGBA")
            self.assertEqual(preview.size, (320, 200))
            self.assertTrue(all(pixel[3] == 255 for pixel in preview.getdata()))
        self.assertEqual(len(icons), len(set(icons)))


if __name__ == "__main__":
    unittest.main()

"""Standalone PRG package acceptance tests."""
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

from py65.devices.mpu6502 import MPU

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))

from standalone import API_VECTORS, build_standalones  # noqa: E402


class StandaloneTests(unittest.TestCase):
    def test_builds_text_program_as_basic_sys_prg_with_fixed_api_vectors(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory)
            result = build_standalones(output, [ROOT / "programs/SHOWS/CANDLE/main.asm"])
            prg = (output / "CANDLE.prg").read_bytes()

        self.assertEqual(result["CANDLE"]["load_address"], 0x0801)
        self.assertEqual(prg[:2], b"\x01\x08")
        self.assertIn(b"2061", prg[:16])
        image = prg[2:]
        for name, address in API_VECTORS.items():
            offset = address - 0x0801
            self.assertEqual(image[offset], 0x4C, name)
        self.assertEqual(result["CANDLE"]["payload_address"], 0xC000)
        self.assertLessEqual(result["CANDLE"]["payload_size"], 4096)
        self.assertEqual(result["CANDLE"]["api_size"], 795)

    def test_grouped_layout_places_each_program_in_its_category_folder(self):
        source = ROOT / "programs/SHOWS/CANDLE/main.asm"
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory)
            report = build_standalones(output, [source], group_by_category=True)
            artifact = output / "SHOWS" / "CANDLE" / "CANDLE.PRG"
            self.assertEqual(report["CANDLE"]["path"], artifact)
            self.assertTrue(artifact.is_file())

    def test_custom_root_uses_its_own_standalone_api_template(self):
        source = ROOT / "programs/SHOWS/CANDLE/main.asm"
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory) / "root"
            shutil.copytree(ROOT / "src", root / "src")
            (root / "src" / "standalone_api.asm").write_text(".error \"custom API selected\"\n")
            with self.assertRaises(subprocess.CalledProcessError):
                build_standalones(root / "out", [source], root=root)

    def test_text_program_bootstrap_copies_payload_and_stop_returns_to_basic(self):
        source = ROOT / "programs/SHOWS/CANDLE/main.asm"
        with tempfile.TemporaryDirectory() as directory:
            directory = Path(directory)
            output = directory / "standalone"
            build_standalones(output, [source])
            prg = (output / "CANDLE.prg").read_bytes()
            payload = directory / "candle-payload.prg"
            subprocess.run([
                "64tass", "--m6502", "--case-sensitive", "--long-branch", "--cbm-prg",
                "-I", str(ROOT / "src"), "-o", str(payload), str(source),
            ], check=True, capture_output=True, text=True)
            expected_payload = payload.read_bytes()[2:]

        cpu = MPU()
        cpu.memory[0x0801:0x0801 + len(prg) - 2] = prg[2:]
        cpu.stPushWord(0x02FE)
        cpu.pc = 0x080D
        stop_requested = False
        for _ in range(300000):
            if cpu.pc == 0x1000:
                stop_requested = True
            if cpu.pc == 0xFFD2:
                cpu.pc = cpu.stPopWord() + 1
            elif cpu.pc == 0xFFE1:
                cpu.p = (cpu.p | 2) if stop_requested else (cpu.p & ~2)
                cpu.pc = cpu.stPopWord() + 1
            elif cpu.pc == 0xFFE4:
                cpu.a = 0
                cpu.p |= 2
                cpu.pc = cpu.stPopWord() + 1
            else:
                cpu.step()
            if cpu.pc == 0x02FF:
                break
        else:
            self.fail(f"standalone program did not return to BASIC (PC=${cpu.pc:04x})")

        self.assertEqual(bytes(cpu.memory[0xC000:0xC000 + len(expected_payload)]), expected_payload)

    def test_polling_graphics_programs_package_and_cube_draws_a_frame(self):
        sources = [
            ROOT / "programs/SHOWS/CUBE3D/main.asm",
            ROOT / "programs/SHOWS/DANCE/main.asm",
            ROOT / "programs/SHOWS/SNOW/main.asm",
        ]
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory)
            report = build_standalones(output, sources)
            self.assertEqual(set(report), {"CUBE3D", "DANCE", "SNOW"})
            prg = (output / "CUBE3D.prg").read_bytes()

        cpu = MPU()
        cpu.memory[0x0801:0x0801 + len(prg) - 2] = prg[2:]
        cpu.stPushWord(0x02FE)
        cpu.pc = 0x080D
        flip_armed = False
        last_pc = None
        same_pc_count = 0
        for _ in range(1500000):
            if cpu.pc == 0x101B:
                flip_armed = True
                same_pc_count = 0
                cpu.memory[0xD011] &= 0x7F
            elif flip_armed and cpu.pc == last_pc:
                same_pc_count += 1
                if same_pc_count >= 2:
                    cpu.memory[0xD011] |= 0x80
            else:
                same_pc_count = 0
            if cpu.pc == 0xFFE1:
                cpu.p &= ~2
                cpu.pc = cpu.stPopWord() + 1
            elif cpu.pc == 0xFFD2:
                cpu.pc = cpu.stPopWord() + 1
            elif cpu.pc == 0xFFE4:
                cpu.a = 0
                cpu.p |= 2
                cpu.pc = cpu.stPopWord() + 1
            else:
                cpu.step()
            if flip_armed and cpu.pc == 0x100C:
                break
            last_pc = cpu.pc
        else:
            self.fail(f"CUBE3D did not complete a polling graphics frame (PC=${cpu.pc:04x})")

        self.assertTrue(any(cpu.memory[0xC200:0xC210]))
        self.assertGreater(sum(value.bit_count() for value in cpu.memory[0xA000:0xC000]), 300)
        self.assertEqual(cpu.memory[0xDD00] & 3, 1)


if __name__ == "__main__":
    unittest.main()

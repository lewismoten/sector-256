"""Execute RAIN and ensure its repaint pass stays in visible text/color RAM."""
import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

from py65.devices.mpu6502 import MPU


ROOT = Path(__file__).resolve().parents[1]
RAIN = ROOT / "programs/VISUALS/RAIN/main.asm"


class WriteTrackingMemory(list):
    def __init__(self):
        super().__init__([0] * 65536)
        self.writes = []

    def __setitem__(self, address, value):
        if isinstance(address, int):
            self.writes.append(address)
        super().__setitem__(address, value)


class RainSafetyTests(unittest.TestCase):
    def test_repaint_writes_only_the_1000_screen_and_color_cells(self):
        assembler = shutil.which(os.environ.get("SECTOR256_ASSEMBLER", "64tass"))
        self.assertIsNotNone(assembler, "64tass is required to assemble RAIN")
        with tempfile.TemporaryDirectory() as directory:
            program = Path(directory) / "RAIN.prg"
            subprocess.run(
                [assembler, "--m6502", "--case-sensitive", "--long-branch", "--cbm-prg",
                 "-I", str(ROOT / "src"), "-o", str(program), str(RAIN)],
                check=True,
                capture_output=True,
                text=True,
            )
            payload = program.read_bytes()

        self.assertEqual(int.from_bytes(payload[:2], "little"), 0xC000)
        memory = WriteTrackingMemory()
        cpu = MPU(memory=memory, pc=0xC000)
        memory[0xC000:0xC000 + len(payload) - 2] = payload[2:]
        memory.writes.clear()

        for _ in range(10000):
            if cpu.pc == 0x1009:  # RANDOM: deterministic rain/no-rain choice.
                cpu.a = 0
                cpu.pc = cpu.stPopWord() + 1
            elif cpu.pc == 0x1000:  # WAITKEY marks the completed repaint pass.
                break
            else:
                cpu.step()
        else:
            self.fail("RAIN did not reach WAITKEY after repainting")

        repaint_writes = [address for address in memory.writes if address >= 0x0400]
        legal = set(range(0x0400, 0x07E8)) | set(range(0xD800, 0xDBE8))
        self.assertTrue(all(address in legal for address in repaint_writes),
                        f"RAIN wrote outside text/color RAM: "
                        f"{[hex(address) for address in repaint_writes if address not in legal][:8]}")
        self.assertEqual(len(repaint_writes), 2000)


if __name__ == "__main__":
    unittest.main()

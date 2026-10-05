"""6502 execution harness with deterministic KERNAL disk/keyboard services.

This runs the actual assembled machine code. VIC rendering is reconstructed
from RAM for assertions; it is not a cycle-accurate C64 emulator.
"""
import re
from pathlib import Path
from py65.devices.mpu6502 import MPU
from PIL import Image
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
from build import RGB
from d64 import read_disk

ROOT = Path(__file__).resolve().parents[1]


def labels(path):
    return {m[1]: int(m[2], 16) for m in re.finditer(r'^(\w+)\s*=\s*\$([0-9a-f]+)', path.read_text(), re.M)}


class Machine:
    def __init__(self, root=ROOT, font=None):
        self.root = Path(root)
        self.labels = labels(self.root / 'build/launcher.labels')
        self.files = read_disk((self.root / 'build/sector-256.d64').read_bytes())
        self.cpu = MPU()
        self.memory = self.cpu.memory
        binary = self.files['LOADER']
        address = int.from_bytes(binary[:2], 'little')
        self.memory[address:address + len(binary) - 2] = binary[2:]
        if font:
            self.memory[0xd000:0xd800] = Path(font).read_bytes()[:2048]
        self.memory[0x02a6] = 1
        self.memory[1] = 0x37
        self.cpu.pc = 0x080d
        self.keys = []
        self.stop = False
        self.status = 0
        self.name = ''
        self.stream = b''
        self.position = 0
        self.output = ''
        self.text_row = 0
        self.text_col = 0
        self.steps = 0

    def set_var(self, name, value):
        self.memory[self.labels[name]] = value

    def var(self, name):
        return self.memory[self.labels[name]]

    def word(self, name):
        p = self.labels[name]
        return self.memory[p] | self.memory[p + 1] << 8

    def return_rom(self):
        self.cpu.pc = self.cpu.stPopWord() + 1

    def set_carry(self, value):
        self.cpu.p = (self.cpu.p | 1) if value else (self.cpu.p & ~1)

    def set_zero(self, value):
        self.cpu.p = (self.cpu.p | 2) if value else (self.cpu.p & ~2)

    def step(self):
        self.steps += 1
        c = self.cpu
        address = c.pc
        if address == self.labels.get("flip_wait_low"):
            self.memory[0xd011] &= 0x7f
        elif address == self.labels.get("flip_wait_high"):
            self.memory[0xd011] |= 0x80
        if address == 0xffbd:
            p = c.x | c.y << 8
            self.name = bytes(self.memory[p:p + c.a]).decode('ascii')
        elif address == 0xffba:
            pass
        elif address == 0xffc0:
            name = self.name.split(',')[0]
            self.stream = self.files.get(name, b'')
            self.position = 0
            self.status = 0
            self.set_carry(name not in self.files)
        elif address == 0xffc6:
            self.set_carry(False)
        elif address in (0xffc3, 0xffcc):
            self.status = 0
        elif address == 0xffb7:
            c.a = self.status
            self.set_zero(c.a == 0)
        elif address == 0xffcf:
            if self.position >= len(self.stream):
                self.status = 0x40
                c.a = 0
            else:
                c.a = self.stream[self.position]
                self.position += 1
                self.status = 0x40 if self.position == len(self.stream) else 0
            self.set_zero(c.a == 0)
        elif address == 0xffd5:
            data = self.files.get(self.name)
            self.set_carry(data is None)
            if data is not None:
                p = c.x | c.y << 8
                self.memory[p:p + len(data) - 2] = data[2:]
                end = p + len(data) - 2
                c.x, c.y = end & 255, end >> 8
        elif address == 0xffe4:
            c.a = self.keys.pop(0) if self.keys else 0
            self.set_zero(c.a == 0)
        elif address == 0xffe1:
            self.set_zero(self.stop)
            self.stop = False
        elif address == 0xffd2:
            self.character(c.a)
        elif address == 0xfff0:
            if not c.p & 1:
                self.text_row, self.text_col = c.x, c.y
        else:
            c.step()
            return
        self.return_rom()

    def character(self, value):
        if value == 147:
            self.memory[0x0400:0x07e8] = [32] * 1000
            self.memory[0xd800:0xdbe8] = [1] * 1000
            self.text_row = self.text_col = 0
        elif value == 13:
            self.output += '\n'
            self.text_row += 1
            self.text_col = 0
        elif value >= 32:
            self.output += chr(value)
            p = 0x0400 + self.text_row * 40 + self.text_col
            self.memory[p] = value & 63 if value >= 64 else value
            self.text_col += 1
            if self.text_col == 40:
                self.text_col = 0
                self.text_row += 1

    def run_until(self, condition, limit=6000000):
        for _ in range(limit):
            if condition():
                return
            if self.cpu.pc == self.labels['disk_error_halt']:
                raise AssertionError('Launcher disk error: ' + self.output)
            self.step()
        raise AssertionError(f'Execution timeout at ${self.cpu.pc:04x}')

    def boot(self):
        self.run_until(lambda: self.cpu.pc == self.labels['main_loop'])

    def key(self, key):
        self.keys.append(ord(key) if isinstance(key, str) else key)
        self.step()
        self.run_until(lambda: not self.keys and self.cpu.pc == self.labels['main_loop'])

    def launch(self, selection, wait_address=0x1000):
        self.set_var('selected', selection)
        self.keys.append(13)
        self.step()
        self.run_until(lambda: self.cpu.pc == 0xc000)
        self.run_until(lambda: self.cpu.pc == wait_address)

    def game_key(self, key):
        self.keys.append(ord(key) if isinstance(key, str) else key)
        self.step()
        self.run_until(lambda: not self.keys and self.cpu.pc == 0x1000)

    def stop_game(self):
        self.stop = True
        self.step()
        self.run_until(lambda: self.cpu.pc == self.labels['main_loop'])

    def call(self, label):
        saved = self.cpu.pc
        self.cpu.stPushWord(0x02fe)
        self.cpu.pc = self.labels[label]
        self.run_until(lambda: self.cpu.pc == 0x02ff)
        self.cpu.pc = saved

    def video_tick(self):
        self.memory[0xd011] &= 0x7f
        self.call('animate')
        self.memory[0xd011] |= 0x80
        self.call('animate')
        self.memory[0xd011] &= 0x7f

    def screenshot(self, path, text=False):
        bitmap_base = 0xa000 if self.memory[0xdd00] & 3 == 1 else 0x6000
        screen_base = 0x8000 if bitmap_base == 0xa000 else 0x4000
        image = Image.new('RGB', (320, 200))
        for cy in range(25):
            for cx in range(40):
                cell = cy * 40 + cx
                if text:
                    code = self.memory[0x0400 + cell]
                    glyph = self.memory[0x5800 + code * 8:0x5800 + code * 8 + 8]
                    foreground = self.memory[0xd800 + cell] & 15
                    background = self.memory[0xd021] & 15
                else:
                    glyph = self.memory[bitmap_base + cell * 8:bitmap_base + cell * 8 + 8]
                    colors = self.memory[screen_base + cell]
                    foreground, background = colors >> 4, colors & 15
                for y, bits in enumerate(glyph):
                    for x in range(8):
                        image.putpixel((cx * 8 + x, cy * 8 + y), RGB[foreground if bits & (128 >> x) else background])
        image.resize((960, 600), Image.Resampling.NEAREST).save(path)

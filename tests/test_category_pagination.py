import struct
import unittest
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
sys.path.insert(0, str(Path(__file__).resolve().parent))

import build as builder
from build import record
from machine import Machine


class CategoryPaginationTests(unittest.TestCase):
    def test_builder_allows_256_category_ids_and_rejects_257(self):
        builder.validate_category_count(range(256))
        with self.assertRaisesRegex(ValueError, '1..256'):
            builder.validate_category_count(range(257))

    def test_builder_rejects_category_names_that_are_not_prg_url_safe(self):
        builder.validate_category_name('TABLETOP')
        with self.assertRaisesRegex(ValueError, 'category name'):
            builder.validate_category_name('A#B')

    def test_categories_page_by_arrows_and_open_byte_id_24(self):
        machine = Machine()
        frame = machine.files['ICONS.DAT'][8:44]
        categories = [record(f'CAT{i:05}', 'CATEGORY', i, 0, 1, 0, 0, i, 8)
                      for i in range(25)]
        programs = [record(f'P{i:07}', 'PROGRAM', 24, 0, 1, 0, 0, 25 + i, 8)
                    for i in range(13)]
        machine.files['CATS.DAT'] = b'S256\x01\x60' + struct.pack('<H', len(categories)) + b''.join(categories)
        machine.files['INDEX.DAT'] = b'S256\x01\x60' + struct.pack('<H', len(programs)) + b''.join(programs)
        machine.files['ICONS.DAT'] = (b'SICO\x01\x24' + struct.pack('<H', 38)
                                      + frame * 38)

        machine.boot()
        self.assertEqual(machine.var('page_count'), 12)
        machine.set_var('selected', 11)
        machine.key(0x1d)
        self.assertEqual(machine.word('page_skip'), 12)
        self.assertEqual(machine.var('selected'), 0)
        self.assertEqual(bytes(machine.memory[0x4800:0x4808]), b'CAT00012')

        machine.key(0x9d)
        self.assertEqual(machine.word('page_skip'), 0)
        self.assertEqual(machine.var('selected'), 11)

        machine.set_var('selected', 9)
        machine.key(0x11)
        self.assertEqual(machine.word('page_skip'), 12)
        self.assertEqual(machine.var('selected'), 1)
        machine.set_var('selected', 9)
        machine.key(0x11)
        self.assertEqual(machine.word('page_skip'), 24)
        self.assertEqual(machine.var('selected'), 0)
        machine.key(0x91)
        self.assertEqual(machine.word('page_skip'), 12)
        self.assertEqual(machine.var('selected'), 8)

        machine.set_var('selected', 11)
        machine.key(0x1d)
        self.assertEqual(machine.word('page_skip'), 24)
        self.assertEqual(machine.var('selected'), 0)
        machine.key(13)
        self.assertEqual(machine.var('category_mode'), 0)
        self.assertEqual(machine.var('category_id'), 24)
        self.assertEqual(machine.var('page_count'), 12)
        machine.set_var('selected', 11)
        machine.key(0x1d)
        self.assertEqual(machine.word('page_skip'), 12)
        self.assertEqual(machine.var('selected'), 0)

        refreshed_categories = [record('RELOAD', 'CATEGORY', 0, 0, 1, 0, 0, 0, 8)] + categories[1:]
        machine.files['CATS.DAT'] = (b'S256\x01\x60' + struct.pack('<H', len(refreshed_categories))
                                     + b''.join(refreshed_categories))
        machine.key(0x14)
        self.assertEqual(machine.var('category_mode'), 1)
        self.assertEqual(machine.word('page_skip'), 0)
        self.assertEqual(bytes(machine.memory[0x4800:0x4808]), b'RELOAD  ')


if __name__ == '__main__':
    unittest.main()

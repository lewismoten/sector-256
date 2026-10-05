#!/usr/bin/env python3
"""Draw the supplied exact-palette pixel icons; no resizing or quantization."""
from itertools import product
from math import cos, radians, sin
from random import Random
from PIL import Image, ImageDraw
from build import ROOT, RGB
from icon_previews import generate_icon_previews

ART = {
"ANT": ["................", "......####......", ".....#....#.....", "...#..####..#...", "....########....", "..##..####..##..", "......####......", "...##########...", "..#...####...#..", ".#....####....#.", "......####......", "..##..####..##..", ".#....#..#....#.", ".....#....#.....", "................", "................"],
"CHAOS": ["........#.......", "........##......", ".......#.#......", ".......####.....", "......#...#.....", "......##..##....", ".....#.#.#.#....", ".....########...", "....#.......#...", "....##......##..", "...#.#.....#.#..", "...####....####.", "..#...#...#...#.", "..##..##..##..##", ".#.#.#.#.#.#.#.#", ".###############"],
"GAMES": ["................", "................", "......##........", ".....####.......", "......##........", "......##........", "......##........", "..############..", "..#..........#..", "..#..#...##..#..", "..#.###..##..#..", "..#..#.......#..", "..############..", "................", "................", "................"],
"UTILS": ["................", ".........##..##.", ".........##..##.", ".........######.", "..........####..", ".........####...", "........####....", ".......####.....", "......####......", ".....####.......", "....####........", "...####.........", "..####..........", "..#..#..........", "..####..........", "................"],
"DEMOS": ["................", "......########..", "......#......#..", "......#......#..", "......#......#..", "......#......#..", "......#......#..", "......#......#..", "......#......#..", "...####...####..", "..#####..#####..", "..#####..#####..", "...###....###...", "................", "................", "................"],
"LAB": ["................", ".....######.....", ".......##.......", ".......##.......", ".......##.......", "......#..#......", ".....#....#.....", "....#......#....", "...#........#...", "..#..##......#..", ".#..####......#.", ".#...##..##...#.", ".#......####..#.", "..############..", "................", "................"],
"HANGMAN": ["................", "..##########....", "..#.......#.....", "..#.......#.....", "..#......###....", "..#......#.#....", "..#......###....", "..#.......#.....", "..#......###....", "..#.....#.#.#...", "..#.......#.....", "..#......#.#....", "..#.....#...#...", "..#.............", ".######.........", "................"],
"LIFE": ["................", "................", "......##........", "......##........", "........##......", "........##......", "....######......", "....######......", "................", "..........####..", "..........####..", "..........####..", "..........####..", "................", "................", "................"],
"RULE30": ["........#.......", ".......###......", "......##..#.....", ".....##.####....", "....##..#...#...", "...##.####.###..", "..##..#....#..#.", ".##.####..######", ".#..#...###.....", "######.##..#....", "#......#.####..#", ".#....##.#...###", ".##..##..##.##..", "##.###.###..#.#.", "#..#...#..###.#.", "#####.#####...#."],
"SANDPILE": ["................", "................", "................", "................", ".....###.###....", "....#...#...#...", "....#..#.#..#...", "....#.#.#.#.#...", ".....#.#.#.#....", "....#.#.#.#.#...", "....#..#.#..#...", "....#...#...#...", ".....###.###....", "................", "................", "................"],
"TICTACTO": [".....#....#.....", ".#.#.#....#.....", "..#..#.##.#.....", ".#.#.#.##.#.....", ".....#....#.....", "################", ".....#....#.....", ".....#....#.#.#.", ".##..#....#..#..", ".##..#....#.#.#.", "################", ".....#....#.....", ".#.#.#.##.#.....", "..#..#.##.#.....", ".#.#.#....#.....", ".....#....#....."],
}

PROGRAM_CATEGORIES = {
    "ANT": "LAB", "CHAOS": "LAB", "CUBE3D": "DEMOS", "HANGMAN": "GAMES",
    "LIFE": "LAB", "MAZEGEN": "UTILS", "RULE30": "LAB", "SANDPILE": "LAB",
    "SWATCH": "UTILS", "TICTACTO": "GAMES",
}


def program_folder(name):
    return ROOT / "programs" / PROGRAM_CATEGORIES[name] / name


def cube_frames():
    """Four Y-axis orientations; cube symmetry makes the 90-degree loop seamless."""
    vertices = list(product((-1, 1), repeat=3))
    for angle in (11.25, 33.75, 56.25, 78.75):
        c, s = cos(radians(angle)), sin(radians(angle))
        points = []
        for x, y, z in vertices:
            rotated_x, rotated_z = x*c + z*s, z*c - x*s
            points.append((round(7.5 + 4.5*rotated_x),
                           round(7.5 - 4.5*(0.85*y - 0.45*rotated_z))))
        image = Image.new("RGB", (16, 16), RGB[0])
        draw = ImageDraw.Draw(image)
        for i, a in enumerate(vertices):
            for j in range(i + 1, len(vertices)):
                b = vertices[j]
                if sum(p != q for p, q in zip(a, b)) != 1:
                    continue
                # Omit the three rear edges so the tiny cube stays legible.
                if any(a[axis] == b[axis] == side
                       for axis, side in ((0, -1), (1, 1), (2, 1))):
                    draw.line((points[i], points[j]), fill=RGB[14])
        yield image


def generate():
    for name, rows in ART.items():
        folder = (program_folder(name) if name in PROGRAM_CATEGORIES
                  else ROOT / "programs" / name)
        folder.mkdir(parents=True, exist_ok=True)
        color = {"GAMES": 3, "UTILS": 7, "DEMOS": 14, "LAB": 13,
                 "ANT": 7, "CHAOS": 14, "HANGMAN": 7, "LIFE": 13, "RULE30": 14,
                 "SANDPILE": 7, "TICTACTO": 3}[name]
        for frame in range(1, 3 if name in ("HANGMAN", "TICTACTO") else 2):
            image = Image.new("RGB", (16, 16), RGB[0])
            for y, row in enumerate(rows):
                for x, pixel in enumerate(row):
                    if pixel == "#":
                        image.putpixel((x, y), RGB[color if frame == 1 else 1])
            image.save(folder / ("icon.png" if frame == 1 else f"icon-{frame}.png"))
    folder = program_folder("CUBE3D")
    folder.mkdir(parents=True, exist_ok=True)
    frames = list(cube_frames())
    for frame, image in enumerate(frames, 1):
        image.save(folder / ("icon.png" if frame == 1 else f"icon-{frame}.png"))

    folder = program_folder("SWATCH")
    folder.mkdir(parents=True, exist_ok=True)
    for frame in range(4):
        image = Image.new("RGB", (16, 16))
        for y in range(16):
            for x in range(16):
                quadrant = (y//8)*2 + x//8
                first = (frame//2)*8 + quadrant*2
                color = first + ((x//2 + y//2 + frame) & 1)
                image.putpixel((x, y), RGB[color])
        image.save(folder / ("icon.png" if frame == 0 else f"icon-{frame+1}.png"))
    folder = program_folder("MAZEGEN")
    folder.mkdir(parents=True, exist_ok=True)
    for frame in range(1, 5):
        rng = Random(255 + frame)
        image = Image.new("RGB", (16, 16), RGB[0])
        draw = ImageDraw.Draw(image)
        draw.rectangle((2, 2, 12, 12), fill=RGB[13])
        for row in range(5):
            for column in range(5):
                x, y = 3 + column*2, 3 + row*2
                image.putpixel((x, y), RGB[0])
                if row == 0 and column == 4:
                    continue
                if row == 0 or (column != 4 and rng.randrange(2)):
                    image.putpixel((x + 1, y), RGB[0])
                else:
                    image.putpixel((x, y - 1), RGB[0])
        image.putpixel((3, 12), RGB[0])
        image.putpixel((11, 2), RGB[0])
        image.save(folder / ("icon.png" if frame == 1 else f"icon-{frame}.png"))
    generate_icon_previews(ROOT / "programs")


if __name__ == "__main__":
    generate()

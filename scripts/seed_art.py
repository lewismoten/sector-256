#!/usr/bin/env python3
"""Draw the supplied exact-palette pixel icons; no resizing or quantization."""
from itertools import product
from math import cos, radians, sin
from PIL import Image, ImageDraw
from build import ROOT, RGB

ART = {
"GAMES": ["................", "................", "......##........", ".....####.......", "......##........", "......##........", "......##........", "..############..", "..#..........#..", "..#..#...##..#..", "..#.###..##..#..", "..#..#.......#..", "..############..", "................", "................", "................"],
"UTILS": ["................", ".........##..##.", ".........##..##.", ".........######.", "..........####..", ".........####...", "........####....", ".......####.....", "......####......", ".....####.......", "....####........", "...####.........", "..####..........", "..#..#..........", "..####..........", "................"],
"DEMOS": ["................", "......########..", "......#......#..", "......#......#..", "......#......#..", "......#......#..", "......#......#..", "......#......#..", "......#......#..", "...####...####..", "..#####..#####..", "..#####..#####..", "...###....###...", "................", "................", "................"],
"LAB": ["................", ".....######.....", ".......##.......", ".......##.......", ".......##.......", "......#..#......", ".....#....#.....", "....#......#....", "...#........#...", "..#..##......#..", ".#..####......#.", ".#...##..##...#.", ".#......####..#.", "..############..", "................", "................"],
"HANGMAN": ["................", "..##########....", "..#.......#.....", "..#.......#.....", "..#......###....", "..#......#.#....", "..#......###....", "..#.......#.....", "..#......###....", "..#.....#.#.#...", "..#.......#.....", "..#......#.#....", "..#.....#...#...", "..#.............", ".######.........", "................"],
"TICTACTO": [".....#....#.....", ".#.#.#....#.....", "..#..#.##.#.....", ".#.#.#.##.#.....", ".....#....#.....", "################", ".....#....#.....", ".....#....#.#.#.", ".##..#....#..#..", ".##..#....#.#.#.", "################", ".....#....#.....", ".#.#.#.##.#.....", "..#..#.##.#.....", ".#.#.#....#.....", ".....#....#....."],
}


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
        folder = ROOT / ("programs" if name in ("HANGMAN", "TICTACTO") else "categories") / name
        folder.mkdir(parents=True, exist_ok=True)
        color = {"GAMES": 3, "UTILS": 7, "DEMOS": 14, "LAB": 13, "HANGMAN": 7, "TICTACTO": 3}[name]
        for frame in range(1, 3 if name in ("HANGMAN", "TICTACTO") else 2):
            image = Image.new("RGB", (16, 16), RGB[0])
            for y, row in enumerate(rows):
                for x, pixel in enumerate(row):
                    if pixel == "#":
                        image.putpixel((x, y), RGB[color if frame == 1 else 1])
            image.save(folder / ("icon.png" if frame == 1 else f"icon-{frame}.png"))
    folder = ROOT / "programs/CUBE3D"
    folder.mkdir(parents=True, exist_ok=True)
    for frame, image in enumerate(cube_frames(), 1):
        image.save(folder / ("icon.png" if frame == 1 else f"icon-{frame}.png"))


if __name__ == "__main__":
    generate()

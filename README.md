# Sector 256

![Sector 256: One block. Many worlds.](docs/social-preview.jpg)

**One block. Many worlds.** A graphical Commodore 64 launcher for games,
utilities, demos, and experiments whose catalog payloads are at most 256 bytes.
That is a disk-storage constraint, not a runtime-capability limit: launched
programs run at `$c000` and use the shared launcher API.

<!-- program-count: 288 -->
The catalog contains **288 programs**.

![Sector 256 categories](docs/categories.png)

[Browse the programs](programs/readme.md) · [Disk formats](docs/formats.md) ·
[Program interface](docs/program-api.md)

## Build and play

Install Python 3.10+ and **64tass**. On macOS, `brew install 64tass`; on
Debian/Ubuntu, `sudo apt install 64tass`. Then, from this directory:

```sh
python3 -m venv .venv
. .venv/bin/activate
python -m pip install -r requirements.txt
python scripts/build.py
python scripts/programs_md.py
python scripts/render_launcher_screenshots.py
```

The playable image is `release/sector-256.d64`. The same build also writes a
self-contained PRG for every catalog item under
`release/programs/<CATEGORY>/<PROGRAM>/<PROGRAM>.PRG`, plus
`release/sector-256-programs.zip` for release upload. Each standalone PRG has a
BASIC `SYS 2061` loader and embeds the 795-byte API implementation (including
its 30-byte vector table at `$1000`–`$101d`), so its program payload may use the
full `$c000`–`$cfff` execution region (up to 4096 bytes). Attach the D64 to
drive 8 in VICE or write it to a real 1541 disk. Load the first program:

```basic
LOAD"LOADER",8
RUN
```

## GitHub Pages

The `Deploy GitHub Pages` workflow builds the D64, standalone PRGs, and a static
catalog browser. It publishes `index.html`, `sector-256.d64`, and every
`programs/<CATEGORY>/<PROGRAM>/<PROGRAM>.PRG` artifact. The page can open TY64,
send the D64, or filter categories and send an individual PRG through TY64's
cross-window binary-message API.

Configure the repository's Pages source as **GitHub Actions**, then push to
`main` or run the workflow manually.

## Releases

Pushing a semantic version tag in `vX.X.X` form builds and tests the project,
then creates a GitHub Release with both `sector-256.d64` and
`sector-256-programs.zip` attached:

```sh
git tag v1.0.0
git push origin v1.0.0
```

* [Launcher](docs/launcher.md)
* [Program List](programs/readme.md)
* [Add a program](docs/add_program.md)
* [Disk organiation](docs/disk.md)


## Verify

After building:

```sh
python -m unittest discover -s tests -v
```

The tests execute the assembled 6502 code with deterministic KERNAL service
stubs. They cover win/loss/draw logic, repeated/invalid input, returning to the
launcher, categories, a 700-entry catalog, animation, D64 file chains, and the
oversize rejection/bypass. They supplement VICE; they are not cycle-accurate
hardware emulation. The included screenshots are rendered from executed bitmap
RAM with a deterministic preview charset; ROM files and toolchain binaries are
not redistributed in this project.

## Layout

| Path | Purpose |
| --- | --- |
| `src/launcher.asm` | Graphical disk/catalog launcher |
| `src/api.inc` | Stable game entry and shared routine addresses |
| `programs/<category>/category.json` | Category description and launcher order |
| `programs/<category>/icon.png` | Category icon |
| `programs/<category>/*/main.asm` | Individual program source, grouped by category |
| `scripts/build.py` | Compile, validate, pack, and build D64/standalone release artifacts |
| `scripts/standalone.py` | Build standalone BASIC-loadable PRGs with the embedded API |
| `scripts/programs_md.py` | Generate preview/source catalog |
| `scripts/render_launcher_screenshots.py` | Render native 320×200 launcher screenshots from the machine harness |
| `scripts/pages_catalog.py` | Generate GitHub Pages category/program metadata |
| `pages/index.html` | Static GitHub Pages TY64 catalog browser |
| `tests/` | Machine-code and packaging verification |
| `build/manifest.json` | Generated sizes, offsets, flags, and pack assignments |
| `release/sector-256.d64` | Playable disk image |

## Acknowledgments

Sector 256 was designed and directed by Lewis Moten. Its code and documentation
were developed with assistance from GPT-5.x, accessed through Hermes and using
Honcho for context and project-memory support. This assistance does not replace
the repository's source history, validation records, licensing, or the human
maintainer's responsibility for published work.

Thanks to Krisztián for guidance on sending D64 and PRG bytes to the
[TY64 emulator](https://ty64.krissz.hu/) from the GitHub Pages catalog.

# Disk and catalog formats

All integers are unsigned little-endian unless stated otherwise. Files are
ordinary CBM DOS files. The D64 is 35 tracks, 683 sectors, and 174848 bytes.
Every normal file sector reserves two bytes for its next-sector/end marker.
Track 18 supplies the BAM and directory; normal file allocation uses the other
664 sectors. Sector rounding, directory entries, and PRG prefixes are accounted
for by `scripts/d64.py`.

## INDEX.DAT and CATS.DAT

Both are SEQ files beginning with an eight-byte header:

| Offset | Size | Value |
| --- | --- | --- |
| 0 | 4 | ASCII `S256` |
| 4 | 1 | Format version 1 |
| 5 | 1 | Record size 96 |
| 6 | 2 | Record count |

Each subsequent record is exactly 96 bytes:

| Offset | Size | Field |
| --- | --- | --- |
| 0 | 8 | Unique uppercase name, padded with spaces |
| 8 | 64 | Uppercase printable description, padded with spaces |
| 72 | 1 | Category ID, zero-based |
| 73 | 1 | Flags: bit 0 = oversized payload; other bits reserved |
| 74 | 2 | Stored program length; category records use item count |
| 76 | 1 | Container ID (`0` means `P000.DAT`) |
| 77 | 2 | Byte offset within container payload, excluding PRG prefix |
| 79 | 2 | First icon frame ID, excluding ICONS.DAT header |
| 81 | 1 | Animation control: high two bits = frames minus one; low six = speed |
| 82 | 14 | Reserved, zero |

INDEX.DAT is globally alphabetical. Filtering by category preserves that order.
CATS.DAT follows the `order` values in `programs/*/category.json`; it supports
up to 256 categories because the record category ID is an unsigned byte. The
launcher holds twelve records per screen page and streams additional category
or program pages from the start of the file; late pages take longer to reach on
a physical drive.

## ICONS.DAT

SEQ header: `SICO`, version byte `1`, frame-size byte `36`, 16-bit frame count.
Frames are stored first for categories, then for programs in index order.

Every frame is exactly 36 bytes:

| Offset | Contents |
| --- | --- |
| 0–7 | Top-left cell, one byte per scanline, bit 7 = leftmost pixel |
| 8–15 | Top-right cell |
| 16–23 | Bottom-left cell |
| 24–31 | Bottom-right cell |
| 32–35 | Four VIC-II screen color bytes, same cell order |

Each color byte uses bits 7–4 for the foreground palette index and bits 3–0
for background. Each frame may therefore have different foreground/background
pairs in each cell. Animation frames are adjacent and loaded together for the
twelve visible entries. Maximum page icon RAM: 12 × 4 × 36 = 1728 bytes.

Speed is `speed * 16` ms per frame for values 1–63. Speed 0 means one video
frame per icon frame, not a zero-duration infinite loop. PAL/NTSC refresh
quantizes the transition time. A four-frame speed-63 loop requests 4032 ms.

## Program containers

P000.DAT, P001.DAT, etc. are PRG files with a two-byte `$a000` load address,
followed by at most 8192 payload bytes. Program payloads are adjacent with no
padding, local header, or per-program load-address prefix. Programs must be
assembled to run at `$c000` regardless of their pack offset.

An entry of length 256 is compliant. An entry of length 257–4096 requires
`--allow-oversize`, sets flag bit 0, and is visibly marked in the launcher.
The 256-byte rule covers all game-specific compiled code/data; it excludes
shared launcher services and the separately stored catalog/artwork. It limits
stored payload rather than runtime capability: after launch, programs run in
the C64 execution area and can use the shared API and its documented memory.
The API's fixed vector table occupies 30 bytes from `$1000` through `$101d`;
this does not state a total implementation size for the shared routines.

## C64 RAM

| Range | Use |
| --- | --- |
| `$0801–$3fff` | BASIC boot line, launcher code/state, spare launcher space |
| `$4000–$43ff` | Bitmap color matrix |
| `$4700–$475f` | Stream record scratch buffer |
| `$4800–$4c7f` | Twelve catalog records |
| `$5000–$56bf` | Visible icon frames |
| `$5800–$5fff` | Uppercase ROM glyph copy |
| `$6000–$7fff` | High-resolution bitmap |
| `$8000–$83ff` | Second bitmap color matrix while using shared graphics API |
| `$a000–$bfff` | Program container; reused as a second bitmap after launch |
| `$c000–$cfff` | Running program and its private RAM |

Launcher zero-page pointers use `$f7–$fe`. Games may use the documented BASIC
scratch area when they call only the specified services; see program-api.md.

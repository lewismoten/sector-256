## How the disk is organized

`LOADER` is a PRG. `INDEX.DAT`, `CATS.DAT`, and `ICONS.DAT` are ordinary SEQ
files. `P000.DAT`, `P001.DAT`, etc. are PRG containers holding up to 8 KB of
consecutively packed program payloads. Each index record stores a pack ID, byte
offset, and length. No game is aligned or padded to a 256-byte sector.

REL files are unnecessary here: standard Commodore REL record lengths top out
at 254 bytes, and records have side-sector overhead. The launcher instead
streams the index/icons and loads the selected 8 KB container into RAM. It
copies just the selected payload to `$c000`. It reloads the container on launch;
there is no container cache in this version.

The catalog supports 16-bit entry counts and pagination, including more than
683 entries, subject to the D64's actual capacity. Icons and 96-byte index
records consume meaningful space: this is a 256-byte *program* collection,
not a promise that 683 complete entries with artwork fit on a disk. The builder
raises an error when disk sectors are exhausted.

[Home](../readme.md)
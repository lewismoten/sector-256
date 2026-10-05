"""Small standard 35-track CBM DOS disk writer; PRG and SEQ files."""
SECTORS = [0] + [21] * 17 + [19] * 7 + [18] * 6 + [17] * 5


def sector_offset(track, sector):
    if not 1 <= track <= 35 or not 0 <= sector < SECTORS[track]:
        raise ValueError("invalid track/sector")
    return (sum(SECTORS[:track]) + sector) * 256


def make_disk(files, name="SECTOR 256", disk_id="S2"):
    if len(files) > 144:
        raise ValueError("standard directory supports at most 144 files")
    disk = bytearray(174848)
    used = {(18, 0)}
    directory_blocks = max(1, (len(files) + 7) // 8)
    used.update((18, i + 1) for i in range(directory_blocks))
    # A C64 begins by reading the directory/BAM on track 18.  Keep the
    # boot path immediately adjacent to it: callers put LOADER, indexes, and
    # packs in priority order, so allocate tracks 17, 19, 16, 20, ... first.
    # This is still a standard D64; only physical placement changes.
    track_order = [track for distance in range(1, 18)
                   for track in (18 - distance, 18 + distance)
                   if 1 <= track <= 35]
    free = [(track, sector) for track in track_order
            for sector in range(SECTORS[track])]
    cursor = 0
    for i, (filename, payload, kind) in enumerate(files):
        blocks = max(1, (len(payload) + 253) // 254)
        chain = free[cursor:cursor + blocks]
        if len(chain) != blocks:
            raise ValueError("D64 is full")
        cursor += blocks
        used.update(chain)
        for j, (track, sector) in enumerate(chain):
            base = sector_offset(track, sector)
            chunk = payload[j * 254:(j + 1) * 254]
            disk[base:base + 2] = bytes(chain[j + 1]) if j + 1 < blocks else bytes((0, len(chunk) + 1))
            disk[base + 2:base + 2 + len(chunk)] = chunk
        entry = sector_offset(18, i // 8 + 1) + (i % 8) * 32
        disk[entry + 2] = {"PRG": 0x82, "SEQ": 0x81}[kind]
        disk[entry + 3:entry + 5] = bytes(chain[0])
        disk[entry + 5:entry + 21] = filename.encode("ascii").ljust(16, b"\xa0")
        disk[entry + 30:entry + 32] = blocks.to_bytes(2, "little")
    for i in range(directory_blocks):
        base = sector_offset(18, i + 1)
        disk[base:base + 2] = bytes((18, i + 2)) if i + 1 < directory_blocks else b"\x00\xff"
    bam = sector_offset(18, 0)
    disk[bam:bam + 4] = bytes((18, 1, 0x41, 0))
    for track in range(1, 36):
        available = [s for s in range(SECTORS[track]) if (track, s) not in used]
        bits = sum(1 << s for s in available)
        pos = bam + 4 + (track - 1) * 4
        disk[pos:pos + 4] = bytes((len(available),)) + bits.to_bytes(3, "little")
    disk[bam + 0x90:bam + 0xa0] = name.encode("ascii").ljust(16, b"\xa0")
    disk[bam + 0xa0:bam + 0xab] = b"\xa0\xa0" + disk_id.encode("ascii") + b"\xa02A\xa0\xa0\xa0\xa0"
    return bytes(disk)


def read_disk(disk):
    """Read directory and file chains, also useful for verification."""
    result = {}
    track, sector = 18, 1
    seen_dirs = set()
    while track:
        if (track, sector) in seen_dirs:
            raise ValueError("directory cycle")
        seen_dirs.add((track, sector))
        base = sector_offset(track, sector)
        for i in range(8):
            entry = base + i * 32
            if disk[entry + 2] & 7 not in (1, 2):
                continue
            filename = disk[entry + 5:entry + 21].rstrip(b"\xa0").decode("ascii")
            t, s = disk[entry + 3:entry + 5]
            data = bytearray()
            seen = set()
            while t:
                if (t, s) in seen:
                    raise ValueError("file chain cycle")
                seen.add((t, s))
                p = sector_offset(t, s)
                nt, ns = disk[p:p + 2]
                data.extend(disk[p + 2:p + 256] if nt else disk[p + 2:p + 1 + ns])
                t, s = nt, ns
            result[filename] = bytes(data)
        track, sector = disk[base:base + 2]
    return result

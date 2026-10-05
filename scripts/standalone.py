#!/usr/bin/env python3
"""Build self-contained BASIC-loadable Sector 256 program PRGs."""
import argparse
import shutil
import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
API_VECTORS = {
    "WAITKEY": 0x1000,
    "CLEAR": 0x1003,
    "PUTCHAR": 0x1006,
    "RANDOM": 0x1009,
    "POLLKEY": 0x100C,
    "EXIT": 0x100F,
    "HIRES": 0x1012,
    "NEWFRAME": 0x1015,
    "LINE": 0x1018,
    "FLIP": 0x101B,
}
PAYLOAD_ADDRESS = 0xC000
MAX_PAYLOAD_SIZE = 4096


def _assemble(assembler, source, output, include):
    subprocess.run(
        [assembler, "--m6502", "--case-sensitive", "--long-branch", "--cbm-prg",
         "-I", str(include), "-o", str(output), str(source)],
        check=True, capture_output=True, text=True,
    )
    binary = output.read_bytes()
    if len(binary) < 3:
        raise ValueError(f"{source}: assembler produced an empty PRG")
    return int.from_bytes(binary[:2], "little"), binary[2:]


def _sources(root, program_sources):
    if program_sources is None:
        program_sources = sorted((root / "programs").glob("*/*/main.asm"))
    sources = [Path(source).resolve() for source in program_sources]
    if not sources:
        raise ValueError("no program sources supplied")
    if len({source.stem if source.name != "main.asm" else source.parent.name.upper() for source in sources}) != len(sources):
        raise ValueError("standalone output names must be unique")
    for source in sources:
        if not source.is_file():
            raise ValueError(f"missing program source: {source}")
    return sources


def _name(source):
    return (source.parent.name if source.name == "main.asm" else source.stem).upper()


def build_standalones(output_folder, program_sources=None, root=ROOT, assembler="64tass",
                      group_by_category=False):
    """Build selected (or all) programs into self-contained PRGs in output_folder.

    Each result is loaded at $0801, has a BASIC ``SYS 2061`` stub, exposes the
    stable API vectors at $1000..$101b, copies the program payload to $c000,
    and returns to BASIC through the embedded EXIT/RUN-STOP path. When
    ``group_by_category`` is true, artifacts use
    ``<output>/<CATEGORY>/<PROGRAM>/<PROGRAM>.PRG``.
    """
    root = Path(root).resolve()
    output_folder = Path(output_folder)
    api_source = root / "src" / "standalone_api.asm"
    output_folder.mkdir(parents=True, exist_ok=True)
    assembler = shutil.which(assembler) or assembler
    sources = _sources(root, program_sources)
    if not api_source.is_file():
        raise ValueError(f"missing standalone API template: {api_source}")

    report = {}
    with tempfile.TemporaryDirectory(prefix="sector256-standalone-") as directory:
        work = Path(directory)
        for source in sources:
            name = _name(source)
            payload_prg = work / f"{name}.payload.prg"
            address, payload = _assemble(assembler, source, payload_prg, root / "src")
            if address != PAYLOAD_ADDRESS:
                raise ValueError(f"{name}: entry/load address must be ${PAYLOAD_ADDRESS:04x}")
            if not 1 <= len(payload) <= MAX_PAYLOAD_SIZE:
                raise ValueError(f"{name}: supported payload range is 1..{MAX_PAYLOAD_SIZE} bytes")

            wrapper = work / f"{name}.asm"
            wrapper.write_text(
                f'.include "{api_source.as_posix()}"\n'
                'api_payload:\n'
                f'.binary "{payload_prg.as_posix()}", 2\n'
                'api_payload_end:\n'
                'api_payload_size = api_payload_end-api_payload\n'
                '.if api_payload_size > $1000\n'
                '.error "payload exceeds $c000-$cfff"\n'
                '.endif\n'
            )
            if group_by_category:
                category = source.parent.parent.name.upper()
                final = output_folder / category / name / f"{name}.PRG"
                final.parent.mkdir(parents=True, exist_ok=True)
            else:
                final = output_folder / f"{name}.prg"
            load_address, image = _assemble(assembler, wrapper, final, root / "src")
            if load_address != 0x0801:
                raise ValueError(f"{name}: standalone load address must be $0801")
            for vector_name, vector_address in API_VECTORS.items():
                offset = 2 + vector_address - load_address
                if final.read_bytes()[offset] != 0x4C:
                    raise ValueError(f"{name}: {vector_name} vector is not a JMP at ${vector_address:04x}")
            report[name] = {
                "path": final,
                "load_address": load_address,
                "payload_address": PAYLOAD_ADDRESS,
                "payload_size": len(payload),
                "api_size": len(image) - len(payload) - (0x1000 - load_address),
                "image_size": len(image),
            }
    return report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("output_folder", type=Path)
    parser.add_argument("sources", type=Path, nargs="*")
    parser.add_argument("--assembler", default="64tass")
    args = parser.parse_args()
    result = build_standalones(args.output_folder, args.sources or None, assembler=args.assembler)
    for name, info in result.items():
        print(f"{name:<8} {info['payload_size']:4} bytes -> {info['path']}")


if __name__ == "__main__":
    main()

#!/usr/bin/env sh
set -eu
cd "$(dirname "$0")/.."
command -v 64tass >/dev/null 2>&1 || {
    echo 'Install 64tass first: brew install 64tass, or sudo apt install 64tass.' >&2
    exit 1
}
python3 -m venv .venv
.venv/bin/python -m pip install -r requirements.txt
echo 'Ready. Run .venv/bin/python scripts/build.py'

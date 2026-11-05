#!/usr/bin/env bash
# Rebuild fonts/*.woff2 so they contain every character used in index.html.
# Run this after adding new text to the lesson, then bump VERSION in sw.js.
# Needs: python3, pip install fonttools brotli
set -euo pipefail
cd "$(dirname "$0")/.."
SRC="$(mktemp -d)"; trap 'rm -rf "$SRC"' EXIT
G=https://raw.githubusercontent.com/google/fonts/main/ofl
curl -sSfL "$G/notoserifkr/NotoSerifKR%5Bwght%5D.ttf"                 -o "$SRC/noto.ttf"
curl -sSfL "$G/sourceserif4/SourceSerif4%5Bopsz,wght%5D.ttf"          -o "$SRC/ss.ttf"
curl -sSfL "$G/sourceserif4/SourceSerif4-Italic%5Bopsz,wght%5D.ttf"   -o "$SRC/ssi.ttf"
curl -sSfL "$G/nanumpenscript/NanumPenScript-Regular.ttf"             -o "$SRC/pen.ttf"

python3 - "$SRC/chars.txt" <<'EOF'
import string, sys
s = open('index.html', encoding='utf-8').read()
chars = set(s) | set(string.printable) | set('·–—‘’“”…×÷±→←↑↓℃°²³½∝≈≠≤≥')
open(sys.argv[1], 'w', encoding='utf-8').write(''.join(sorted(c for c in chars if ord(c) >= 32)))
EOF

python3 -m fontTools.varLib.instancer "$SRC/noto.ttf" wght=400:900 -o "$SRC/noto-l.ttf" -q
python3 -m fontTools.varLib.instancer "$SRC/ss.ttf"   wght=400:700 -o "$SRC/ss-l.ttf" -q
python3 -m fontTools.varLib.instancer "$SRC/ssi.ttf"  wght=400:600 -o "$SRC/ssi-l.ttf" -q

O=(--text-file="$SRC/chars.txt" --flavor=woff2 --layout-features='*' --no-hinting --desubroutinize)
pyftsubset "$SRC/noto-l.ttf" "${O[@]}" --output-file=fonts/noto-serif-kr.woff2
pyftsubset "$SRC/ss-l.ttf"   "${O[@]}" --output-file=fonts/source-serif-4.woff2
pyftsubset "$SRC/ssi-l.ttf"  "${O[@]}" --output-file=fonts/source-serif-4-italic.woff2
pyftsubset "$SRC/pen.ttf"    "${O[@]}" --output-file=fonts/nanum-pen-script.woff2
ls -l fonts/*.woff2
echo "Done. Now bump VERSION in sw.js."

#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

latexindent -s -wd -m -c=/tmp/ -l=latexindent.yaml preamble.tex

for dir in */; do
    if [ -f "$dir/Makefile" ]; then
        echo "Formatting $dir..."
        make -C "$dir" format || { echo "Format failed in $dir"; exit 1; }
    fi
done

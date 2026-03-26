#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

# Build all LaTeX projects that have a Makefile
for dir in */; do
    if [ -f "$dir/Makefile" ]; then
        echo "Building $dir..."
        make -C "$dir" || { echo "Build failed in $dir"; exit 1; }
    fi
done

#!/bin/bash

# Makes sure the script is executed from its own current directory
cd "$(dirname "$0")"

TIMES=${TIMES:-50}
VERSION="$(python3 -V 2>&1 | sed 's/ /_/g')"
mkdir -p ./python_benchmarks
hyperfine --runs $TIMES --time-unit second "python3 ./indexof.py" --warmup 3 \
    --export-json ./python_benchmarks/bench_$VERSION.json -n "$VERSION"

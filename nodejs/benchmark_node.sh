#!/bin/bash

# Makes sure the script is executed from its own current directory
cd "$(dirname "$0")"

TIMES=${TIMES:-50}
VERSION="node_$(node -v)"
mkdir -p ./node_benchmarks
hyperfine --runs $TIMES --time-unit second "node ./indexof.js" --warmup 3 \
    --export-json ./node_benchmarks/bench_$VERSION.json -n "$VERSION"

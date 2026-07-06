#!/bin/bash

# Makes sure the script is executed from its own current directory
cd "$(dirname "$0")"

TIMES=${TIMES:-50}
VERSION="streamsearch_$(node -v)"
mkdir -p ./streamsearch_benchmarks
hyperfine --runs $TIMES --time-unit second "node ./indexof.js" --warmup 3 \
    --export-json ./streamsearch_benchmarks/bench_$VERSION.json -n "$VERSION"

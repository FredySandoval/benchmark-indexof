#!/bin/bash

# Makes sure the script is executed from its own current directory
cd "$(dirname "$0")"

TIMES=${TIMES:-50}
VERSION="$(go version | awk '{print $3}')"
mkdir -p ./go_benchmarks
hyperfine --runs $TIMES --time-unit second "./indexof" --warmup 3 \
    --export-json ./go_benchmarks/bench_$VERSION.json -n "$VERSION"

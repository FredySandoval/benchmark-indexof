#!/bin/bash

cd "$(dirname "$0")"

TIMES=${TIMES:-50}
VERSION="gcc_$(gcc -dumpfullversion)"
mkdir -p ./c_benchmarks
hyperfine --runs $TIMES --time-unit second "./indexof" --warmup 3 \
    --export-json ./c_benchmarks/bench_$VERSION.json -n "c_$VERSION"

#!/bin/bash

# Makes sure the script is executed from its own current directory
cd "$(dirname "$0")"

TIMES=${TIMES:-50}
VERSION="rustc_$(rustc --version | awk '{print $2}')"
mkdir -p ../../rust_benchmarks
hyperfine --runs $TIMES --time-unit second "./indexof" --warmup 3 \
    --export-json ../../rust_benchmarks/bench_$VERSION.json -n "$VERSION"
hyperfine --runs $TIMES --time-unit second "./indexof_naive" --warmup 3 \
    --export-json ../../rust_benchmarks/bench_${VERSION}_naive.json -n "${VERSION}_naive"

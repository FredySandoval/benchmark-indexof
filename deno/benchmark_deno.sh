#!/bin/bash

# Makes sure the script is executed from its own current directory
cd "$(dirname "$0")"

TIMES=${TIMES:-50}
VERSION="deno_$(deno --version | head -1 | awk '{print $2}')"
mkdir -p ./deno_benchmarks
# warm the jsr dependency cache before timing
deno cache ./indexof.ts
hyperfine --runs $TIMES --time-unit second "deno run --allow-read ./indexof.ts" --warmup 3 \
    --export-json ./deno_benchmarks/bench_$VERSION.json -n "$VERSION"

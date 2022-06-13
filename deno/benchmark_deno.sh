#!/bin/bash

# Makes sure the script is executed from its onw current directory
cd "$(dirname "$0")"

TIMES=100
# Get the python version
VERSION=deno_1.22.1
hyperfine --runs $TIMES --time-unit second "deno run --allow-read ./indexof.ts" --warmup 3 --export-json ./deno_benchmarks/bench_$VERSION.json -n $VERSION
#!/bin/bash

# Makes sure the script is executed from its onw current directory
cd "$(dirname "$0")"

TIMES=100
# Get the python version
VERSION=streamsearch
hyperfine --runs $TIMES --time-unit second "node ./indexof.js" --warmup 3 --export-json ./streamsearch_benchmarks/bench_$VERSION.json -n $VERSION
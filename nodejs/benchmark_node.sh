#!/bin/bash

# Makes sure the script is executed from its onw current directory
cd "$(dirname "$0")"

TIMES=100
# Get the python version
VERSION=v16.15.1
fnm use $VERSION
hyperfine --runs $TIMES --time-unit second "node ./indexof.js" --warmup 3 --export-json ./node_benchmarks/bench_node_$VERSION.json -n $VERSION
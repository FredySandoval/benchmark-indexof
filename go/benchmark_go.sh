#!/bin/bash

# Makes sure the script is executed from its onw current directory
cd "$(dirname "$0")"

TIMES=100
# Get the python version
VERSION=go1.18.2
hyperfine --runs $TIMES --time-unit second "./indexof" --warmup 3 --export-json ./go_benchmarks/bench_$VERSION.json -n $VERSION
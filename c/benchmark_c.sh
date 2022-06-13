#!/bin/bash

cd "$(dirname "$0")"

TIMES=100
# Get the python version
VERSION=gcc12.1.0
hyperfine --runs $TIMES --time-unit second "./a.out" --warmup 3 --export-json ./c_benchmarks/bench_$VERSION.json -n $VERSION
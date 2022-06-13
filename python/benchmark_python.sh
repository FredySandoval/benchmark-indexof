#!/bin/bash

# Makes sure the script is executed from its onw current directory
cd "$(dirname "$0")"

TIMES=100
# Get the python version
PYTHONVERSION=$(python -V 2>&1 | sed 's/ /_/g')
hyperfine --runs $TIMES --time-unit second "python ./indexof.py" --warmup 3 --export-json ./python_benchmarks/bench_$PYTHONVERSION.json -n $PYTHONVERSION
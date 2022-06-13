#!/bin/bash

# Makes sure the script is executed from its onw current directory
# SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
# echo $SCRIPT_DIR
# cd $SCRIPT_DIR

# Makes sure the script is executed from its onw current directory
cd "$(dirname "$0")"

TIMES=100
# Get the python version
VERSION=rustc_1.61.0
hyperfine --runs $TIMES --time-unit second "./indexof" --warmup 3 --export-json ../../rust_benchmarks/bench_$VERSION.json -n $VERSION 
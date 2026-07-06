#!/bin/bash
# Benchmarks indexof.js across several Node versions using fnm.
# Edit NODEVERSIONS to compare the versions you care about.

# Makes sure the script is executed from its own current directory
cd "$(dirname "$0")"

TIMES=${TIMES:-50}
NODEVERSIONS=("v20" "v22" "v24" "v26")

if ! [ -x "$(command -v fnm)" ]; then
    echo "fnm is required: https://github.com/Schniz/fnm" >&2
    exit 1
fi
if ! [ -x "$(command -v hyperfine)" ]; then
    echo "hyperfine is required: https://github.com/sharkdp/hyperfine" >&2
    exit 1
fi

eval "$(fnm env)"
mkdir -p ./all_node_benchmarks

for version in "${NODEVERSIONS[@]}"; do
    fnm install $version
done

for version in "${NODEVERSIONS[@]}"; do
    fnm use $version
    V=$(node -v)
    echo "Benchmarking node $V"
    hyperfine --runs $TIMES --time-unit second "node ./indexof.js" --warmup 3 \
        --export-json ./all_node_benchmarks/bench_node_$V.json -n "node_$V"
done

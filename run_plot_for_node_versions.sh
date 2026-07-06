#!/bin/bash
# Plot the results produced by nodejs/benchmark_all_node.sh
# (one bench_*.json per Node version in nodejs/all_node_benchmarks/).

cd "$(dirname "$0")"

FILES=$(find ./nodejs/all_node_benchmarks -name 'bench_*.json' | sort -V)

if [ -z "$FILES" ]; then
    echo "No results in nodejs/all_node_benchmarks/."
    echo "Run 'bash nodejs/benchmark_all_node.sh' first (requires fnm)."
    exit 1
fi

python3 ./scripts/my_plot.py --title "Node versions" --files $FILES "$@"

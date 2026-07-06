#!/bin/bash
# Plot whatever benchmark result files exist (produced by run_benchmarks.sh).

cd "$(dirname "$0")"

FILES=$(find . -path ./results/archive-2022 -prune -o -name 'bench_*.json' -print | sort)

if [ -z "$FILES" ]; then
    echo "No bench_*.json files found. Run 'npm run start' first."
    exit 1
fi

python3 ./scripts/my_plot.py --files $FILES --title "indexOf benchmark (streaming, end-to-end)" "$@"

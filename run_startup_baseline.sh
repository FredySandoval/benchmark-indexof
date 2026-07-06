#!/bin/bash
# Measures bare runtime startup time (a no-op program) so it can be
# accounted for when reading the end-to-end results. Compiled languages
# are ~1ms; interpreters/runtimes pay a fixed boot cost per process.

cd "$(dirname "$0")"
mkdir -p results

hyperfine --warmup 3 --time-unit millisecond \
    -n "node_$(node -v)"   "node -e ''" \
    -n "deno_$(deno --version | head -1 | awk '{print $2}')" "deno eval ''" \
    -n "python_$(python3 -V | awk '{print $2}')" "python3 -c ''" \
    --export-json results/startup_baseline.json

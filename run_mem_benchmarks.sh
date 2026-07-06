#!/bin/bash
# In-memory search benchmark: each implementation loads the first 256MiB
# of file.bin and times the search alone, excluding file I/O and process
# startup. This isolates the actual indexOf/substring-search cost, which
# the end-to-end streaming benchmark cannot (it is memory/I/O bound).

cd "$(dirname "$0")"
mkdir -p results
OUT=results/mem_results.txt
: > "$OUT"

run() {
    local name=$1; shift
    echo "== $name =="
    local line
    line=$( "$@" )
    echo "$line"
    echo "$name $line" >> "$OUT"
}

run "c_gcc_$(gcc -dumpfullversion)"          ./c/indexof --mem ./sample_file/file.bin
run "rust_$(rustc --version | awk '{print $2}')" ./rust/indexof/src/indexof --mem ./sample_file/file.bin
run "go_$(go version | awk '{print $3}')"    ./go/indexof --mem ./sample_file/file.bin
run "node_$(node -v)"                        node ./nodejs/indexof.js --mem ./sample_file/file.bin
run "deno_$(deno --version | head -1 | awk '{print $2}')" deno run --allow-read ./deno/indexof.ts --mem ./sample_file/file.bin
run "python_$(python3 -V | awk '{print $2}')" python3 ./python/indexof.py --mem ./sample_file/file.bin

echo
echo "Results saved to $OUT"

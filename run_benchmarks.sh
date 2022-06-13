#!/bin/bash

ALL=(
    "./nodejs/benchmark_node.sh"
    "./go/benchmark_go.sh"
    "./deno/benchmark_deno.sh"
    "./c/benchmark_c.sh" 
    "./python/benchmark_python.sh"
    "./rust/indexof/src/benchmark_rust.sh"
    "./streamsearch/benchmark_streamsearch.sh"
)

for i in "${ALL[@]}"
do
    echo "Running $i"
    (sh $i)
done
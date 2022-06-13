NODE=./nodejs/node_benchmarks/bench_node_v16.15.1.json
PYTHON=./python/python_benchmarks/bench_Python_3.10.4.json
GO=./go/go_benchmarks/bench_go1.18.2.json
RUST=./rust/rust_benchmarks/bench_rustc_1.61.0.json
DENO=./deno/deno_benchmarks/bench_deno_1.22.1.json
STREAMSEARCH=./streamsearch/streamsearch_benchmarks/bench_streamsearch.json
C=./c/c_benchmarks/bench_gcc12.1.0.json

python ./scripts/my_plot.py --files $DENO $STREAMSEARCH  $RUST $NODE $GO $PYTHON $C  
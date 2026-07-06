#!/bin/bash

# Makes sure the script is executed from its own current directory
cd "$(dirname "$0")"

# build both the memmem-based and the naive variant
cargo build --release --manifest-path ../Cargo.toml
cp ../target/release/indexof ./
cp ../target/release/indexof_naive ./

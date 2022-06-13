#!/bin/bash

# Makes sure the script is executed from its onw current directory
cd "$(dirname "$0")"

# build rust release indexof file
cargo build --release
sleep 1
mv ../target/release/indexof ./

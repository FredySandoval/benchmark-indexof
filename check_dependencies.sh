#!/bin/bash

DEPENDENCIES=(
    "node"
    "go"
    "deno"
    "gcc"
    "python3"
    "rustc"
)
# Loop through the dependencies
# Check if the dependencies are installed
# If not, exit
for i in "${DEPENDENCIES[@]}"
do
    # Check if the dependency is installed
    if ! [ -x "$(command -v $i)" ]; then
        echo "Dependency $i is not installed, Install it and run this script again"
        exit 1
    fi
done

echo "All dependencies are installed"

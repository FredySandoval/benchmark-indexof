#!/bin/bash

# Makes sure the script is executed from its own current directory
cd "$(dirname "$0")"

if [ -x "$(command -v gcc)" ]; then
    gcc -O2 indexof.c -o indexof
else
    echo 'gcc is not installed'
    exit 1
fi

#!/bin/bash

# Makes sure the script is executed from its onw current directory
cd "$(dirname "$0")"

if [ -x "$(command -v gcc)" ]; then
    gcc indexof.c -o indexof
else
    echo 'gcc is not installed'
fi
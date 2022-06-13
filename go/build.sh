#!/bin/bash

# Makes sure the script is executed from its onw current directory
cd "$(dirname "$0")"

# Check if go is installed
if ! [ -x "$(command -v go)" ]; then
  echo 'Error: go is not installed.' >&2
  exit 1
fi
go build -ldflags "-s -w" indexof.go
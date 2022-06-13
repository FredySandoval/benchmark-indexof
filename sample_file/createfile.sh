#!/bin/bash

# Makes sure the script is executed from its onw current directory
cd "$(dirname "$0")"

# check if file.bin exists
FILE=./file.bin
if [ -f "$FILE" ]; then
    echo "file.bin exists skipping creation"
else
    echo "Creating file.bin with random characters"
  
    head -c 10G /dev/urandom > ./file.bin

    # Adding "boundary" to the end of the file
    # For a 10GB file, the boundary will be at index position 10737418240
    echo "--boundary--" >> ./file.bin

    # Adding 10 zero characters to the end of the file just because.
    echo "0000000000" >> ./file.bin
fi

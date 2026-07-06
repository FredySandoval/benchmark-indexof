#!/bin/bash

# Makes sure the script is executed from its own current directory
cd "$(dirname "$0")"

# File size is configurable: FILE_SIZE=10G bash createfile.sh
# Default is 1G so contributors can run the benchmark without 10GB free.
SIZE=${FILE_SIZE:-1G}

FILE=./file.bin
if [ -f "$FILE" ]; then
    echo "file.bin exists, skipping creation (delete it to regenerate)"
else
    echo "Creating $SIZE file.bin with random bytes"
    head -c "$SIZE" /dev/urandom > "$FILE"

    # The needle sits at the very end so every implementation must
    # stream the whole file (worst case).
    echo "--boundary--" >> "$FILE"
    echo "0000000000" >> "$FILE"
fi

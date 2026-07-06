"""Streaming search for a needle in a file, 64KiB chunks.

Handles needles that straddle chunk boundaries by carrying over
the last (len(needle) - 1) bytes of each chunk.

Usage: python3 indexof.py [--mem] [file]
  --mem: load the first 256MiB into memory and time the search alone
         (isolates the find() cost from I/O and process startup).
"""
import os
import sys
import time

NEEDLE = b"--boundary--"
CHUNK = 65536
MEM_BYTES = 256 * 1024 * 1024
MEM_RUNS = 10

DEFAULT_FILE = os.path.join(os.path.dirname(__file__), "../sample_file/file.bin")


def mem_bench(path):
    size = min(os.path.getsize(path), MEM_BYTES)
    with open(path, "rb") as f:
        data = f.read(size)

    found = -1
    start = time.perf_counter()
    for _ in range(MEM_RUNS):
        found = data.find(NEEDLE)
    elapsed = time.perf_counter() - start

    avg = elapsed / MEM_RUNS
    gibs = size / avg / 1024**3
    print(f"mem-search bytes={size} runs={MEM_RUNS} avg_ms={avg * 1000:.2f} "
          f"throughput_gib_s={gibs:.2f} index={found}")


def stream_bench(path):
    offset = 0  # global index of the start of `hay`
    chunks = 0
    tail = b""
    with open(path, "rb") as f:
        while True:
            chunk = f.read(CHUNK)
            if not chunk:
                break
            chunks += 1
            hay = tail + chunk if tail else chunk
            i = hay.find(NEEDLE)
            if i != -1:
                print("Number of chunks:", chunks)
                print("Found index at:", offset + i)
                return
            keep = min(len(hay), len(NEEDLE) - 1)
            tail = hay[len(hay) - keep:]
            offset += len(hay) - keep


def main():
    args = sys.argv[1:]
    mem_mode = "--mem" in args
    files = [a for a in args if a != "--mem"]
    path = files[0] if files else DEFAULT_FILE
    if mem_mode:
        mem_bench(path)
    else:
        stream_bench(path)


if __name__ == "__main__":
    main()

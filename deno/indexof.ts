// Streaming search for a needle in a file, 64KiB chunks (Deno 2.x APIs).
// Handles needles that straddle chunk boundaries by carrying over the
// last (needle.length - 1) bytes of each chunk.
//
// Usage: deno run --allow-read indexof.ts [--mem] [file]
//   --mem: load the first 256MiB into memory and time the search alone
//          (isolates the search cost from I/O and process startup).

import { indexOfNeedle } from "jsr:@std/bytes@1/index-of-needle";

const NEEDLE = new TextEncoder().encode("--boundary--");
const CHUNK = 65536;
const MEM_BYTES = 256 * 1024 * 1024;
const MEM_RUNS = 10;

const args = Deno.args;
const memMode = args.includes("--mem");
const path = args.find((a) => a !== "--mem") ??
  new URL("../sample_file/file.bin", import.meta.url).pathname;

async function memBench() {
  using file = await Deno.open(path, { read: true });
  const stat = await file.stat();
  const size = Math.min(stat.size, MEM_BYTES);
  const data = new Uint8Array(size);
  let read = 0;
  while (read < size) {
    const n = await file.read(data.subarray(read));
    if (n === null) break;
    read += n;
  }

  let found = -1;
  const start = performance.now();
  for (let i = 0; i < MEM_RUNS; i++) found = indexOfNeedle(data, NEEDLE);
  const avg = (performance.now() - start) / 1000 / MEM_RUNS;

  const gibs = size / avg / 1024 ** 3;
  console.log(
    `mem-search bytes=${size} runs=${MEM_RUNS} avg_ms=${
      (avg * 1000).toFixed(2)
    } throughput_gib_s=${gibs.toFixed(2)} index=${found}`,
  );
}

async function streamBench() {
  using file = await Deno.open(path, { read: true });
  const overlap = NEEDLE.length - 1;
  const buf = new Uint8Array(overlap + CHUNK);
  let tail = 0; // carried-over bytes at the start of buf
  let offset = 0; // global index of buf[0]
  let chunks = 0;

  while (true) {
    const n = await file.read(buf.subarray(tail, tail + CHUNK));
    if (n === null) break;
    if (n === 0) continue;
    chunks++;
    const total = tail + n;
    const hay = buf.subarray(0, total);
    const i = indexOfNeedle(hay, NEEDLE);
    if (i !== -1) {
      console.log("Number of chunks:", chunks);
      console.log("Found index at:", offset + i);
      return;
    }
    const keep = Math.min(overlap, total);
    buf.copyWithin(0, total - keep, total);
    offset += total - keep;
    tail = keep;
  }
}

if (memMode) await memBench();
else await streamBench();

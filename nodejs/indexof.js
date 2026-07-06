'use strict';
// Streaming search for a needle in a file, 64KiB chunks.
// Handles needles that straddle chunk boundaries by carrying over
// the last (needle.length - 1) bytes of each chunk.
//
// Usage: node indexof.js [--mem] [file]
//   --mem: load the first 256MiB into memory and time the search alone
//          (isolates indexOf cost from I/O and process startup).

const fs = require('fs');
const path = require('path');

const NEEDLE = Buffer.from('--boundary--');
const CHUNK = 65536;
const MEM_BYTES = 256 * 1024 * 1024;
const MEM_RUNS = 10;

const args = process.argv.slice(2);
const memMode = args.includes('--mem');
const file = args.find((a) => a !== '--mem')
    || path.join(__dirname, '../sample_file/file.bin');

function memBench() {
    const size = Math.min(fs.statSync(file).size, MEM_BYTES);
    const data = Buffer.alloc(size);
    const fd = fs.openSync(file, 'r');
    fs.readSync(fd, data, 0, size, 0);
    fs.closeSync(fd);

    let found = -1;
    const start = process.hrtime.bigint();
    for (let i = 0; i < MEM_RUNS; i++) found = data.indexOf(NEEDLE);
    const elapsed = Number(process.hrtime.bigint() - start) / 1e9;

    const avg = elapsed / MEM_RUNS;
    const gibs = size / avg / 1024 ** 3;
    console.log(`mem-search bytes=${size} runs=${MEM_RUNS} avg_ms=${(avg * 1000).toFixed(2)} throughput_gib_s=${gibs.toFixed(2)} index=${found}`);
}

function streamBench() {
    const stream = fs.createReadStream(file, { highWaterMark: CHUNK });
    let offset = 0; // global index of the start of `hay`
    let chunks = 0;
    let tail = Buffer.alloc(0);

    stream.on('data', (chunk) => {
        chunks++;
        const hay = tail.length ? Buffer.concat([tail, chunk]) : chunk;
        const i = hay.indexOf(NEEDLE);
        if (i !== -1) {
            console.log('Number of chunks:', chunks);
            console.log('Found index at:', offset + i);
            stream.destroy();
            return;
        }
        const keep = Math.min(hay.length, NEEDLE.length - 1);
        tail = hay.subarray(hay.length - keep);
        offset += hay.length - keep;
    });
}

if (memMode) memBench();
else streamBench();

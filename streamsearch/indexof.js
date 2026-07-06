'use strict';
// Streaming Boyer-Moore-Horspool search (the algorithm Busboy/Multer use
// via the streamsearch package). SBMH natively handles needles that
// straddle chunk boundaries, so no manual overlap is needed here.
//
// Usage: node indexof.js [file]

const path = require('path');
const fs = require('fs');
const StreamSearch = require('./sbmh.js'); // https://github.com/mscdex/streamsearch

const file = process.argv[2] || path.join(__dirname, '../sample_file/file.bin');
const reader = fs.createReadStream(file, { highWaterMark: 65536 });

let ind = 0;
let chunks = 0;
const needle = Buffer.from('--boundary--');
const ss = new StreamSearch(needle, (isMatch, data, start, end) => {
    ind += end;
    if (isMatch) {
        console.log('Number of chunks:', chunks);
        console.log('Found index at:', ind);
        reader.destroy();
    }
});

reader.on('data', (chunk) => {
    chunks++;
    ss.push(chunk);
});

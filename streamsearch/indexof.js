// apps like Busboy uses this to find the index of a file in a stream
const StreamSearch = require('./sbmh.js'); // https://github.com/mscdex/streamsearch

let fs = require('fs'),
    reader = fs.createReadStream("../sample_file/file.bin", { highWaterMark: 65536 });

var ind = 0;
var counter = 0;
const needle = Buffer.from('--boundary--');
const ss = new StreamSearch(needle, (isMatch, data, start, end) => {
    if (isMatch) {
        ind += end
        console.log('Number of chunks: ', counter);
        console.log('Found index at:', ind);
        return;
    } else {
        ind += end
    }
    
});

reader.on('data', function (chunk) {
    counter += 1;
    ss.push(chunk);

});
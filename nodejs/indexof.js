var fs = require('fs');
var reader = fs.createReadStream('../sample_file/file.bin');

var ind = 0;
var counter = 0;
reader.on('data', function (chunk) {
    var buff = chunk.indexOf('--boundary--');
    if (buff > -1) {
        counter++;
        ind += buff;
        console.log('Number of chunks: ', counter);
        console.log('Found index at:', ind);
        return;
    } else {
        counter++;
        ind += chunk.length;
    }
});

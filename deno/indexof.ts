import { indexOf } from "https://deno.land/std@0.96.0/bytes/mod.ts";

const file = await Deno.open("../sample_file/file.bin");
const readBlockSize = 65536;
let count = 0;
let ind = 0;

await Deno.seek(file.rid, 0, Deno.SeekMode.Current);
const buf = new Uint8Array(readBlockSize);

while (true) {
    const t = await file.read(buf);
    // let n = indexOf(buf, new Uint8Array([102, 114, 101, 100, 121]));
    let n = indexOf(buf, new Uint8Array([45, 45, 98, 111, 117, 110, 100, 97, 114, 121, 45, 45]))
    if (n != -1) {
        count += 1;
        ind += n;
       break;
    } else {
        ind += readBlockSize;
    }

    if (!t) { break; }

    count += 1;
}

console.log("Number of chunks: ", count);
console.log("Found Index At: ", ind);
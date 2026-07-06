// The original hand-rolled naive substring search (windows().position()),
// kept as a labeled variant to demonstrate that the 2022 "Rust is slow"
// result was an algorithm artifact, not a language property.
// Compare against the `indexof` binary, which uses memchr::memmem.
//
// Usage: ./indexof_naive [file]

use std::fs::File;
use std::io::{self, Read};

const NEEDLE: &[u8] = b"--boundary--";
const CHUNK: usize = 65536;

fn find_subsequence(haystack: &[u8], needle: &[u8]) -> Option<usize> {
    haystack
        .windows(needle.len())
        .position(|window| window == needle)
}

fn main() -> io::Result<()> {
    let path = std::env::args()
        .nth(1)
        .unwrap_or_else(|| String::from("../../../sample_file/file.bin"));
    let mut file = File::open(&path)?;

    let overlap = NEEDLE.len() - 1;
    let mut buf = vec![0u8; overlap + CHUNK];
    let mut tail = 0usize; // carried-over bytes at the start of buf
    let mut offset = 0u64; // global index of buf[0]
    let mut chunks = 0u64;

    loop {
        let n = file.read(&mut buf[tail..tail + CHUNK])?;
        if n == 0 {
            return Ok(());
        }
        chunks += 1;
        let total = tail + n;
        if let Some(i) = find_subsequence(&buf[..total], NEEDLE) {
            println!("Number of chunks: {}", chunks);
            println!("Found index at: {}", offset + i as u64);
            return Ok(());
        }
        let keep = overlap.min(total);
        buf.copy_within(total - keep..total, 0);
        offset += (total - keep) as u64;
        tail = keep;
    }
}

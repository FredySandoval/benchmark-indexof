// Streaming search for a needle in a file, 64KiB chunks, using the
// `memchr` crate's memmem (the idiomatic optimized substring search in
// Rust — the same class of algorithm as glibc's memmem used by the C
// version). See src/bin/indexof_naive.rs for the original naive search
// kept for comparison.
//
// Handles needles that straddle chunk boundaries by carrying over the
// last (needle.len() - 1) bytes of each chunk.
//
// Usage: ./indexof [--mem] [file]
//   --mem: load the first 256MiB into memory and time the search alone
//          (isolates the search cost from I/O and process startup).

use memchr::memmem::Finder;
use std::fs::File;
use std::io::{self, Read};
use std::time::Instant;

const NEEDLE: &[u8] = b"--boundary--";
const CHUNK: usize = 65536;
const MEM_BYTES: u64 = 256 * 1024 * 1024;
const MEM_RUNS: u32 = 10;

fn mem_bench(mut file: File) -> io::Result<()> {
    let size = file.metadata()?.len().min(MEM_BYTES) as usize;
    let mut data = vec![0u8; size];
    file.read_exact(&mut data)?;

    let finder = Finder::new(NEEDLE);
    let mut found: i64 = -1;
    let start = Instant::now();
    for _ in 0..MEM_RUNS {
        found = finder.find(&data).map_or(-1, |i| i as i64);
    }
    let avg = start.elapsed().as_secs_f64() / MEM_RUNS as f64;

    let gibs = size as f64 / avg / (1u64 << 30) as f64;
    println!(
        "mem-search bytes={} runs={} avg_ms={:.2} throughput_gib_s={:.2} index={}",
        size,
        MEM_RUNS,
        avg * 1000.0,
        gibs,
        found
    );
    Ok(())
}

fn stream_bench(mut file: File) -> io::Result<()> {
    let finder = Finder::new(NEEDLE);
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
        if let Some(i) = finder.find(&buf[..total]) {
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

fn main() -> io::Result<()> {
    let mut mem_mode = false;
    let mut path = String::from("../../../sample_file/file.bin");
    for arg in std::env::args().skip(1) {
        if arg == "--mem" {
            mem_mode = true;
        } else {
            path = arg;
        }
    }

    let file = File::open(&path)?;
    if mem_mode {
        mem_bench(file)
    } else {
        stream_bench(file)
    }
}

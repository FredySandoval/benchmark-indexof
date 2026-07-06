// Streaming search for a needle in a file, 64KiB chunks.
// Handles needles that straddle chunk boundaries by carrying over
// the last (len(needle) - 1) bytes of each chunk.
//
// Usage: ./indexof [--mem] [file]
//
//	--mem: load the first 256MiB into memory and time the search alone
//	       (isolates the bytes.Index cost from I/O and process startup).
package main

import (
	"bytes"
	"fmt"
	"io"
	"os"
	"time"
)

const (
	chunkSize = 65536
	memBytes  = 256 * 1024 * 1024
	memRuns   = 10
)

var needle = []byte("--boundary--")

func memBench(path string) error {
	f, err := os.Open(path)
	if err != nil {
		return err
	}
	defer f.Close()

	info, err := f.Stat()
	if err != nil {
		return err
	}
	size := info.Size()
	if size > memBytes {
		size = memBytes
	}
	data := make([]byte, size)
	if _, err := io.ReadFull(f, data); err != nil {
		return err
	}

	found := -1
	start := time.Now()
	for i := 0; i < memRuns; i++ {
		found = bytes.Index(data, needle)
	}
	elapsed := time.Since(start).Seconds()

	avg := elapsed / memRuns
	gibs := float64(size) / avg / (1 << 30)
	fmt.Printf("mem-search bytes=%d runs=%d avg_ms=%.2f throughput_gib_s=%.2f index=%d\n",
		size, memRuns, avg*1000, gibs, found)
	return nil
}

func streamBench(path string) error {
	f, err := os.Open(path)
	if err != nil {
		return err
	}
	defer f.Close()

	overlap := len(needle) - 1
	buf := make([]byte, overlap+chunkSize)
	tail := 0     // carried-over bytes at the start of buf
	offset := 0   // global index of buf[0]
	chunks := 0
	for {
		n, err := f.Read(buf[tail : tail+chunkSize])
		if n > 0 {
			chunks++
			hay := buf[:tail+n]
			if i := bytes.Index(hay, needle); i != -1 {
				fmt.Println("Number of chunks:", chunks)
				fmt.Println("Found index at:", offset+i)
				return nil
			}
			keep := overlap
			if len(hay) < keep {
				keep = len(hay)
			}
			copy(buf, hay[len(hay)-keep:])
			offset += len(hay) - keep
			tail = keep
		}
		if err == io.EOF {
			return nil
		}
		if err != nil {
			return err
		}
	}
}

func main() {
	memMode := false
	path := ""
	for _, a := range os.Args[1:] {
		if a == "--mem" {
			memMode = true
		} else {
			path = a
		}
	}
	if path == "" {
		path = "../sample_file/file.bin"
	}

	var err error
	if memMode {
		err = memBench(path)
	} else {
		err = streamBench(path)
	}
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}

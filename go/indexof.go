package main

import (
	"bufio"
	"bytes"
	"fmt"
	"io"
	"os"
)

func main() {
	file, err := os.Open("../sample_file/file.bin")

	if err != nil {
		fmt.Println("cannot read file")
		return
	}
	defer file.Close()

	r := bufio.NewReader(file)
	ind := 0
	count := 0
	for {
		buf := make([]byte, 65536) // create an array of 0.0625MB
		n, er := r.Read(buf)       //loading chunk into buffer
		_ = er
		buf = buf[:n]
		if n == 0 {

			if err != nil {
				fmt.Println(err)
				break
			}
			if err == io.EOF {
				break
			}
			fmt.Println(er)
			return
		}
		IndexFound := bytes.Index(buf, []byte("--boundary--"))
		if IndexFound != -1 {
			count++
			ind += IndexFound
			fmt.Println("Number of chunks: ", count)
			fmt.Println("Found index at:", ind)
			break
		} else {
			count++
			ind += len(buf)
		}
	}
}

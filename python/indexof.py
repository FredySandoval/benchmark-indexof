import os
import sys

def main():
    ind = 0
    counter = 0
    with open('../sample_file/file.bin', 'rb') as f:
        while True:
            chunk = f.read(65536)
            if not chunk:
                break
            if b'--boundary--' in chunk:
                ind += chunk.index(b"--boundary--")
                counter += 1
                print("Number of chunks read: ", counter)
                print("String found at index: ", ind)
                break
            else :
                counter += 1
                ind += 65536


if __name__ == '__main__':
    main()
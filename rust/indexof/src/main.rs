use std::{
    fs::File,
    io::{self, BufRead, BufReader},
};

fn find_subsequence(haystack: &[u8], needle: &[u8]) -> Option<usize> {
    haystack.windows( needle.len()).position(|window | window == needle)
}

fn main() -> io::Result<()> {
    const CAP: usize = 65536;
    let file = File::open("../../../sample_file/file.bin")?;
    let mut reader = BufReader::with_capacity(CAP, file);

    let needle: &[u8] = &[45, 45, 98, 111, 117, 110, 100, 97, 114, 121, 45, 45];


    let mut ind: usize = 0;
    let mut count: i32 = 0;
    
    loop {
        let length = {
            let buffer = reader.fill_buf()?;
            // do stuff with buffer here
            match find_subsequence(&buffer, &needle) {
                Some(index) => {
                    count += 1;
                    ind += index;
                    println!("Number of chunks {:?}", count);
                    println!("Found index {:?}.", ind);
                }
                None => {
                    count += 1;
                    ind += buffer.len();
                },
            }
            buffer.len()
        };
        if length == 0 {
            break;
        }
        reader.consume(length);
    }

    Ok(())
}
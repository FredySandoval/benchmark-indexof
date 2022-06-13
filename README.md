# benchmark-indexof
## benchmarks of the same node task in different languages
<p align="center">
<img src="https://user-images.githubusercontent.com/45242501/173290738-2b855a27-176d-4452-ae02-0fde0cbc6efa.png" alt="code image" width="whatever" height="500">
</p>

### Questions:
1. Is the same function or action faster in other languages?
2. Is it worth it to migrate my application to a different languate to improve speed?

Many packages like "Busboy" for example relies on searching a pattern on a buffer. In this repo I try to measure the same task under the same circumstances to see the differences in speed ans stabilify of the different languages.
### Constrains:
- The buffer size in all languages is 65536 bytes which is the default for NodeJS
- The file in which all languages looked was the same, and in this case is a 10GB with random binaries. 
- The string to be searched is the word "--boundary--" which is at the very end.
- All Languages were measured 100 times, 

In this first case, I tested the same application on NODEJS, NODEJS using StreamSearch, DENO, PYTHON 3, GO, RUST, C
I measured them using hyperfine on a fresh install of Manjaro using a CPU: AMD Ryzen 9 5950X (32) @ 3.400GHz, while no other program was running in the background.

# First Test - Different Languages.
<p align="center">
<img src="https://user-images.githubusercontent.com/45242501/173292689-ea571fb1-e53d-4a6b-a318-66b3ade73d68.png" alt="code image" width="whatever" height="500">
</p>
Deno: The first thing we notice is that DENO is the slowest and most unstable of them, I was definetely expecting this, and I believe this is one of the reasons it never took off, even though is written in rust, was very slow and unstable on this task.
<br/><br/>
StreamSearch: Applications like "Busboy" and others that depend on it like "Multer", both of them depend on StreamSearch that allows searching a stream using the Boyer-Moore-Horspool algorithm.
<br/><br/>
Rust: I always hear about how fast Rust is, but on this particular task was not particularly good, not to mention that was hard to write, and very unstable compare to the rest.
<br/><br/>
Node: The level of optimization that Node has, the large amount of documentation and how easy is to program, makes it the most used.
<br/><br/>
Go: On this particular case Go was superior to Rust, and was way more easy to write, well... compare with rust.
<br/><br/>
Python3: This result was a big surprise, but the level of optimization that python is receiving makes it one of the most used in the world.
<br/><br/>
C: This one was not a suprise, C is known for being extremly fast, but also is hard to write, and I wouldn't recommend to migrate to C due to this reason only.

<br/><br/>
# Second Test - Different Node versions.
<p align="center">
<img src="https://user-images.githubusercontent.com/45242501/173299529-59aa0471-8df9-42e0-98fb-354270b4c18b.png" alt="code image" width="whatever" height="500">
</p>
All versions performed around the same, but the latest version 18, did notably slow compared to the rest, so it may not be a good idea to upgrade to the latest version of Node, at least not yet.

# Final 
<p align="center">
<img src="https://user-images.githubusercontent.com/45242501/173300522-5b71402c-4efb-473a-9bee-75e004d968f8.png" alt="code image" width="whatever" height="500">
</p>
If I were to migrate an application to improve performance, I would definetely consider python 3.10.4 as one of my option, not just because is easy compare to Node or Go, but because is so use, the documentation is available everywere, even though the errors in the console are not friendly at all, and don't tell too much about the error itself, compare to Rust, for example which the errors in the console, tells exactly whats going on. 
<br/><br/>

# Instructions

clone the repo and run:

```bash
npm run create
npm run check
npm run build
npm run start
npm run plot
```

(manually install any language if missing example rust)

/* Streaming search for a needle in a file, 64KiB chunks.
 * Handles needles that straddle chunk boundaries by carrying over
 * the last (needle_len - 1) bytes of each chunk.
 *
 * Usage: ./indexof [--mem] [file]
 *   --mem: load the first 256MiB into memory and time the search alone
 *          (isolates the memmem cost from I/O and process startup).
 */
#define _GNU_SOURCE /* memmem */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define CHUNK 65536
#define MEM_BYTES (256L * 1024 * 1024)
#define MEM_RUNS 10

static const char NEEDLE[] = "--boundary--";
#define NEEDLE_LEN (sizeof(NEEDLE) - 1)

static double now_sec(void)
{
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return ts.tv_sec + ts.tv_nsec / 1e9;
}

static int mem_bench(FILE *file)
{
    char *data = malloc(MEM_BYTES);
    if (data == NULL)
    {
        fprintf(stderr, "out of memory\n");
        return 1;
    }
    size_t size = fread(data, 1, MEM_BYTES, file);

    const char *p = NULL;
    double start = now_sec();
    for (int i = 0; i < MEM_RUNS; i++)
        p = memmem(data, size, NEEDLE, NEEDLE_LEN);
    double avg = (now_sec() - start) / MEM_RUNS;

    long index = p ? (long)(p - data) : -1;
    double gibs = size / avg / (1024.0 * 1024.0 * 1024.0);
    printf("mem-search bytes=%zu runs=%d avg_ms=%.2f throughput_gib_s=%.2f index=%ld\n",
           size, MEM_RUNS, avg * 1000, gibs, index);
    free(data);
    return 0;
}

static int stream_bench(FILE *file)
{
    static char buf[NEEDLE_LEN - 1 + CHUNK];
    size_t tail = 0;         /* carried-over bytes at the start of buf */
    long long offset = 0;    /* global index of buf[0] */
    long long chunks = 0;
    size_t n;
    while ((n = fread(buf + tail, 1, CHUNK, file)) > 0)
    {
        chunks++;
        size_t total = tail + n;
        char *p = memmem(buf, total, NEEDLE, NEEDLE_LEN);
        if (p != NULL)
        {
            printf("Number of chunks: %lld\n", chunks);
            printf("Found index at: %lld\n", offset + (p - buf));
            return 0;
        }
        size_t keep = total < NEEDLE_LEN - 1 ? total : NEEDLE_LEN - 1;
        memmove(buf, buf + total - keep, keep);
        offset += total - keep;
        tail = keep;
    }
    return 0;
}

int main(int argc, char **argv)
{
    int mem_mode = 0;
    const char *path = "../sample_file/file.bin";
    for (int i = 1; i < argc; i++)
    {
        if (strcmp(argv[i], "--mem") == 0)
            mem_mode = 1;
        else
            path = argv[i];
    }

    FILE *file = fopen(path, "rb");
    if (file == NULL)
    {
        fprintf(stderr, "cannot read file %s\n", path);
        return 1;
    }
    int rc = mem_mode ? mem_bench(file) : stream_bench(file);
    fclose(file);
    return rc;
}

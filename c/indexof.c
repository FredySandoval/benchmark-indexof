#define _GNU_SOURCE         /* See feature_test_macros(7) */
#include <stdio.h>
// #include <stdlib.h>
#include <string.h>
// #include <sys/types.h>
// #include <unistd.h>
// #include <limits.h>

int main()
{
    FILE *file;
    file = fopen("../sample_file/file.bin", "r");
    if (file == NULL)
    {
        printf("cannot read file");
        return 0;
    }
    int i = 0;
    long long int ind = 0;
    long int buff_size = 65536;
    long int container = 0;
    int count = 0;
    char buf[65536]; // 65536 is the size of the buffer
    while (fread(buf, sizeof(char), 65536, file) != 0)
    {
        char *p = memmem(buf, 65536, "--bou", 5);
        // printf("%d\n", p);
        if (p != NULL)
        {
            count++;
            ind += p - buf;
            printf("Number of chunks: %d\n", count);
            printf("Found index at: %ld\n", ind);
            break;
        }
        else
        {
            count++;
            ind += 65536;
        }
       
    }
    fclose(file);
    return 0;
}
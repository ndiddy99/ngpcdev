#include <stdio.h>
#include <stdlib.h>

char buffer[16];

int main(int argc, char **argv) {
    if (argc < 3) {
        printf("Usage: bin2asm in.bin out.inc");
        return 0;
    }
    FILE *in = fopen(argv[1], "rb");
    FILE *out = fopen(argv[2], "w");

    int size;
    while ((size = fread(buffer, 1, sizeof(buffer), in))) {
        fprintf(out, "\tdb ");
        for (int i = 0; i < size; i++) {
            if (i < size - 1) {
                fprintf(out, "0x%02x,", buffer[i] & 0xff);
            }
            else {
                fprintf(out, "0x%02x\n", buffer[i] & 0xff);
            }
        }
    }
    fclose(in);
    fclose(out);
    return 0;
}

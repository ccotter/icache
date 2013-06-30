
#include <unistd.h>
#include <string.h>
#include <assert.h>
#include <stdint.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <stdio.h>

#define DIFF(a,b) ((long)(b) - (long)(a))

#define SYM(name) extern int name(void);
SYM(fun)
SYM(fun_ins)
SYM(fun_end)
SYM(fun2_ins)
SYM(fun2_end)

uint8_t zeros[0x1000];
int main(void)
{
    const char *fname = "code_area";
    int fd = open(fname, O_RDWR | O_CREAT, S_IRWXU | S_IRWXG | S_IRWXO);
    assert(fd>=0);
    write(fd, zeros, 0x1000);
    uint8_t *a1 = mmap(NULL, 0x1000,
            PROT_READ | PROT_WRITE | PROT_EXEC,
            MAP_FILE | MAP_SHARED, fd, 0);
    uint8_t *a2 = mmap(NULL, 0x1000,
            PROT_READ | PROT_WRITE | PROT_EXEC,
            MAP_FILE | MAP_SHARED, fd, 0);
    assert((void*)-1 != a1);
    assert((void*)-1 != a2);

    long sz = DIFF(fun, fun2_end);
    memcpy(a1, fun, sz);

    uint64_t *p1 = (uint64_t*)&a2[DIFF(fun, fun_ins)];
    uint64_t *p2 = (uint64_t*)&a2[DIFF(fun, fun2_ins)];
    uint64_t old = *p1;
    uint64_t new = *p2;
    typedef int (*fn_t)(uint64_t*, uint64_t);
    uint64_t alt = old;
    for(;;)
    {
        uint64_t val = ((fn_t)a1)(p1, alt);
        if (alt == new)
        {
            if (val == 1)
            {
                printf("wrong!\n");
            }
            alt = old;
        }
        else
        {
            if (val == 2)
            {
                printf("wrong!\n");
            }
            alt = new;
        }
    }

    close(fd);
    return 0;
}


#include <unistd.h>
#include <string.h>
#include <assert.h>
#include <stdint.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <stdio.h>

#define DIFF(a,b) ((long)(b) - (long)(a))

#define SYM(name) extern int name(void*);
SYM(fun)
SYM(fun_ins)
SYM(fun_end)

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
    assert(a1!=a2);

    long sz = DIFF(fun, fun_end);
    memcpy(a1, fun, sz);

    void *p1 = &a2[DIFF(fun, fun_ins)];
    typedef int (*fn_t)(void*);
    //fun(p1);
    int i;
    for (i = 0; i < 100; ++i)
    {
        int j = ((fn_t)a1)(p1);
        printf("ret=%d\n", j);
    }
    close(fd);
    return 0;
}

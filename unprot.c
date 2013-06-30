
#include <sys/mman.h>

void unprotect(void *addr, size_t len)
{
    mprotect(addr, len, PROT_WRITE | PROT_READ | PROT_EXEC);
}
void _unprotect(void *addr, size_t len)
{
    unprotect(addr, len);
}

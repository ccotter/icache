
.text
.globl _fun
.globl _fun_ins
.globl _fun_end
.globl fun
.globl fun_ins
.globl fun_end

/* fun(uint64_t*, uint64_t)
   Attempts to observe non-deterministic behavior due to
   icache instrution already been prefetched.

   We run the instruction in question 100 times, then
   overwrite the instruction and run it once more. The
   overwrite occurs, then immediately after the new instruction
   is run.

*/

# fun(rdi = uint64_t*, rsi = uint64_t)
fun:
_fun:
    pushl %ebp
    movl %esp, %ebp
    movl 8(%ebp), %ecx
    # A far jump simulated with a far return
    xorl %eax, %eax
    xorl %edx, %edx
    mov %cs, %edx
    pushl %edx
    call get_eip
get_eip:
    add $8, (%esp)
    lretl
copy:
    movw $0xc0ff, (%ecx) # This overwrites the following instruction
                     # rdi maps to the same physical address, but
                     # its linear address is different from the linear
                     # address of the instruction at fun_ins.
                     # So, the linear addresses fun_ins != %rdi, but
                     # linear->physical translation will have fun_ins == %rdi
fun_ins:
_fun_ins:
    nop   # Two NOPs gives enough space for the inc %eax
    nop
    popl %ebp
    ret
fun_end:
_fun_end:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

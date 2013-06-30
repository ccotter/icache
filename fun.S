
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
    push %rbp
    mov %rsp, %rbp
    # A far jump simulated with a far return
    xorq %rax, %rax
    xorq %r15, %r15
    mov %cs, %r15
    pushq %r15
    leaq copy(%rip), %r15
    pushq %r15
    lretq
copy:
    movw $0xc0ff, (%rdi) # This overwrites the following instruction
                     # rdi maps to the same physical address, but
                     # its linear address is different from the linear
                     # address of the instruction at fun_ins.
                     # So, the linear addresses fun_ins != %rdi, but
                     # linear->physical translation will have fun_ins == %rdi
fun_ins:
_fun_ins:
    nop   # Two NOPs gives enough space for the inc %eax
    nop
    pop %rbp
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


.text
.globl _fun
.globl _fun_ins
.globl _fun_end
.globl _fun2_ins
.globl _fun2_end
.globl fun
.globl fun_ins
.globl fun_end
.globl fun2_ins
.globl fun2_end

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
    clflush (%rdi) # Remove the instruction from all caches
    mov $10000, %r9
    mov $1, %r8
    jmp fun_ins
before:
    mov $1, %r9
    xor %r8, %r8 # So we exit all oops
    mov %rsi, (%rdi)
fun_ins:
_fun_ins:
    mov $1, %eax
    sub $1, %r9
    jne _fun_ins
    cmp $1, %r8
    je before
    leave
    ret
fun_end:
_fun_end:

/* Identical to the above - with the noted exception below.
   This way, I can easily/safely copy code from fun2_ins
   to fun_ins

*/
before2:
    mov $1, %r9
    xor %r8, %r8 # So we exit all oops
    mov %rsi, (%rdi)
fun2_ins:
_fun2_ins:
    mov $2, %eax # %eax = 2, not 1
    sub $1, %r9 
    jne fun2_ins
    cmp $1, %r8
    je before2
    leave
    ret
fun2_end:
_fun2_end:
    ret

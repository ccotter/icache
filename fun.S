
.text
.globl _fun
.globl _fun_ins
.globl _fun_end
.globl _fun2_ins
.globl _fun2_end

# fun(rdi = uint64_t*, rsi = uint64_t)
_fun:
    push %rbp
    mov %rsp, %rbp
    clflush (%rdi)
    mov $10000, %r9
    mov $1, %r8
    jmp _fun_ins
before:
    mov $1, %r9
    xor %r8, %r8 # So we exit all oops
    mov %rsi, (%rdi)
_fun_ins:
    mov $1, %eax
    sub $1, %r9
    jne _fun_ins
    cmp $1, %r8
    je before
    leave
    ret
_fun_end:

/* Identical to the above - with the noted exception below */
before2:
    mov $1, %r9
    xor %r8, %r8 # So we exit all oops
    mov %rsi, (%rdi)
_fun2_ins:
    mov $2, %eax # %eax = 2, not 1
    sub $1, %r9 
    jne _fun2_ins
    cmp $1, %r8
    je before2
    leave
    ret
_fun2_end:
    ret

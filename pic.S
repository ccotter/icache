
.text
.globl _main
.globl main

main:
_main:
    push %rbp
    mov %rsp, %rbp

    call get_rip
get_rip:
    pop %rdi
    and $~0xfff, %rdi
    mov $0x1000, %rsi
    call _unprotect

    call get_pic_size
    pop %rbp
    ret

get_pic_size:
    push %rbp
    mov %rsp, %rbp
    nop
    nop
    nop
    nop
    nop

    leaq flush_queue(%rip), %r14
    leaq nop_field(%rip), %r15

    xorq %rcx, %rcx
    xorq %rax, %rax
    mov %cs, %rdx

    pushq %rdx
    pushq %r15
    lretq

around:
    cmpl $1, %eax
    je found_size

    movb $0x90, (%r15, %rcx, 1)
    incq %rcx
    pushq %rdx
    pushq %r14
    lretq

flush_queue:
    movw $0xc0ff, (%r15, %rcx, 1)

nop_field:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jmp around
found_size:
    # %rcx now has size of PIQ
    mov %rcx, %rax
    pop %rbp
    ret

simplest:
    mov nops@GOTPCREL(%rip), %r15
    mov (%r15), %r15
    mov ahead@GOTPCREL(%rip), %rax
    mov %r15, (%rax)
ahead:
    jmp end
    nop
    nop
    nop
    mov $1, %rax
    pop %rbp
    ret 
end:
    mov $2, %rax
    pop %rbp
    ret
    
nops: # 8 bytes worth of NOPs
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

.section .data
stack: .dword 0
topIndex: .dword -1


.section .rodata
fmt:
    .string "%lld "          # For using printf

.section .text

.globl init_stack
init_stack:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)

    add s0, a0, zero

    slli a0, a0, 3
    call malloc
    la t0, stack
    sd a0, 0(t0)

    la t1, topIndex
    addi t2, zero, -1
    sd t2, 0(t1)

    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16

    ret

.globl push
push:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)

    add s0, a0, zero

    la t0, topIndex
    ld t1, 0(t0)
    addi t1, t1, 1
    sd t1, 0(t0)

    slli t1, t1, 3
    la t2, stack
    ld t2, 0(t2)
    add t2, t2, t1

    sd s0, 0(t2)

    ld s0, 0(sp)
    ld ra, 8(sp)
    addi sp, sp, 16

    ret

.globl pop
pop:
    addi sp, sp, -8
    sd ra, 0(sp)

    la t0, topIndex
    ld t1, 0(t0)
    addi t1, t1, -1
    sd t1, 0(t0)

    ld ra, 0(sp)
    addi sp, sp, 8

    ret

.globl top
top:
    addi sp, sp, -8
    sd ra, 0(sp)

    la t0, stack
    ld t0, 0(t0)
    la t1, topIndex
    ld t1, 0(t1)
    slli t1, t1, 3
    add t0, t0, t1
    ld a0, 0(t0)

    ld ra, 0(sp)
    addi sp, sp, 8

    ret

.globl empty
empty:
    addi sp, sp, -8
    sd ra, 0(sp)

    la t0, topIndex
    ld t0, 0(t0)

    addi t1, zero, -1
    beq t1, t0, empty_true
    
    add a0, zero, zero
    
    ld ra, 0(sp)
    addi sp, sp, 8

    ret

empty_true:
    addi a0, zero, 1

    ld ra, 0(sp)
    addi sp, sp, 8

    ret


.globl main
main:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s6, 16(sp)
    sd s7, 8(sp)

    addi a0, a0, -1             # a0 = Number of elements in the array
    add s0, a0, zero            # s0 = Copy of a0

    slli a0, a0, 3
    call malloc
    add s1, a0, zero            # s1 = base addr of input array

    addi s6, zero, 0            # t3 = i = 0
    addi s7, a1, 8              # t4 = Pointer to first element of the array

parsing:
    bge s6, s0, parsing_done

    ld a0, 0(s7)
    call atoll

    slli t5, s6, 3
    add t5, s1, t5
    sd a0, 0(t5)

    addi s7, s7, 8
    addi s6, s6, 1

    j parsing

parsing_done:
    add a0, s0, zero
    call init_stack

    slli a0, s0, 3
    call malloc
    add s2, a0, zero            # s2 = base addr of result array

    add s3, s2, zero            # s3 = copy of s2
    add s4, s0, zero            # s2 = copy of s0

    addi s11, zero, 0
    j loop

    j printing

printing:
    beq s11, s4, EXIT

    slli t0, s11, 3
    add t1, s3, t0

    lla a0, fmt
    ld a1, 0(t1)
    call printf
    
    addi s11, s11, 1
    j printing

loop:
    addi s0, s0, -1
    bge s0, zero, while

    j printing

while:
    call empty
    bne a0, zero, stack_empty

    call top
    slli a0, a0, 3
    add t0, s1, a0
    ld t0, 0(t0)                # t0 = arr[stack.top()]

    slli t1, s0, 3
    add t1, s1, t1
    ld t1, 0(t1)                # t1 = arr[i]

    blt t1, t0, store_top

    call pop
    j while

store_top:
    call top
    add t1, zero, a0

    slli t0, s0, 3
    add t0, s2, t0

    sd t1, 0(t0)

    add a0, s0, zero
    call push
    j loop

stack_empty:
    slli t0, s0, 3
    add t0, s2, t0

    addi t1, zero, -1
    sd t1, 0(t0)

    add a0, s0, zero
    call push
    j loop

EXIT:
    ld s7, 8(sp)
    ld s6, 16(sp)
    ld ra, 24(sp)
    addi sp, sp, 32

    addi a0, zero, 0
    ret
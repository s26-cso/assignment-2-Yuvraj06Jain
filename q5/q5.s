.section .rodata
fmt:
    .string "%s\n"          # For printing

mode:
    .string "r"

yes:
    .string "Yes"

no:
    .string "No"

.section .text
.globl main
main:
    addi a1, a1, 8          # a1 = Pointer to the input argument
    ld a0, 0(a1)
    la a1, mode
    call fopen              # a0 = File Ptr

    beq a0, zero, EXIT_ERROR

    add s0, a0, zero        # s0 = ptr to the first character

    add a0, s0, zero
    add a1, zero, zero
    add a2, zero, 2
    call fseek

    add a0, s0, zero
    call ftell
    add s1, a0, zero

    add s2, zero, zero        # s2 = ptr to first character
    addi s1, s1, -1         # s1 = ptr to last character

    j palindrome_check

palindrome_check:
    bge s2, s1, YES

    add a0, s0, zero
    add a1, zero, s2
    add a2, zero, zero
    call fseek

    add a0, s0, zero
    call fgetc
    add s11, a0, zero

    add a0, s0, zero
    add a1, zero, s1
    add a2, zero, zero
    call fseek

    add a0, s0, zero
    call fgetc
    sub t0, s11, a0

    bne t0, zero, NO

    addi s2, s2, 1
    addi s1, s1, -1

    j palindrome_check

YES:
    lla a0, fmt
    la a1, yes
    call printf
    add a0, zero, zero
    call exit

NO:
    lla a0, fmt
    la a1, no
    call printf
    add a0, zero, zero
    call exit

EXIT_ERROR:
    addi a0, zero, 1
    call exit
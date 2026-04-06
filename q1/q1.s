.section .text
.globl make_node

make_node:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)

    add s1, a0, zero

    li a0, 24
    call malloc

    beq a0, zero, alloc_fail

    add s0, a0, zero
    
    sw s1, 0(s0)          # node->data
    sd zero, 8(s0)        # node->left = NULL
    sd zero, 16(s0)       # node->right = NULL

    add a0, s0, zero

    ld s1, 8(sp)
    ld s0, 16(sp)
    ld ra, 24(sp)
    addi sp, sp, 32
    ret

alloc_fail:
    li a0, 0

    ld s1, 8(sp)
    ld s0, 16(sp)
    ld ra, 24(sp)
    addi sp, sp, 32
    ret

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.globl insert

insert:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)

    add s0, a0, zero            # s0 = root
    add s1, a1, zero            # s1 = val

    beq s0, zero, null_case

    lw t0, 0(s0)

    blt t0, s1, right
    bgt t0, s1, left

    add a0, s0, zero            # root->data == val
    j insertion_completed

null_case:
    add a0, s1, zero
    call make_node

    j insertion_completed

insertion_completed:
    ld s1, 8(sp)
    ld s0, 16(sp)
    ld ra, 24(sp)
    addi sp, sp, 32

    ret

right:
    ld a0, 16(s0)
    add a1, s1, zero
    call insert

    sd a0, 16(s0)
    add a0, s0, zero
    j insertion_completed

left:
    ld a0, 8(s0)
    add a1, s1, zero
    call insert

    sd a0, 8(s0)
    add a0, s0, zero
    j insertion_completed


#----------------------------------------------------------------------------------------------------------------------------------------------------------------------

.globl get

get:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)

    add s0, a0, zero            # s0 = root
    add s1, a1, zero            # s1 = val

    beq s0, zero, get_null_case

    lw t0, 0(s0)

    blt t0, s1, get_right
    bgt t0, s1, get_left

    add a0, s0, zero
    j get_complete

get_null_case:
    add a0, zero, zero
    j get_complete

get_complete:
    ld s1, 8(sp)
    ld s0, 16(sp)
    ld ra, 24(sp)
    addi sp, sp, 32

    ret

get_right:
    ld a0, 16(s0)
    add a1, s1, zero
    call get
    
    j get_complete

get_left:
    ld a0, 8(s0)
    add a1, s1, zero
    call get

    j get_complete

#------------------------------------------------------------------------------------------------------------------------------------------------
.globl getAtMost

getAtMost:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)

    add s1, a0, zero            # s1 = val
    add s0, a1, zero            # s0 = root

    beq s0, zero, getAtMost_null_case

    lw t0, 0(s0)

    beq t0, s1, equal_case
    bgt t0, s1, getAtMost_left    

    ld a1, 16(s0)
    add a0, s1, zero
    call getAtMost

    add t2, a0, zero
    addi t1, zero, -1
    beq t1, t2, getAtMost_notFound

    j getAtMost_complete

getAtMost_null_case:
    addi a0, zero, -1
    j getAtMost_complete

getAtMost_notFound:
    lw a0, 0(s0)
    j getAtMost_complete

equal_case:
    lw a0, 0(s0)
    j getAtMost_complete

getAtMost_left:
    ld a1, 8(s0)
    add a0, s1, zero
    call getAtMost

    j getAtMost_complete

getAtMost_complete:
    ld s1, 8(sp)
    ld s0, 16(sp)
    ld ra, 24(sp)
    addi sp, sp, 32

    ret
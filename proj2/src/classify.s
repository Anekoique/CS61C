.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    ebreak
    addi sp sp -48
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw s7 28(sp)
    sw s8 32(sp)
    sw s9 36(sp)
    sw s10 40(sp)
    sw s11 44(sp)
    li s0 5
    blt a0 s0 argu_error
    mv s0 a1
    mv s1 a2
    # Read pretrained m0
    addi sp sp -4 
    sw ra 0(sp)
    li a0 8
    jal ra malloc
    lw ra 0(sp)
    addi sp sp 4
    li t0 0 
    beq a0 t0 malloc_error
    mv s2 a0
    addi s3 a0 4

    addi sp sp -4
    sw ra 0(sp)
    lw a0 4(s0)
    mv a1 s2
    mv a2 s3
    jal ra read_matrix
    lw ra 0(sp)
    addi sp sp 4
    mv s4 a0
    lw s7 0(s2)
    lw s8 0(s3)

    addi sp sp -4
    sw ra 0(sp)
    mv a0 s2
    jal ra free
    lw ra 0(sp)
    addi sp sp 4
    # Read input matrix
    addi sp sp -4 
    sw ra 0(sp)
    li a0 8
    jal ra malloc
    lw ra 0(sp)
    addi sp sp 4
    li t0 0 
    beq a0 t0 malloc_error
    mv s2 a0
    addi s3 a0 4

    addi sp sp -4
    sw ra 0(sp)
    lw a0 12(s0)
    mv a1 s2
    mv a2 s3
    jal ra read_matrix
    lw ra 0(sp)
    addi sp sp 4
    mv s6 a0
    lw s9 0(s2)
    lw s10 0(s3)

    addi sp sp -4
    sw ra 0(sp)
    mv a0 s2
    jal ra free
    lw ra 0(sp)
    addi sp sp 4
    # Compute h = matmul(m0, input)
    addi sp sp -4
    sw ra 0(sp)
    mul a0 s7 s10
    slli a0 a0 2
    jal ra malloc
    lw ra 0(sp)
    addi sp sp 4
    li s2 0
    beq a0 s2 malloc_error
    mv s11 a0

    addi sp sp -4
    sw ra 0(sp)
    mv a0 s4
    mv a1 s7
    mv a2 s8
    mv a3 s6
    mv a4 s9
    mv a5 s10
    mv a6 s11
    jal ra matmul
    lw ra 0(sp)
    addi sp sp 4
    # Compute h = relu(h)
    addi sp sp -4
    sw ra 0(sp)
    mv a0 s11
    mul a1 s7 s10
    jal ra relu
    lw ra 0(sp)
    addi sp sp 4
    # Read pretrained m1
    addi sp sp -4 
    sw ra 0(sp)
    li a0 8
    jal ra malloc
    lw ra 0(sp)
    addi sp sp 4
    li t0 0 
    beq a0 t0 malloc_error
    mv s2 a0
    addi s3 a0 4

    addi sp sp -4
    sw ra 0(sp)
    lw a0 8(s0)
    mv a1 s2
    mv a2 s3
    jal ra read_matrix
    lw ra 0(sp)
    addi sp sp 4
    mv s5 a0
    # Compute o = matmul(m1, h)
    addi sp sp -4 
    sw ra 0(sp)
    lw a0 0(s2)
    mul a0 a0 s10
    slli a0 a0 2
    jal ra malloc
    lw ra 0(sp)
    addi sp sp 4
    li t0 0 
    beq a0 t0 malloc_error
    mv s4 a0

    addi sp sp -4
    sw ra 0(sp)
    mv a0 s5
    lw a1 0(s2)
    lw a2 0(s3)
    mv a3 s11
    mv a4 s7
    mv a5 s10
    mv a6 s4
    jal ra matmul
    lw ra 0(sp)
    addi sp sp 4

    addi sp sp -4 
    sw ra 0(sp)
    mv a0 s11
    jal ra free
    lw ra 0(sp)
    addi sp sp 4

    # Write output matrix o
    addi sp sp -4
    sw ra 0(sp)
    lw a0 16(s0)
    mv a1 s4
    lw a2 0(s2)
    mv a3 s10
    jal ra write_matrix
    lw ra 0(sp)
    addi sp sp 4

    # Compute and return argmax(o)
    addi sp sp -4
    sw ra 0(sp)
    mv a0 s4
    lw a1 0(s2)
    mul a1 a1 s10
    jal ra argmax
    lw ra 0(sp)
    addi sp sp 4
    mv s0 a0

    addi sp sp -4
    sw ra 0(sp)
    mv a0 s2
    jal ra free
    lw ra 0(sp)
    addi sp sp 4

    addi sp sp -4 
    sw ra 0(sp)
    mv a0 s4
    jal ra free
    lw ra 0(sp)
    addi sp sp 4
    # If enabled, print argmax(o) and newline
    li s3 1
    beq s1 s3 prog_exit

    addi sp sp -4
    sw ra 0(sp)
    mv a0 s0
    jal ra print_int
    lw ra 0(sp)
    addi sp sp 4

    addi sp sp -4
    sw ra 0(sp)
    li a0 '\n'
    jal ra print_char
    lw ra 0(sp)
    addi sp sp 4
prog_exit:
    mv a0 s0
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw s7 28(sp)
    lw s8 32(sp)
    lw s9 36(sp)
    lw s10 40(sp)
    lw s11 44(sp)
    addi sp sp 48
    jr ra

malloc_error:
    li a0 26
    j exit

argu_error:
    li a0 31
    j exit

.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
    ebreak
    addi sp sp -24
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    mv s0 a0
    mv s1 a1
    mv s2 a2

    addi sp sp -4
    sw ra 0(sp)
    li a1 0
    jal ra fopen
    lw ra 0(sp)
    addi sp sp 4
    li s5 -1
    beq a0 s5 fopen_error
    mv s0 a0

    li s3 0
    mv a1 s1
read_byte:
    addi sp sp -4
    sw ra 0(sp)
    mv a0 s0
    li a2 4
    jal ra fread
    lw ra 0(sp)
    addi sp sp 4
    li s5 4
    bne a0 s5 fread_error
    addi s3 s3 1
    mv a1 s2
    li s5 2
    blt s3 s5 read_byte

    lw s3 0(s1)
    lw s4 0(s2)
    mul s3 s3 s4
    slli s3 s3 2
    addi sp sp -4
    sw ra 0(sp)
    mv a0 s3
    jal ra malloc
    lw ra 0(sp)
    addi sp sp 4
    li s5 0
    beq a0 s5 malloc_error
    mv s4 a0

    addi sp sp -4
    sw ra 0(sp)
    mv a0 s0
    mv a1 s4
    mv a2 s3
    jal ra fread
    lw ra 0(sp)
    addi sp sp 4
    bne a0 s3 fread_error

    addi sp sp -4
    sw ra 0(sp)
    mv a0 s0
    jal ra fclose
    lw ra 0(sp)
    addi sp sp 4
    li s5 -1
    beq a0 s5 fclose_error

    mv a0 s4
    lw s5 20(sp)
    lw s4 16(sp)
    lw s3 12(sp)
    lw s2 8(sp)
    lw s1 4(sp)
    lw s0 0(sp)
    addi sp sp 24
    jr ra

malloc_error:
    li a0 26
    j exit

fopen_error:
    li a0 27
    j exit

fclose_error:
    li a0 28
    j exit

fread_error:
    li a0 29
    j exit

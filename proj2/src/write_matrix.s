.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:
    ebreak
    addi sp sp -32
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw s7 28(sp)
    mv s0 a0
    mv s1 a1
    mv s2 a2
    mv s3 a3

    addi sp sp -4
    sw ra 0(sp)
    mv a0 s0
    li a1 1
    jal ra fopen
    lw ra 0(sp)
    addi sp sp 4
    li s6 -1
    beq a0 s6 fopen_error
    mv s0 a0

    li s4 0x10000000
    sw s2 0(s4)
    li s5 0x10000010
    sw s3 0(s5)

    li s7 0
    mv a0 s0
    mv a1 s4
write_byte:
    addi sp sp -4
    sw ra 0(sp)
    li a2 1 
    li a3 4
    jal ra fwrite
    lw ra 0(sp)
    addi sp sp 4
    li s6 1 
    bne a0 s6 fwrite_error
    addi s7 s7 1
    mv a1 s5
    mv a0 s0
    li s6 2
    blt s7 s6 write_byte

    addi sp sp -4
    sw ra 0(sp)
    mv a1 s1
    mul s2 s2 s3
    mv a2 s2
    li a3 4
    jal ra fwrite
    lw ra 0(sp)
    addi sp sp 4
    mv s6 s2
    bne a0 s6 fwrite_error

    addi sp sp -4
    sw ra 0(sp)
    mv a0 s0
    jal ra fclose
    lw ra 0(sp)
    addi sp sp 4
    li s6 -1
    beq a0 s6 fclose_error

    lw s7 28(sp)
    lw s6 24(sp)
    lw s5 20(sp)
    lw s4 16(sp)
    lw s3 12(sp)
    lw s2 8(sp)
    lw s1 4(sp)
    lw s0 0(sp)
    addi sp sp 32
    jr ra

fopen_error:
    li a0 27
    j exit

fwrite_error:
    li a0 30
    j exit

fclose_error:
    li a0 28
    j exit

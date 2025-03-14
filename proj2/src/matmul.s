.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:
    # Save necessary saved registers
    addi sp, sp, -8
    sw   s0, 4(sp)
    sw   ra, 0(sp)
    # Save B cols (a5) to s0
    mv   s0, a5

    # Error checks
    li   t0, 1
    blt  a1, t0, exit_bad_len    # Check A rows >= 1
    blt  a2, t0, exit_bad_len    # Check A cols >= 1
    blt  a4, t0, exit_bad_len    # Check B rows >= 1
    blt  s0, t0, exit_bad_len    # Check B cols >= 1 (using saved s0)
    bne  a2, a4, exit_bad_len    # Check A cols == B rows

    # Prologue
    li   t1, 0                   # Outer loop counter (i)
    mv   t4, a3                  # Save original B pointer

outer_loop_start:
    bge  t1, a1, outer_loop_end  # Loop until i >= A rows
    li   t0, 0                   # Inner loop counter (j)

inner_loop_start:
    bge  t0, s0, inner_loop_end  # Loop until j >= B cols (using s0)
    
    # Save registers to stack
    addi sp, sp, -44
    sw   t0, 0(sp)
    sw   t1, 4(sp)
    sw   a1, 8(sp)
    sw   a2, 12(sp)
    sw   a3, 16(sp)
    sw   a4, 20(sp)
    sw   s0, 24(sp)              # Save s0 (B cols)
    sw   a6, 28(sp)
    sw   ra, 32(sp)
    sw   a0, 36(sp)
    sw   t4, 40(sp)
    
    # Prepare arguments for dot product
    mv   a1, a3                  # B current row pointer
    li   a3, 1                   # Stride (assumed for simplicity)
    mv   a4, s0                  # Number of elements (B cols)
    jal  ra, dot                 # Call dot product
    mv   t3, a0                  # Save result
    
    # Restore registers from stack
    lw   t4, 40(sp)
    lw   a0, 36(sp)
    lw   ra, 32(sp)
    lw   a6, 28(sp)
    lw   s0, 24(sp)              # Restore s0 (B cols)
    lw   a4, 20(sp)
    lw   a3, 16(sp)
    lw   a2, 12(sp)
    lw   a1, 8(sp)
    lw   t1, 4(sp)
    lw   t0, 0(sp)
    addi sp, sp, 44
    
    # Store result and update pointers
    sw   t3, 0(a6)               # Store result in C[i][j]
    addi t0, t0, 1               # j++
    addi a6, a6, 4               # Move to next result element
    addi a3, a3, 4               # Move to next column in B
    j    inner_loop_start

inner_loop_end:
    addi t1, t1, 1               # i++
    slli t3, a2, 2               # Calculate offset for next row in A
    add  a0, a0, t3              # Move A to next row
    mv   a3, t4                  # Reset B pointer to start
    j    outer_loop_start

outer_loop_end:
    # Restore saved registers and return
    lw   ra, 0(sp)
    lw   s0, 4(sp)
    addi sp, sp, 8
    jr   ra

exit_bad_len:
    # Restore saved registers before exiting
    lw   ra, 0(sp)
    lw   s0, 4(sp)
    addi sp, sp, 8
    li   a0, 38                  # Set error code
    j    exit

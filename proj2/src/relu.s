.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    ebreak
    # Prologue
    addi t0, x0, 1
    bge a1, t0, loop_start
    addi a0, x0, 36
    j exit

loop_start:
    addi t0, x0, 0
    mv t1, a0
    mv t2, a1
    j loop_continue
    
loop_continue:
    bge t0, t2, loop_end
    mv a0, t1
    
    addi sp, sp, -16
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw ra, 12(sp)
    jal ra abs
    lw ra, 12(sp)
    lw t2, 8(sp)
    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 16
    
    addi t0, t0, 1
    addi t1, t1, 4
    j loop_continue

loop_end:
    # Epilogue
    mv a0, x0
    jr ra

abs:
    # Load number from memory
    lw t0 0(a0)
    bge t0, zero, done

    # Negate a0
    addi t0, x0, 0

    # Store number back to memory
    sw t0 0(a0)

done:
    jr ra

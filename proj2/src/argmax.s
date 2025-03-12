.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    ebreak
    # Prologue
    addi t0, x0, 1
    bge a1, t0, loop_start
    addi a0, x0, 36
    j exit

loop_start:
    addi t0, x0, 0
    mv t1, a0
    lw t2, 0(t1)
    addi a0, x0, 0
    j loop_continue

loop_continue:
    bge t0, a1, loop_end
    lw t3, 0(t1)
    blt t2, t3, change
    addi t0, t0, 1
    addi t1, t1, 4
    j loop_continue

loop_end:
    # Epilogue
    ret

change:
    mv a0, t0
    mv t2, t3
    addi t0, t0, 1
    addi t1, t1, 4
    j loop_continue
.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    # Prologue
    addi t0 x0 1
    bge a2 t0 loop_start
    addi a0 x0 36
    j exit
    
error_exit:
    addi a0 x0 37
    j exit

loop_start:
    blt a3 t0 error_exit
    blt a4 t0 error_exit
    addi t0 x0 0
    addi t1 x0 0
    j loop_continue

loop_continue:
    bge t0 a2 loop_end
    
    lw t2 0(a0)
    lw t3 0(a1)
    mul t2 t2 t3
    add t1 t1 t2
    
    addi t0 t0 1 
    slli t2 a3 2
    add a0 a0 t2
    slli t2 a4 2
    add a1 a1 t2

    j loop_continue

loop_end:
    mv a0 t1
    # Epilogue
    jr ra
    


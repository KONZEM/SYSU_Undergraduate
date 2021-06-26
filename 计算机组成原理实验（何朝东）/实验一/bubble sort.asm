.text
.globl main
main:
      	la $a0, str1
	li $v0, 4
   	syscall

	la $a0, nline
	li $v0, 4
   	syscall

	add $t0, $zero, $zero   # int i
	addi $s0, $zero, 10	# int n = 10
	la $s1, array		# the address of data

loop1:
	sll $t1, $t0, 2
	add $t2, $t1, $s1	

	li $v0, 5
   	syscall
	sw $v0, 0($t2)
	
	addi $t0, $t0, 1
	slt $t3, $t0, $s0
	beq $t3, $zero, next1
	j loop1

next1:
	la $a0, nline
	li $v0, 4
   	syscall

	la $a0, str2
	li $v0, 4
   	syscall
	
	la $a0, nline
	li $v0, 4
   	syscall

	addi $t0, $zero, 1    # int i = 1

loop2:
	addi $t1, $zero, 9    # int j = 9

loop3:
	sll $t2, $t1, 2	      # the offset of array[j]
	addi $t3, $t2, -4     # the offset of array[j-1]
	add $t4, $t2, $s1     # the address of array[j]
	add $t5, $t3, $s1     # the address of array[j-1]
	lw $s2, 0($t4)
	lw $s3, 0($t5)
	sltu $t6, $s2, $s3
	beq $t6, $zero, swap

next2: 
	addi $t1, $t1, -1
	slt $t6, $t1, $t0
	beq $t6, $zero, loop3

	addi $t0, $t0, 1
	slt $t6, $t0, $s0
	beq $t6, $zero, next3 
	j loop2

swap:
	sw $s3, 0($t4) 
	sw $s2, 0($t5)
	j next2

next3:
	add $t0, $zero, $zero

loop4:
	sll $t1, $t0, 2
	add $t2, $t1, $s1	
	lw $a0, 0($t2)  
	
 	li $v0, 1
   	syscall

	li $v0, 4
	la $a0, nline
	syscall

	addi $t0, $t0, 1
	slt $t3, $t0, $s0
	beq $t3, $zero exit
	j loop4

exit:
	li $v0, 10
	syscall

.data
   	str1:  
		.asciiz "Please input ten unsigned integers\n"
   	str2:
		.asciiz "The ordered result: "
	nline:
		.asciiz "\n"
	array:
		.align 2
		.space 40
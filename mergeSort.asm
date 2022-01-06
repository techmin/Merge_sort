	#Atmin Shetg
		.data
alloc: .space 32  # this will allocate the given input 
temp: 	.space 32 
right:	.space 16
left:	.space 16 

p:	.word 0
number: .asciiz "give a number from 2,4,8,16 or 32 "
get: 	.asciiz	"give a number "
done:	.asciiz " Thank you for the input "
comma:	.asciiz ", "

	.text
	.globl main
	
main:
	li $v0,4
	la $a0,number #promting to get the size of the array
	syscall
	li $v0,5
	syscall
	move $t7,$v0 #length
	li $t0,0#this will be the counter to get the inputs stor in $t1
	li $t1,0
	
input: 	
	li $v0,4
	la $a0,get #promting to get tuhe allocate space
	syscall
	li $v0,5
	syscall
	sw $v0,temp($t1)  #stores the unout in a dynamic heap 
	addi $t1,$t1,4
	addi $t0,$t0,1
	 bne $t0,$t7,input 
	li $v0,4 
	la $a0,done
	syscall 
	sll $v0,$t7,2 #last pointer
	#lw $s0,$t0
	#s2 & s3 be  pointers 
	li $s2,0
	li $s3,0 
	li $s0,0
	li $s1,4
	li $t6,0
	li $t5,0
	#addi $t7,$t7,1
Loop:
	#out of bound conditions
	addi $s2,$zero,0
	addi $s3,$zero,0
	lw $t0,temp($s0)
	lw $t1, temp($s1)
	blt $s0,$v0,L
	blt $s1,$v0,R
	j prep
	
L:
	beqz $t5,Lf
	lw $t2,left($s2)
	beqz $t2,Llast
	bge $t2,$t0,Lf#if the current element is larger than in the temp array 
	addi $s2,$s2,4 
	sll $s5,$t5,2
	#bge $s2,$s5,Loop	
	j L 
Llast:
	beqz $t0,Loop
	sw $t0,left($s2)
	j Loop 
	
	
Le:

	bge $s2,$s5,Loop
	addi $s6,$s6,1
	lw $t4,left($s2)
	sw $t2,left($s2)	
	add $t2,$t4,$zero
	bgt $s6,$t5,Loop
	addi $s2,$s2,4
	j Le
	
	
Lf:
	sw $t0,left($s2)
	add $t0,$zero,0
	addi $s0,$s0,8
	addi $s2,$s2,4
	addi $t5,$t5,1
	sll $s5,$t5,2
	j Le
	
R:
	beqz $t6,Rf
	lw $t2,right($s3)
	beqz $t2,Rlast
	bge $t2,$t1,Rf#if the current element is larger than in the temp array 
	addi $s3,$s3,4 
	sll $s5,$t6,2
	#bge $s2,$s5,Loop	
	j R
Rlast:
	beqz $t1,Loop
	sw $t1,right($s3)
	j Loop 
	
Re:

	bge $s3,$s5,Loop
	addi $s7,$s7,1
	lw $t4,right($s3)
	sw $t2,right($s3)	
	add $t2,$t4,$zero
	bgt $s7,$t5,Loop
	addi $s3,$s3,4
	j Re
	
	
Rf:
	sw $t1,right($s3)
	add $t0,$zero,0
	addi $s1,$s1,8
	addi $s3,$s3,4
	addi $t6,$t6,1
	sll $s5,$t6,2
	j Re
	
prep:
	addi $t0,$zero,0
	addi $t1,$zero,0
	addi $t5,$zero,0
	srl $s0,$t7,1
	addi $s1,$s0,0
	
	#iterating through the array to then added to the combined to one array 	
merge:
	lw $s3,left($t0)#move first value of arr1
	lw $s4,right($t1)#move first value of arr2	
	#if the arr1 has reach the end of the array jump to second and if the arr2 is in the end jump to first
	
	beqz $s0,J2 
	beqz $s1,J1
	slt $t4,$s3,$s4# check if the value in arr1 is less than the value in arr2
	bnez  $t4,First #if the value of arr1 is less than arr2
	beqz $t4,Second #if the value of arr2 is elss than arr1
	#J1 and J2 will  straight go to adding the value to arr3 
	#J1 and J2 will  straight go to adding the value to arr3 
J1:
	add $t2,$zero,0 #counter zero
	beqz $s0,print #if arr1 is 0 meaning all array are combined now print
	j First
J2:	
	add $t2,$zero,0 #counter zero 
	beqz $s1,print #if arr2 is 0 meaning all array are combined now print
	j Second

First:
	sw $s3,alloc($t5) #storing to arr3 at curent index
	add $t5,$t5,4 #moving to the next index
	add $t0,$t0,4  
	sub $s0,$s0,1 #decreasing the counter value 
	j merge
Second:	
	sw $s4,alloc($t5) #storing to arr3 at current index
	add $t5,$t5,4 #moving to the next index
	add $t1,$t1,4
	sub $s1,$s1,1 #decreasing the counter value 
	j merge
	

	
print:
	beqz  $t7,Exit #exit condion when the array reaches the end 
	lw $t6,alloc($t2)
	add $t2,$t2,4
	sub $t7,$t7,1
	#print the cu`rrent digit value
	li $v0,1
	move $a0,$t6
	syscall
	#print the comma
	li $v0,4
	la $a0,comma
	syscall
	j print
Exit:

##################################################################### 
# 
# CSCB58 Winter 2022 Assembly Final Project 
# University of Toronto, Scarborough 
# 
# Student: Peter Yan Tsai Chow, 1006703961, chowyan4, peterp.chow@mail.utoronto.ca
# 
# Bitmap Display Configuration: 
# - Unit width in pixels: 4
# - Unit height in pixels: 4
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp) 
# 
# Which milestones have been reached in this submission? 
# (See the assignment handout for descriptions of the milestones) 
# - Milestone 1/2/3 (choose the one the applies) 
# 
# Which approved features have been implemented for milestone 3? 
# (See the assignment handout for the list of additional features) 
# 1. (fill in the feature, if any) 
# 2. (fill in the feature, if any) 
# 3. (fill in the feature, if any) 
# ... (add more if necessary) 
# 
# Link to video demonstration for final submission: 
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it! 
# 
# Are you OK with us sharing the video with people outside course staff? 
# - yes, and please share this project github link as well! 
# 
# Any additional information that the TA needs to know: 
# - (write here, if any) 
# 
##################################################################### 

.data
.eqv  BASE_ADDRESS  0x10008000 

# Colours
.eqv  GREEN_GROUND  0x00ad31 
.eqv  BLUE_SKY  0x8cdfe5 
.eqv  BROWN_GROUND  0xd69a5f
.eqv  WHITE  0xd69a5f

# Princess peach colours
.eqv  PEACH1  0xe5994c
.eqv  PEACH2  0xf5c637
.eqv  PEACH3  0xffe8b0
.eqv  PEACH4  0xff73a1
.eqv  PEACH5  0xf0366f

.text 
.globl main

main:
 	li $t0, BASE_ADDRESS 	# $t0 stores the base address for display 
 	la $t2, 14096($t0)	# Player beginning position

   	li $t1, BLUE_SKY   	# $t1 stores the blue colour code 
# paints sky blue
	li $t5, 3712
	add $t6, $zero, $zero
	la, $t7, ($t0)
	
LOOP: 	bge $t6, $t5, ELOOP
	sw $t1, 0($t7)
	addi $t7, $t7, 4
	addi $t6, $t6, 1
	j LOOP
ELOOP:

 	li $t1, GREEN_GROUND   	# $t1 stores the green colour code 
# paints ground green
	li $t5, 3840
	addi $t6, $zero, 3712
	la, $t7, 14848($t0)
	
LOOP2: 	bge $t6, $t5, ELOOP2
	sw $t1, 0($t7)
	addi $t7, $t7, 4
	addi $t6, $t6, 1
	j LOOP2
ELOOP2:

 	li $t1, BROWN_GROUND  	# $t1 stores the brown colour code 
# paints below ground brown
	li $t5, 4096
	addi $t6, $zero, 3840
	la, $t7, 15360($t0)
	
LOOP3: 	bge $t6, $t5, ELOOP3
	sw $t1, 0($t7)
	addi $t7, $t7, 4
	addi $t6, $t6, 1
	j LOOP3
ELOOP3:

	
# paint princess
	li $t1, PEACH4
	sw $t1, 0($t2)
	sw $t1, -4($t2)
	sw $t1, 4($t2)
	sw $t1, 8($t2)
	sw $t1, 512($t2)
	sw $t1, 516($t2)
	li $t1, PEACH5
	sw $t1, 256($t2)
	sw $t1, 260($t2)
	sw $t1, 508($t2)
	sw $t1, 520($t2)
	sw $t1, 776($t2)
	sw $t1, 772($t2)
	sw $t1, 768($t2)
	sw $t1, 764($t2)
	sw $t1, 760($t2)
	li $t1, WHITE
	sw $t1, 252($t2)
	sw $t1, 264($t2)
	li $t1, PEACH2
	sw $t1, -8($t2)
	sw $t1, -260($t2)
	sw $t1, -516($t2)
	sw $t1, -520($t2)
	sw $t1, -772($t2)
	sw $t1, -768($t2)
	sw $t1, -764($t2)
	sw $t1, -504($t2)
	li $t1, PEACH3
	sw $t1, -256($t2)
	sw $t1, -252($t2)
	sw $t1, -512($t2)
	sw $t1, -508($t2)
	li $t1, PEACH1
	sw $t1, -1024($t2)
	sw $t1, -1020($t2)
	
END:	# End program
	li $v0, 10
	syscall

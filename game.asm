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
.eqv  BROWN_PLATFORM  0x994a31
.eqv  WHITE  0xffffff
.eqv  BLACK  0x000000

# Princess peach colours
.eqv  PEACH1  0xe5994c
.eqv  PEACH2  0xf5c637
.eqv  PEACH3  0xffe8b0
.eqv  PEACH4  0xff73a1
.eqv  PEACH5  0xf0366f

# mario colours
.eqv  MARIO1  0xfa3838
.eqv  MARIO2  0x704b41
.eqv  MARIO3  0xffc57d
.eqv  MARIO4  0x1d46f6

# goomba colours
.eqv  GOOM1  0x6a3917
.eqv  GOOM2  0xc08d66

####### RESERVED REGISTERS #######
# $t0 stores the BASE_ADDRESS
# $t2 stores player position at all times (has a beginning position
#################################

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


#### PLATFORM CREATE ####

 	li $t1, BROWN_PLATFORM  # $t1 stores the green colour code 
# create platform 1
	li $t5, 16
	add $t6, $zero, $zero
	la, $t7, 7836($t0)
	
LOOP5: 	bge $t6, $t5, ELOOP5
	sw $t1, 0($t7)
	addi $t7, $t7, 4
	addi $t6, $t6, 1
	j LOOP5
ELOOP5:
	li $t5, 16
	add $t6, $zero, $zero
	la, $t7, 7836($t0)
	addi, $t7, $t7, 256
	
LOOP4: 	bge $t6, $t5, ELOOP4
	sw $t1, 0($t7)
	addi $t7, $t7, 4
	addi $t6, $t6, 1
	j LOOP4
ELOOP4:

#### PAINTING CHARACTERS ####
	
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
	
	la $t3, 14144($t0)	# mario beginning position
# paint mario
	li $t1, MARIO3
	sw $t1, 0($t3)
	sw $t1, 4($t3)
	sw $t1, 8($t3)
	sw $t1, -260($t3)
	sw $t1, -252($t3)
	sw $t1, -248($t3)
	sw $t1, -244($t3)
	li $t1, MARIO1
	sw $t1, -512($t3)
	sw $t1, -516($t3)
	sw $t1, -508($t3)
	sw $t1, -504($t3)
	sw $t1, 248($t3)
	sw $t1, 252($t3)
	sw $t1, 260($t3)
	sw $t1, 264($t3)
	li $t1, MARIO2
	sw $t1, -256($t3)
	li $t1, MARIO4
	sw $t1, 256($t3)
	sw $t1, 508($t3)
	sw $t1, 512($t3)
	sw $t1, 516($t3)
	sw $t1, 764($t3)
	sw $t1, 772($t3)
	
	la $t3, 14192($t0)	# mario beginning position
# paint goomba
	li $t1, GOOM1
	sw $t1, -1028($t3)
	sw $t1, -1024($t3)
	sw $t1, -1020($t3)
	sw $t1, -772($t3)
	sw $t1, -768($t3)
	sw $t1, -764($t3)
	sw $t1, -524($t3)
	sw $t1, -520($t3)
	sw $t1, -512($t3)
	sw $t1, -504($t3)
	sw $t1, -500($t3)
	sw $t1, -268($t3)
	sw $t1, -256($t3)
	sw $t1, -244($t3)
	sw $t1, -16($t3)
	sw $t1, -12($t3)
	sw $t1, 0($t3)
	sw $t1, 12($t3)
	sw $t1, 16($t3)
	sw $t1, 240($t3)
	sw $t1, 244($t3)
	sw $t1, 268($t3)
	sw $t1, 272($t3)
	li $t1, BLACK
	sw $t1, -776($t3)
	sw $t1, -760($t3)
	sw $t1, -516($t3)
	sw $t1, -508($t3)
	sw $t1, -4($t3)
	sw $t1, 4($t3)
	sw $t1, 760($t3)
	sw $t1, 764($t3)
	sw $t1, 772($t3)
	sw $t1, 776($t3)
	li $t1, WHITE
	sw $t1, -264($t3)
	sw $t1, -260($t3)
	sw $t1, -252($t3)
	sw $t1, -248($t3)
	sw $t1, -8($t3)
	sw $t1, 8($t3)
	li $t1, GOOM2
	sw $t1, 248($t3)
	sw $t1, 252($t3)
	sw $t1, 256($t3)
	sw $t1, 260($t3)
	sw $t1, 264($t3)
	sw $t1, 508($t3)
	sw $t1, 512($t3)
	sw $t1, 516($t3)
	
	
	

END:	# End program
	li $v0, 10
	syscall

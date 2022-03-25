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
player: .space 8

.eqv  BASE_ADDRESS  0x10008000
.eqv  KEY_ADDRESS  0xffff0000

.eqv  REFRESH_RATE  40

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
# $t1 is ocassionally used to store color
# $t2 stores player position at all times (has a beginning position)
# $t5, $t6, $t7, $t9 is used inside the main loop
# $t4, $t3, $t8 can be used for other stuff
#################################

.text 
.globl main

###### DRAW_PLAYER ######
# paint princess
draw_player:
	lw $t3, 0($t2)

	li $t1, PEACH4
	sw $t1, 0($t3)
	sw $t1, -4($t3)
	sw $t1, 4($t3)
	sw $t1, 8($t3)
	sw $t1, 512($t3)
	sw $t1, 516($t3)
	li $t1, PEACH5
	sw $t1, 256($t3)
	sw $t1, 260($t3)
	sw $t1, 508($t3)
	sw $t1, 520($t3)
	sw $t1, 776($t3)
	sw $t1, 772($t3)
	sw $t1, 768($t3)
	sw $t1, 764($t3)
	sw $t1, 760($t3)
	li $t1, WHITE
	sw $t1, 252($t3)
	sw $t1, 264($t3)
	li $t1, PEACH2
	sw $t1, -8($t3)
	sw $t1, -260($t3)
	sw $t1, -516($t3)
	sw $t1, -520($t3)
	sw $t1, -772($t3)
	sw $t1, -768($t3)
	sw $t1, -764($t3)
	sw $t1, -504($t3)
	li $t1, PEACH3
	sw $t1, -256($t3)
	sw $t1, -252($t3)
	sw $t1, -512($t3)
	sw $t1, -508($t3)
	li $t1, PEACH1
	sw $t1, -1024($t3)
	sw $t1, -1020($t3)
	
	jr $ra

###### CLEAR_PLAYER ######
# this function removes the player
clear_player:
	lw $t3, 0($t2)

	li $t1, BLUE_SKY
	sw $t1, 0($t3)
	sw $t1, -4($t3)
	sw $t1, 4($t3)
	sw $t1, 8($t3)
	sw $t1, 512($t3)
	sw $t1, 516($t3)
	sw $t1, 256($t3)
	sw $t1, 260($t3)
	sw $t1, 508($t3)
	sw $t1, 520($t3)
	sw $t1, 776($t3)
	sw $t1, 772($t3)
	sw $t1, 768($t3)
	sw $t1, 764($t3)
	sw $t1, 760($t3)
	sw $t1, 252($t3)
	sw $t1, 264($t3)
	sw $t1, -8($t3)
	sw $t1, -260($t3)
	sw $t1, -516($t3)
	sw $t1, -520($t3)
	sw $t1, -772($t3)
	sw $t1, -768($t3)
	sw $t1, -764($t3)
	sw $t1, -504($t3)
	sw $t1, -256($t3)
	sw $t1, -252($t3)
	sw $t1, -512($t3)
	sw $t1, -508($t3)
	sw $t1, -1024($t3)
	sw $t1, -1020($t3)
	
	jr $ra

main:
 	li $t0, BASE_ADDRESS 	# $t0 stores the base address for display 

##### INITIALZIE PLAYER #####
	la $t2, player

 	la $t3, 13840($t0)	# Player beginning position
	sw $t3, 0($t2)		# stores position address into player struct
	addi $t3, $zero, 3460
	sw $t3, 4($t2)
	addi $t3, $zero, 2
	sw $t3, 8($t2)

###### paints sky blue #####
   	li $t1, BLUE_SKY   	# $t1 stores the blue colour code 
	li $t5, 3712
	add $t6, $zero, $zero
	la, $t7, ($t0)
	
LOOP: 	bge $t6, $t5, ELOOP
	sw $t1, 0($t7)
	addi $t7, $t7, 4
	addi $t6, $t6, 1
	j LOOP
ELOOP:

##### paints ground green #####
 	li $t1, GREEN_GROUND   	# $t1 stores the green colour code 
	li $t5, 3840
	addi $t6, $zero, 3712
	la, $t7, 14848($t0)
	
LOOP2: 	bge $t6, $t5, ELOOP2
	sw $t1, 0($t7)
	addi $t7, $t7, 4
	addi $t6, $t6, 1
	j LOOP2
ELOOP2:

##### paints below ground brown #####
 	li $t1, BROWN_GROUND  	# $t1 stores the brown colour code 
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

	jal draw_player
	
	la $t3, 13888($t0)	# mario beginning position
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
	
	la $t3, 13936($t0)	# goomba beginning position
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
	
##### MAIN LOOP #####
	
	addi $t5,$zero, 1
	li $t9, KEY_ADDRESS
MAIN_L:	beq $t5, $zero, END
	lw $t7, 0($t9)	# 1 if there is a new keypress
	lw $t6, 4($t9)	# value of the key press

	
if_key:	
	bne $t7, 1, key_no_clicked
	
##### do code below if a key is clicked ##### 
key_clicked:
	
	beq $t6, 0x77, w_clicked	# w clicked
	beq $t6, 0x61, a_clicked	# a clicked
	beq $t6, 0x73, s_clicked	# s clicked
	beq $t6, 0x64, d_clicked	# d clicked
	beq $t6, 0x70, main		# p clicked
	j key_no_clicked
	
##### do code below if the 'w' key is clicked ##### 
w_clicked: 
	lw $t4, 4($t2) 	# retrives index of player
	
	addi $t4, $t4, -576
	ble $t4, 320, key_no_clicked # jumps if index is less than 320
	sw $t4, 4($t2)
	
	jal clear_player
	lw $t4, 0($t2) 	# retrives position address of player
	addi $t4, $t4, -2304
	sw $t4, 0($t2)
	jal draw_player
	j key_no_clicked

##### do code below if the 'a' key is clicked ##### 
a_clicked: 
	jal clear_player
	lw $t4, 0($t2) 	# retrives position address of player
	addi $t4, $t4, -4
	sw $t4, 0($t2)
	jal draw_player
	j key_no_clicked
	
##### do code below if the 's' key is clicked ##### 
s_clicked: 

##### checks if ground is below the player #####
	lw $t4, 0($t2) 	# retrives position address of player
	lw $t3, 1024($t4) # $t3 is the color of the pixel 4 units below the center 
	# (if we check this pixel and if it is the colour of the ground, this means that
	# the player is on the ground
	li $t1, GREEN_GROUND
	
	# cannot press 's' if player is currently on the ground.
	beq $t1, $t3, key_no_clicked
	
	lw $t4, 4($t2) 	# retrives index of player
	addi $t4, $t4, 64
	sw $t4, 4($t2)

	jal clear_player
	lw $t4, 0($t2) 	# retrives position address of player
	addi $t4, $t4, 256
	sw $t4, 0($t2)
	jal draw_player
	j key_no_clicked

##### do code below if the 'd' key is clicked ##### 
d_clicked: 
	jal clear_player
	lw $t4, 0($t2) 	# retrives position address of player
	addi $t4, $t4, 4
	sw $t4, 0($t2)
	jal draw_player
	j key_no_clicked
	
##### do code below if no key is clicked ##### 
key_no_clicked:

##### checks if ground is below the player #####
	lw $t4, 0($t2) 	# retrives position address of player
	lw $t3, 1024($t4) # $t3 is the color of the pixel 4 units below the center 
	# (if we check this pixel and if it is the colour of the ground, this means that
	# the player is on the ground
	li $t1, GREEN_GROUND
	
	beq $t1, $t3, end_iteration
	
##### simulates gravity ##### 
gravity:
	# the 2 is a timing thing. The higher the value, the slower the player falls
	bgt $t5, 2, do_grav
	j end_iteration
	
do_grav:

	lw $t4, 4($t2) 	# retrives index of player
	addi $t4, $t4, 64
	sw $t4, 4($t2)

	jal clear_player
	lw $t4, 0($t2) 	# retrives position address of player
	addi $t4, $t4, 256
	sw $t4, 0($t2)
	jal draw_player
	addi $t5, $zero, 1
	
##### this loop is finished, call sleep and jump to MAIN_L #####
end_iteration:	
	# sleep
	li $v0, 32 
	li $a0, REFRESH_RATE
	syscall
	
	# while loop counter
	addi $t5,$t5, 1
	j MAIN_L
	
##### End program #####
END:	
	li $v0, 10
	syscall

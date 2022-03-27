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
player: .space 12
jump_count: .word 0
num_player_bullets: .word 0
player_bullet_array: .space 240 # each bullet has space of 12, so the array only allows 20 bullets

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
.eqv  PEACH6  0x289ddb
.eqv  PEACH_BULLET 0xf5c635

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

###### DRAW_GOOMBA ######
# function draw_player(int a):
# a is the starting offset of the goomba
# this function draws a goomba at a given offset
draw_goomba_a:

	lw $t4, 0($sp)		# pop a
	add $t3, $t0, $t4	#la $t3, a($t0)
	li $t1, GOOM1
	sw $t1, -516($t3)
	sw $t1, -512($t3)
	sw $t1, -264($t3)
	sw $t1, -256($t3)
	sw $t1, -12($t3)
	sw $t1, -8($t3)
	sw $t1, 0($t3)
	sw $t1, 8($t3)
	sw $t1, 244($t3)
	sw $t1, 248($t3)
	sw $t1, 252($t3)
	sw $t1, 256($t3)
	sw $t1, 260($t3)
	sw $t1, 264($t3)
	li $t1, BLACK
	sw $t1, -520($t3)
	sw $t1, -504($t3)
	sw $t1, -260($t3)
	sw $t1, -252($t3)
	sw $t1, 764($t3)
	sw $t1, 772($t3)
	li $t1, WHITE
	sw $t1, -4($t3)
	sw $t1, 4($t3)
	li $t1, GOOM2
	sw $t1, 508($t3)
	sw $t1, 512($t3)
	sw $t1, 768($t3)
	
	addi $sp, $sp, 4
	jr $ra

###### DRAW_MARIO ######
# function draw_mario(int a):
# a is the starting offset of mario
# this function draws a mario at a given offset
draw_mario_a:

	lw $t4, 0($sp)		# pop a
	add $t3, $t0, $t4	#la $t3, a($t0)
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
	
	addi $sp, $sp, 4
	jr $ra

###### DRAW_PLAYER ######
# function draw_player():
# no parameters, no return
# this function draws a player
draw_player:
	lw $t3, 0($t2)		# retrieves position of player
	lw $t4, 8($t2)		# retrieves direction of player
	
	beq $t4, 1, paint_left		# dir = 1 means player is facing left

paint_right:
	li $t1, PEACH1
	sw $t1, -1028($t3)
	sw $t1, -1024($t3)
	li $t1, PEACH2
	sw $t1, -776($t3)
	sw $t1, -772($t3)
	sw $t1, -768($t3)
	sw $t1, -524($t3)
	sw $t1, -520($t3)
	sw $t1, -508($t3)
	sw $t1, -264($t3)
	sw $t1, -12($t3)
	li $t1, PEACH3
	sw $t1, -516($t3)
	sw $t1, -512($t3)
	sw $t1, -260($t3)
	sw $t1, -256($t3)
	li $t1, PEACH4
	sw $t1, -8($t3)
	sw $t1, -4($t3)
	sw $t1, 4($t3)
	sw $t1, 508($t3)
	sw $t1, 512($t3)
	li $t1, PEACH5
	sw $t1, 252($t3)
	sw $t1, 256($t3)
	sw $t1, 504($t3)
	sw $t1, 516($t3)
	sw $t1, 756($t3)
	sw $t1, 760($t3)
	sw $t1, 764($t3)
	sw $t1, 768($t3)
	sw $t1, 772($t3)
	li $t1, PEACH6
	sw $t1, 0($t3)
	li $t1, WHITE
	sw $t1, 248($t3)
	sw $t1, 264($t3)
	li $t1, BLACK
	sw $t1, 8($t3)
	sw $t1, 12($t3)
	
	jr $ra
	
paint_left:
	li $t1, PEACH1
	sw $t1, -1024($t3)
	sw $t1, -1020($t3)
	li $t1, PEACH2
	sw $t1, -768($t3)
	sw $t1, -764($t3)
	sw $t1, -760($t3)
	sw $t1, -516($t3)
	sw $t1, -504($t3)
	sw $t1, -500($t3)
	sw $t1, -248($t3)
	sw $t1, 12($t3)
	li $t1, PEACH3
	sw $t1, -512($t3)
	sw $t1, -508($t3)
	sw $t1, -256($t3)
	sw $t1, -252($t3)
	li $t1, PEACH4
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
	sw $t1, 764($t3)
	sw $t1, 768($t3)
	sw $t1, 772($t3)
	sw $t1, 776($t3)
	sw $t1, 780($t3)
	li $t1, PEACH6
	sw $t1, 0($t3)
	li $t1, WHITE
	sw $t1, 248($t3)
	sw $t1, 264($t3)
	li $t1, BLACK
	sw $t1, -12($t3)
	sw $t1, -8($t3)
	
	jr $ra

###### CLEAR_PLAYER ######
# function clear_player():
# no parameters, no return
# this function removes the player
clear_player:
	lw $t3, 0($t2)		# retrieves position of player
	lw $t4, 8($t2)		# retrieves direction of player
	li $t1, BLUE_SKY	
	
	beq $t4, 1, clear_left		# dir = 1 means player is facing left

clear_right:
	sw $t1, -1028($t3)
	sw $t1, -1024($t3)
	sw $t1, -776($t3)
	sw $t1, -772($t3)
	sw $t1, -768($t3)
	sw $t1, -524($t3)
	sw $t1, -520($t3)
	sw $t1, -508($t3)
	sw $t1, -264($t3)
	sw $t1, -12($t3)
	sw $t1, -516($t3)
	sw $t1, -512($t3)
	sw $t1, -260($t3)
	sw $t1, -256($t3)
	sw $t1, -8($t3)
	sw $t1, -4($t3)
	sw $t1, 4($t3)
	sw $t1, 508($t3)
	sw $t1, 512($t3)
	sw $t1, 252($t3)
	sw $t1, 256($t3)
	sw $t1, 504($t3)
	sw $t1, 516($t3)
	sw $t1, 756($t3)
	sw $t1, 760($t3)
	sw $t1, 764($t3)
	sw $t1, 768($t3)
	sw $t1, 772($t3)
	sw $t1, 0($t3)
	sw $t1, 248($t3)
	sw $t1, 264($t3)
	sw $t1, 8($t3)
	sw $t1, 12($t3)
	
	jr $ra
	
clear_left:
	sw $t1, -1024($t3)
	sw $t1, -1020($t3)
	sw $t1, -768($t3)
	sw $t1, -764($t3)
	sw $t1, -760($t3)
	sw $t1, -516($t3)
	sw $t1, -504($t3)
	sw $t1, -500($t3)
	sw $t1, -248($t3)
	sw $t1, 12($t3)
	sw $t1, -512($t3)
	sw $t1, -508($t3)
	sw $t1, -256($t3)
	sw $t1, -252($t3)
	sw $t1, -4($t3)
	sw $t1, 4($t3)
	sw $t1, 8($t3)
	sw $t1, 512($t3)
	sw $t1, 516($t3)
	sw $t1, 256($t3)
	sw $t1, 260($t3)
	sw $t1, 508($t3)
	sw $t1, 520($t3)
	sw $t1, 764($t3)
	sw $t1, 768($t3)
	sw $t1, 772($t3)
	sw $t1, 776($t3)
	sw $t1, 780($t3)
	sw $t1, 0($t3)
	sw $t1, 248($t3)
	sw $t1, 264($t3)
	sw $t1, -12($t3)
	sw $t1, -8($t3)
	
	jr $ra

#### PLATFORM CREATE ####
# function create_platform(int a, int b):
# a is the starting index of the platform
# b is the length of the platform
create_platform_a_b:
 	li $t1, BROWN_PLATFORM
 	lw $t8, 0($sp)	# pop b
 	lw $t4, 4($sp)	# pop a
 	
	add $t4, $t0, $t4
	addi $t3, $zero, 0
	
create_loop1:
	bgt $t3, $t8, create_end
	addi $t4, $t4, 4
	sw $t1, 0($t4)
	sw $t1, 256($t4)
	addi $t3, $t3, 1
	j create_loop1

create_end:
	addi $sp, $sp, 8
	jr $ra


##### UPDATE PLAYER BULLETS #####
# function update_player_bullets()
# moves the player bullets
update_player_bullets:
	la $t3, player_bullet_array
	la $s1, num_player_bullets
	lw $s1, 0($s1)
	
	
	add $t8, $zero, $zero
u_l1:	bge $t8, $s1, u_el1
	
	lw $t4, 0($t3)		# load address of bullet
	
	lw $s0, 4($t3)		# load dir of bullet
	beq $s0, 1, u_left1	# branch if direction is left
	
	# check color at address 
u_right1:
	lw $s2, 4($t4)		# load color into $t2 at the address + 4 in $t4 (checks the right pixel)
	j u_else1
u_left1: 
	lw $s2, -4($t4)		# load color into $t2 at the address - 4 in $t4 (checks the left pixel)

	# branch depending on the color
u_else1:	
	beq $s2, GOOM1, u_goom
	beq $s2, GOOM2, u_goom
	beq $s2, BROWN_PLATFORM, u_platform
	
	# check if bullet hits edges
	lw $s2, 0($t3)		# load address of bullet
	sub $s2, $s2, $t0	# gets index of bullet
	li $s4, 4
	div $s2, $s2, $s4
	li $s4, 64
	div $s2, $s4
	mfhi $s2		# $s2 = $s2 mod 64
	
	beqz $s2, u_wall	# far left wall
	beq $s2, 63, u_wall	# far right wall
	
	j u_cont
	
u_wall:	
	# deletes it
	li $t1, 1
	sw $t1, 8($t3)		# change value of deleted in bullet to be 1
	
	# removes it from screen
	li $t1, BLUE_SKY
	lw $t4, 0($t3)		# load address of bullet
	sw $t1, 0($t4)
	
	addi $t3, $t3, 12
	addi $t8, $t8, 1
	j u_l1
	
u_goom:	
	# deletes it
	li $t1, 1
	sw $t1, 8($t3)		# change value of deleted in bullet to be 1
	
	# removes it from screen
	li $t1, BLUE_SKY
	lw $t4, 0($t3)		# load address of bullet
	sw $t1, 0($t4)
	
	addi $t3, $t3, 12
	addi $t8, $t8, 1
	j u_l1
	
u_platform:
	# deletes it
	li $t1, 1
	sw $t1, 8($t3)		# change value of deleted in bullet to be 1
	
	# removes it from screen
	li $t1, BLUE_SKY
	lw $t4, 0($t3)		# load address of bullet
	sw $t1, 0($t4)
	
	addi $t3, $t3, 12
	addi $t8, $t8, 1
	j u_l1
	
	# next pixel the bullet is going to is not special, thus bullet continues flying (i.e. no collisions)
u_cont:	
	li $t1, BLUE_SKY
	sw $t1, 0($t4)
	
	lw $s0, 4($t3)		# load dir of bullet
	beq $s0, 1, u_left	# branch if direction is left
	addi $t4, $t4, 4
	j u_else

u_left:	addi $t4, $t4, -4
	
u_else:
	sw $t4, 0($t3)		# store address of bullet
	
	li $t1, PEACH_BULLET
	sw $t1, 0($t4)
	
	addi $t3, $t3, 12
	addi $t8, $t8, 1
	j u_l1
	
u_el1:	jr $ra

##### DELETE PLAYER BULLETS #####
# function delete_player_bullets()
# deletes the player bullets that were deleted when update_player_bullets() was called.
delete_player_bullets:
	la $t3, player_bullet_array
	la $s3, player_bullet_array	# $s3 is the address we put the non-deleted bullets into (it replaces the bullets)
	la $s1, num_player_bullets
	lw $s1, 0($s1)
	
	li $s0, 0		# $s0 counts the number of non-deleted bullets
	
	li $t8, 0
dpb_l1:	bge $t8, $s1, dpb_end	# loops through the bullets in player_bullet_array
	
	lw $t4, 8($t3)		# load deleted value of bullet
	
	bnez $t4, if1_cont 
if1_z:	
	lw $s4, 0($t3)		# load address of bullet
	lw $s5, 4($t3)		# load direction of bullet
	lw $s6, 8($t3)		# load deleted value of bullet
	
	sw $s4, 0($s3)		# store address of bullet
	sw $s5, 4($s3)		# store direction of bullet
	sw $s6, 8($s3)		# store deleted value of bullet
	
	addi $s3, $s3, 12
	addi $s0, $s0, 1	# increment $s0 count

if1_cont:
	addi $t3, $t3, 12
	addi $t8, $t8, 1
	j dpb_l1
	
dpb_end:
	la $s1, num_player_bullets
	sw $s0, 0($s1)
	jr $ra

##### MAIN #####

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
	la $t7, 14848($t0)
	
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
	la $t7, 15360($t0)
	
LOOP3: 	bge $t6, $t5, ELOOP3
	sw $t1, 0($t7)
	addi $t7, $t7, 4
	addi $t6, $t6, 1
	j LOOP3
ELOOP3:

	
##### MAIN LOOP #####
	
	addi $t5,$zero, 1
	li $t9, KEY_ADDRESS
MAIN_L:	beq $t5, $zero, END

#### PAINTING CHARACTERS ####

	# paint goomba 1
	addi $t8, $zero, 8296
	addi $sp, $sp, -4
	sw $t8, 0($sp)
	jal draw_goomba_a
	
	# paint goomba 2
	addi $t8, $zero, 13968
	addi $sp, $sp, -4
	sw $t8, 0($sp)
	jal draw_goomba_a

	# paint mario
	addi $t8, $zero, 3376
	addi $sp, $sp, -4
	sw $t8, 0($sp)
	jal draw_mario_a
	
	# paint player
	jal draw_player

#### PLATFORM CREATE ####

	addi $t8, $zero, 11400
	addi $sp, $sp, -4
	sw $t8, 0($sp)
	addi $t8, $zero, 24
	addi $sp, $sp, -4
	sw $t8, 0($sp)
	jal create_platform_a_b

	addi $t8, $zero, 9296
	addi $sp, $sp, -4
	sw $t8, 0($sp)
	addi $t8, $zero, 8
	addi $sp, $sp, -4
	sw $t8, 0($sp)
	jal create_platform_a_b
	
	addi $t8, $zero, 5500
	addi $sp, $sp, -4
	sw $t8, 0($sp)
	addi $t8, $zero, 16
	addi $sp, $sp, -4
	sw $t8, 0($sp)
	jal create_platform_a_b
	
	addi $t8, $zero, 4360
	addi $sp, $sp, -4
	sw $t8, 0($sp)
	addi $t8, $zero, 16
	addi $sp, $sp, -4
	sw $t8, 0($sp)
	jal create_platform_a_b
	
##### update bullets #####
	
	jal update_player_bullets
	jal delete_player_bullets
	
##### check key #####

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
	beq $t6, 0x6b, k_clicked	# k clicked
	beq $t6, 0x70, main		# p clicked
	j key_no_clicked
	
##### do code below if the 'w' key is clicked ##### 
w_clicked: 

	# consider if double jump
	la $t3, jump_count
 	lw $t8, 0($t3)		# $t8 = value of jump_count
	
 	bgt $t8, 1, key_no_clicked
 	
 	addi $t8, $t8, 1	# increment jump_count
 	sw $t8, 0($t3)

 	# do jump 	
can_jump:

	lw $t4, 4($t2) 	# retrieves index of player
	
	addi $t4, $t4, -640
	ble $t4, 320, key_no_clicked # jumps if index is less than 320
	sw $t4, 4($t2)
	
	jal clear_player
	lw $t4, 0($t2) 	# retrieves position address of player
	addi $t4, $t4, -2560
	sw $t4, 0($t2)
	jal draw_player
	j key_no_clicked

##### do code below if the 'a' key is clicked ##### 
a_clicked: 

##### checks collisions #####
check_object_collision_a:
	lw $t4, 0($t2) 	# retrives address of player
	li $t1, GOOM1	# checks if moving left will collide with goomba
	
	lw $t3, -16($t4)
	beq $t1, $t3, key_no_clicked
	lw $t3, -20($t4)
	beq $t1, $t3, key_no_clicked
	lw $t3, -528($t4)
	beq $t1, $t3, key_no_clicked
	lw $t3, -532($t4)
	beq $t1, $t3, key_no_clicked
	lw $t3, 496($t4)
	beq $t1, $t3, key_no_clicked
	lw $t3, 492($t4)
	beq $t1, $t3, key_no_clicked
	lw $t3, 1008($t4)
	beq $t1, $t3, key_no_clicked
	lw $t3, 1004($t4)
	bne $t1, $t3, a_if1
a_if1:	

##### makes the player face left #####
	addi $t8, $zero, 1
	sw $t8, 8($t2)		# look left
	jal clear_player
	jal draw_player

##### checks if player is on the left side of the screen #####
check_wall_collision_a:
	lw $t4, 4($t2) 		# retrives index of player
	addi $t4, $t4, -3	# current index of player -3 (most left pixel of player -1 to the left)
	addi $t8, $t4, -2	# gets the index -2 to the left of $t4 (so basically current index of player -5)
	
	addi $t3, $zero, 64
	div $t4, $t3		# calculate $t4/64
	mfhi $t4		# set $t4 = $t4 mod 64
	div $t8, $t3		# calculate $t8/64
	mfhi $t8		# set $t8 = $t8 mod 64
	
	blt $t4, $t8, key_no_clicked # jumps if $t4 mod 64 < $t8 mod 64
	lw $t4, 4($t2) 		# retrives index of player
	addi $t4, $t4, -2
	sw $t4, 4($t2)

	jal clear_player
	lw $t4, 0($t2) 		# retrives position address of player
	addi $t4, $t4, -8
	sw $t4, 0($t2)
	jal draw_player
	j key_no_clicked
	
##### do code below if the 's' key is clicked ##### 
s_clicked: 
	addi $t8, $zero, 64
	
	lw $t4, 0($t2) 	# retrives index of player
	lw $t3, 1020($t4) # $t3 is the color of the pixel 4 units below the center 
##### checks if platform is below the player #####
	li $t1, BROWN_PLATFORM
	
	beq $t1, $t3, s_if1
	lw $t3, 1028($t4)
	beq $t1, $t3, s_if1
	lw $t3, 1012($t4)
	bne $t1, $t3, key_no_clicked

	# if below platform is the player, the fall will be harder
s_if1:	sll $t8, $t8, 2
	j s_fall


##### checks if ground is below the player #####
	lw $t4, 0($t2) 	# retrives position address of player
	lw $t3, 1024($t4) # $t3 is the color of the pixel 4 units below the center 
	# (if we check this pixel and if it is the colour of the ground, this means that
	# the player is on the ground
	li $t1, GREEN_GROUND
	
	# cannot press 's' if player is currently on the ground.
	beq $t1, $t3, key_no_clicked

##### falls only after the checks above #####
s_fall:	lw $t4, 4($t2) 	# retrives index of player
	add $t4, $t4, $t8
	sw $t4, 4($t2)
	
	sll $t8, $t8, 2
	jal clear_player
	lw $t4, 0($t2) 	# retrives position address of player
	add $t4, $t4, $t8
	sw $t4, 0($t2)
	jal draw_player
	j key_no_clicked

##### do code below if the 'd' key is clicked ##### 
d_clicked:

##### checks collisions #####
check_object_collision_d:
	lw $t4, 0($t2) 	# retrives address of player
	li $t1, GOOM1	# checks if moving right will collide with goomba
	
	lw $t3, 16($t4)
	beq $t1, $t3, key_no_clicked
	lw $t3, 20($t4)
	beq $t1, $t3, key_no_clicked
	lw $t3, 528($t4)
	beq $t1, $t3, key_no_clicked
	lw $t3, 532($t4)
	beq $t1, $t3, key_no_clicked
	lw $t3, -496($t4)
	beq $t1, $t3, key_no_clicked
	lw $t3, -492($t4)
	beq $t1, $t3, key_no_clicked
	lw $t3, 1040($t4)
	beq $t1, $t3, key_no_clicked
	lw $t3, 1044($t4)
	bne $t1, $t3, d_if1
d_if1:	
	
##### makes the player face right #####
	addi $t8, $zero, 2
	sw $t8, 8($t2)		# look right
	jal clear_player
	jal draw_player
	
##### checks if player is on the right side of the screen #####
check_wall_collision_d:
	lw $t4, 4($t2) 		# retrives index of player
	addi $t4, $t4, 3	# current index of player 3 (most left pixel of player 1 to the left)
	addi $t8, $t4, 2	# gets the index 2 to the left of $t4 (so basically current index of player +5)
	
	addi $t3, $zero, 64
	div $t4, $t3		# calculate $t4/64
	mfhi $t4		# set $t4 = $t4 mod 64
	div $t8, $t3		# calculate $t8/64
	mfhi $t8		# set $t8 = $t8 mod 64
	
	bgt $t4, $t8, key_no_clicked # jumps if $t4 mod 64 > $t8 mod 64
	lw $t4, 4($t2) 		# retrives index of player
	addi $t4, $t4, 2
	sw $t4, 4($t2)

	jal clear_player
	lw $t4, 0($t2) 		# retrives position address of player
	addi $t4, $t4, 8
	sw $t4, 0($t2)
	jal draw_player
	j key_no_clicked
	
##### do code below if the 'k' key is clicked ##### 
k_clicked:
	li $t1, PEACH_BULLET
	lw $t4, 0($t2) 		# retrieves position address of player
	lw $t3, 8($t2) 		# retrieves direction of player
	
	beq $t3, 1, k_left
	addi $t4, $t4, 20
	sw $t1, 0($t4)
	j store_to_array
	
k_left:
	addi $t4, $t4, -20
	sw $t1, 0($t4)

store_to_array:
	la $t3, player_bullet_array
	la $t1, num_player_bullets
	lw $t1, 0($t1)
	
	add $t8, $zero, $zero
k_l1:	bge $t8, $t1, k_el1
	addi $t3, $t3, 12
	addi $t8, $t8, 1
	j k_l1
	
k_el1:
	sw $t4, 0($t3)		# store address of bullet
	lw $t4, 8($t2) 		# retrieves direction of player
	sw $t4, 4($t3)		# store direction of bullet
	sw $zero, 8($t3)	# store value of deleted to 0 of current bullet
	
	la $t1, num_player_bullets
	lw $t4, 0($t1)
	addi $t4, $t4, 1	# add 1 to total num_player_bullets
	sw $t4, 0($t1)
	
##### do code below if no key is clicked ##### 
key_no_clicked:

##### checks if ground is below the player #####
	lw $t4, 0($t2) 	# retrives position address of player
	lw $t3, 1020($t4) # $t3 is the color of the pixel 4 units below the center 
	# (if we check this pixel and if it is the colour of the ground, this means that
	# the player is on the ground
	li $t1, GREEN_GROUND
	beq $t1, $t3, grounded
	
##### checks collisions #####
check_object_collision_no_key:
	lw $t4, 0($t2) 	# retrives address of player
	li $t1, GOOM1	# checks if moving up will collide with goomba
	
	lw $t3, 1020($t4)
	beq $t1, $t3, grounded
	lw $t3, 1028($t4)
	beq $t1, $t3, grounded
	lw $t3, 1036($t4)
	beq $t1, $t3, grounded
	lw $t3, 1012($t4)
	beq $t1, $t3, grounded
	lw $t3, 1268($t4)
	beq $t1, $t3, grounded
	lw $t3, 1276($t4)
	beq $t1, $t3, grounded
	lw $t3, 1284($t4)
	beq $t1, $t3, grounded
	lw $t3, 1292($t4)
	bne $t1, $t3, no_key_if1
no_key_if1:	
	
##### checks if platform is below the player #####
	li $t1, BROWN_PLATFORM
	lw $t3, 1020($t4)
	beq $t1, $t3, IF1
	lw $t3, 1028($t4)
	beq $t1, $t3, IF1
	lw $t3, 1012($t4)
	bne $t1, $t3, gravity

IF1:	j grounded


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
	j end_iteration
	
grounded:
	# resets jump count when player is grounded
	la $t3, jump_count
	lw $t8, 0($t3)
	
 	sw $zero, 0($t3)
	
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

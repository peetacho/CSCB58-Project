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
player_bullet_array: .space 240 	# each bullet has space of 12, so the array only allows 20 bullets
enemy_array: .word 8296, 0, 13968, 0, 4532, 0
total_num_enemy: .word 3
num_enemy_array: .word 3, 4, 5		# each element at index i represents the number of enemies at level i
current_level: .word 1
num_hearts: .word 4			# player starts with 4 hearts

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
.eqv  PINK_GAME_OVER 0xffdbfe

# Princess peach colours
.eqv  PEACH1  0xe5994c
.eqv  PEACH2  0xf5c637
.eqv  PEACH3  0xffe8b0
.eqv  PEACH4  0xff73a1
.eqv  PEACH5  0xf0366f
.eqv  PEACH6  0x289ddb
.eqv  PEACH_BULLET 0xf0366e

# mario colours
.eqv  MARIO1  0xfa3838
.eqv  MARIO2  0x704b41
.eqv  MARIO3  0xffc57d
.eqv  MARIO4  0x1d46f6

# goomba colours
.eqv  GOOM1  0x6a3917
.eqv  GOOM2  0xc08d66

# heart colours
.eqv  HEART1  0xff334b
.eqv  HEART2  0xcd335b

####### RESERVED REGISTERS #######
# $t0 stores the BASE_ADDRESS
# $t1 is ocassionally used to store color
# $t2 stores player position at all times (has a beginning position)
# $t5, $t6, $t7, $t9 is used inside the main loop
# $t4, $t3, $t8 can be used for other stuff
#################################

.text 
.globl main

#### DRAW YOU WIN ####
# function draw_you_win():
# this function draws the you win screen	
draw_you_win:
	li $t1, PINK_GAME_OVER
	li $t3, 0
	move $t4, $t0
draw_you_win_l:
	bgt $t3, 4095, draw_you_win_end
	sw $t1, 0($t4)
	addi $t4, $t4, 4
	addi $t3, $t3, 1
	j draw_you_win_l
	
draw_you_win_end:
	addi $t3, $t0, 2632
	li $t1, 0xf99cb7
	sw $t1, 0($t3)
	addi $t3, $t0, 2636
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2640
	li $t1, 0xffebf3
	sw $t1, 0($t3)
	addi $t3, $t0, 2648
	li $t1, 0xfed4e0
	sw $t1, 0($t3)
	addi $t3, $t0, 2652
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2656
	sw $t1, 0($t3)
	addi $t3, $t0, 2660
	li $t1, 0xffe5ee
	sw $t1, 0($t3)
	addi $t3, $t0, 2672
	li $t1, 0xffeaf3
	sw $t1, 0($t3)
	addi $t3, $t0, 2676
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2680
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2684
	sw $t1, 0($t3)
	addi $t3, $t0, 2688
	sw $t1, 0($t3)
	addi $t3, $t0, 2692
	sw $t1, 0($t3)
	addi $t3, $t0, 2696
	sw $t1, 0($t3)
	addi $t3, $t0, 2700
	li $t1, 0xf9d8e1
	sw $t1, 0($t3)
	addi $t3, $t0, 2720
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2724
	sw $t1, 0($t3)
	addi $t3, $t0, 2728
	li $t1, 0xfad6e0
	sw $t1, 0($t3)
	addi $t3, $t0, 2736
	li $t1, 0xffd3e5
	sw $t1, 0($t3)
	addi $t3, $t0, 2740
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2744
	li $t1, 0xfc94b5
	sw $t1, 0($t3)
	addi $t3, $t0, 2884
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2888
	sw $t1, 0($t3)
	addi $t3, $t0, 2892
	sw $t1, 0($t3)
	addi $t3, $t0, 2896
	sw $t1, 0($t3)
	addi $t3, $t0, 2900
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2904
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2908
	sw $t1, 0($t3)
	addi $t3, $t0, 2912
	sw $t1, 0($t3)
	addi $t3, $t0, 2916
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2924
	sw $t1, 0($t3)
	addi $t3, $t0, 2928
	li $t1, 0xffe4f0
	sw $t1, 0($t3)
	addi $t3, $t0, 2932
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2936
	sw $t1, 0($t3)
	addi $t3, $t0, 2940
	sw $t1, 0($t3)
	addi $t3, $t0, 2944
	sw $t1, 0($t3)
	addi $t3, $t0, 2948
	sw $t1, 0($t3)
	addi $t3, $t0, 2952
	sw $t1, 0($t3)
	addi $t3, $t0, 2956
	sw $t1, 0($t3)
	addi $t3, $t0, 2968
	li $t1, 0xf897b6
	sw $t1, 0($t3)
	addi $t3, $t0, 2972
	li $t1, 0xf2adc2
	sw $t1, 0($t3)
	addi $t3, $t0, 2976
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2980
	sw $t1, 0($t3)
	addi $t3, $t0, 2984
	sw $t1, 0($t3)
	addi $t3, $t0, 2992
	sw $t1, 0($t3)
	addi $t3, $t0, 2996
	sw $t1, 0($t3)
	addi $t3, $t0, 3000
	sw $t1, 0($t3)
	addi $t3, $t0, 3140
	sw $t1, 0($t3)
	addi $t3, $t0, 3144
	sw $t1, 0($t3)
	addi $t3, $t0, 3148
	sw $t1, 0($t3)
	addi $t3, $t0, 3152
	sw $t1, 0($t3)
	addi $t3, $t0, 3156
	sw $t1, 0($t3)
	addi $t3, $t0, 3160
	sw $t1, 0($t3)
	addi $t3, $t0, 3164
	sw $t1, 0($t3)
	addi $t3, $t0, 3168
	sw $t1, 0($t3)
	addi $t3, $t0, 3172
	li $t1, 0xf399b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3180
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3184
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3188
	sw $t1, 0($t3)
	addi $t3, $t0, 3192
	sw $t1, 0($t3)
	addi $t3, $t0, 3196
	sw $t1, 0($t3)
	addi $t3, $t0, 3208
	sw $t1, 0($t3)
	addi $t3, $t0, 3212
	sw $t1, 0($t3)
	addi $t3, $t0, 3224
	sw $t1, 0($t3)
	addi $t3, $t0, 3228
	sw $t1, 0($t3)
	addi $t3, $t0, 3232
	sw $t1, 0($t3)
	addi $t3, $t0, 3236
	sw $t1, 0($t3)
	addi $t3, $t0, 3240
	sw $t1, 0($t3)
	addi $t3, $t0, 3248
	sw $t1, 0($t3)
	addi $t3, $t0, 3252
	sw $t1, 0($t3)
	addi $t3, $t0, 3256
	sw $t1, 0($t3)
	addi $t3, $t0, 3400
	li $t1, 0xf898b4
	sw $t1, 0($t3)
	addi $t3, $t0, 3404
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3408
	sw $t1, 0($t3)
	addi $t3, $t0, 3412
	sw $t1, 0($t3)
	addi $t3, $t0, 3416
	sw $t1, 0($t3)
	addi $t3, $t0, 3420
	sw $t1, 0($t3)
	addi $t3, $t0, 3436
	sw $t1, 0($t3)
	addi $t3, $t0, 3440
	sw $t1, 0($t3)
	addi $t3, $t0, 3444
	sw $t1, 0($t3)
	addi $t3, $t0, 3448
	sw $t1, 0($t3)
	addi $t3, $t0, 3452
	sw $t1, 0($t3)
	addi $t3, $t0, 3464
	sw $t1, 0($t3)
	addi $t3, $t0, 3468
	sw $t1, 0($t3)
	addi $t3, $t0, 3480
	sw $t1, 0($t3)
	addi $t3, $t0, 3484
	sw $t1, 0($t3)
	addi $t3, $t0, 3488
	sw $t1, 0($t3)
	addi $t3, $t0, 3492
	sw $t1, 0($t3)
	addi $t3, $t0, 3496
	sw $t1, 0($t3)
	addi $t3, $t0, 3504
	sw $t1, 0($t3)
	addi $t3, $t0, 3508
	sw $t1, 0($t3)
	addi $t3, $t0, 3512
	sw $t1, 0($t3)
	addi $t3, $t0, 3660
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3664
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3668
	sw $t1, 0($t3)
	addi $t3, $t0, 3672
	sw $t1, 0($t3)
	addi $t3, $t0, 3676
	li $t1, 0xffd7e3
	sw $t1, 0($t3)
	addi $t3, $t0, 3692
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3696
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3700
	sw $t1, 0($t3)
	addi $t3, $t0, 3704
	sw $t1, 0($t3)
	addi $t3, $t0, 3708
	sw $t1, 0($t3)
	addi $t3, $t0, 3720
	sw $t1, 0($t3)
	addi $t3, $t0, 3724
	sw $t1, 0($t3)
	addi $t3, $t0, 3736
	sw $t1, 0($t3)
	addi $t3, $t0, 3740
	sw $t1, 0($t3)
	addi $t3, $t0, 3744
	sw $t1, 0($t3)
	addi $t3, $t0, 3748
	sw $t1, 0($t3)
	addi $t3, $t0, 3752
	sw $t1, 0($t3)
	addi $t3, $t0, 3760
	sw $t1, 0($t3)
	addi $t3, $t0, 3764
	sw $t1, 0($t3)
	addi $t3, $t0, 3768
	sw $t1, 0($t3)
	addi $t3, $t0, 3916
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3920
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3924
	sw $t1, 0($t3)
	addi $t3, $t0, 3928
	sw $t1, 0($t3)
	addi $t3, $t0, 3932
	li $t1, 0xfbdae3
	sw $t1, 0($t3)
	addi $t3, $t0, 3948
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3952
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3956
	sw $t1, 0($t3)
	addi $t3, $t0, 3960
	sw $t1, 0($t3)
	addi $t3, $t0, 3964
	sw $t1, 0($t3)
	addi $t3, $t0, 3976
	sw $t1, 0($t3)
	addi $t3, $t0, 3980
	sw $t1, 0($t3)
	addi $t3, $t0, 3992
	sw $t1, 0($t3)
	addi $t3, $t0, 3996
	sw $t1, 0($t3)
	addi $t3, $t0, 4000
	sw $t1, 0($t3)
	addi $t3, $t0, 4004
	sw $t1, 0($t3)
	addi $t3, $t0, 4008
	sw $t1, 0($t3)
	addi $t3, $t0, 4016
	sw $t1, 0($t3)
	addi $t3, $t0, 4020
	sw $t1, 0($t3)
	addi $t3, $t0, 4024
	sw $t1, 0($t3)
	addi $t3, $t0, 4172
	sw $t1, 0($t3)
	addi $t3, $t0, 4176
	sw $t1, 0($t3)
	addi $t3, $t0, 4180
	sw $t1, 0($t3)
	addi $t3, $t0, 4184
	sw $t1, 0($t3)
	addi $t3, $t0, 4188
	li $t1, 0xfbdae3
	sw $t1, 0($t3)
	addi $t3, $t0, 4204
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4208
	sw $t1, 0($t3)
	addi $t3, $t0, 4212
	sw $t1, 0($t3)
	addi $t3, $t0, 4216
	sw $t1, 0($t3)
	addi $t3, $t0, 4220
	sw $t1, 0($t3)
	addi $t3, $t0, 4232
	sw $t1, 0($t3)
	addi $t3, $t0, 4236
	sw $t1, 0($t3)
	addi $t3, $t0, 4248
	sw $t1, 0($t3)
	addi $t3, $t0, 4252
	sw $t1, 0($t3)
	addi $t3, $t0, 4256
	sw $t1, 0($t3)
	addi $t3, $t0, 4260
	sw $t1, 0($t3)
	addi $t3, $t0, 4264
	sw $t1, 0($t3)
	addi $t3, $t0, 4272
	sw $t1, 0($t3)
	addi $t3, $t0, 4276
	sw $t1, 0($t3)
	addi $t3, $t0, 4280
	sw $t1, 0($t3)
	addi $t3, $t0, 4428
	sw $t1, 0($t3)
	addi $t3, $t0, 4432
	sw $t1, 0($t3)
	addi $t3, $t0, 4436
	sw $t1, 0($t3)
	addi $t3, $t0, 4440
	sw $t1, 0($t3)
	addi $t3, $t0, 4444
	li $t1, 0xffe9f2
	sw $t1, 0($t3)
	addi $t3, $t0, 4460
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4464
	sw $t1, 0($t3)
	addi $t3, $t0, 4468
	sw $t1, 0($t3)
	addi $t3, $t0, 4472
	sw $t1, 0($t3)
	addi $t3, $t0, 4476
	sw $t1, 0($t3)
	addi $t3, $t0, 4480
	sw $t1, 0($t3)
	addi $t3, $t0, 4484
	sw $t1, 0($t3)
	addi $t3, $t0, 4488
	sw $t1, 0($t3)
	addi $t3, $t0, 4492
	sw $t1, 0($t3)
	addi $t3, $t0, 4504
	sw $t1, 0($t3)
	addi $t3, $t0, 4508
	sw $t1, 0($t3)
	addi $t3, $t0, 4512
	sw $t1, 0($t3)
	addi $t3, $t0, 4516
	sw $t1, 0($t3)
	addi $t3, $t0, 4520
	sw $t1, 0($t3)
	addi $t3, $t0, 4524
	sw $t1, 0($t3)
	addi $t3, $t0, 4528
	sw $t1, 0($t3)
	addi $t3, $t0, 4532
	sw $t1, 0($t3)
	addi $t3, $t0, 4536
	sw $t1, 0($t3)
	addi $t3, $t0, 4684
	sw $t1, 0($t3)
	addi $t3, $t0, 4688
	sw $t1, 0($t3)
	addi $t3, $t0, 4692
	sw $t1, 0($t3)
	addi $t3, $t0, 4696
	sw $t1, 0($t3)
	addi $t3, $t0, 4700
	li $t1, 0xffe9f2
	sw $t1, 0($t3)
	addi $t3, $t0, 4716
	li $t1, 0xf59bb5
	sw $t1, 0($t3)
	addi $t3, $t0, 4720
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4724
	sw $t1, 0($t3)
	addi $t3, $t0, 4728
	sw $t1, 0($t3)
	addi $t3, $t0, 4732
	sw $t1, 0($t3)
	addi $t3, $t0, 4736
	sw $t1, 0($t3)
	addi $t3, $t0, 4740
	sw $t1, 0($t3)
	addi $t3, $t0, 4744
	sw $t1, 0($t3)
	addi $t3, $t0, 4748
	sw $t1, 0($t3)
	addi $t3, $t0, 4760
	li $t1, 0xf79ab5
	sw $t1, 0($t3)
	addi $t3, $t0, 4764
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4768
	sw $t1, 0($t3)
	addi $t3, $t0, 4772
	sw $t1, 0($t3)
	addi $t3, $t0, 4776
	sw $t1, 0($t3)
	addi $t3, $t0, 4780
	sw $t1, 0($t3)
	addi $t3, $t0, 4784
	sw $t1, 0($t3)
	addi $t3, $t0, 4788
	sw $t1, 0($t3)
	addi $t3, $t0, 4792
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4940
	li $t1, 0xfefcfd
	sw $t1, 0($t3)
	addi $t3, $t0, 4944
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4948
	sw $t1, 0($t3)
	addi $t3, $t0, 4952
	li $t1, 0xf796b5
	sw $t1, 0($t3)
	addi $t3, $t0, 4976
	li $t1, 0xffe2ef
	sw $t1, 0($t3)
	addi $t3, $t0, 4980
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4984
	sw $t1, 0($t3)
	addi $t3, $t0, 4988
	sw $t1, 0($t3)
	addi $t3, $t0, 4992
	sw $t1, 0($t3)
	addi $t3, $t0, 4996
	sw $t1, 0($t3)
	addi $t3, $t0, 5000
	sw $t1, 0($t3)
	addi $t3, $t0, 5020
	li $t1, 0xf4acc2
	sw $t1, 0($t3)
	addi $t3, $t0, 5024
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 5028
	sw $t1, 0($t3)
	addi $t3, $t0, 5032
	sw $t1, 0($t3)
	addi $t3, $t0, 5036
	sw $t1, 0($t3)
	addi $t3, $t0, 5040
	sw $t1, 0($t3)
	addi $t3, $t0, 5044
	sw $t1, 0($t3)
	addi $t3, $t0, 6464
	li $t1, 0xffe5ee
	sw $t1, 0($t3)
	addi $t3, $t0, 6468
	li $t1, 0xffe4ee
	sw $t1, 0($t3)
	addi $t3, $t0, 6472
	li $t1, 0xf898b4
	sw $t1, 0($t3)
	addi $t3, $t0, 6492
	li $t1, 0xffc2d5
	sw $t1, 0($t3)
	addi $t3, $t0, 6496
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6500
	li $t1, 0xf897b6
	sw $t1, 0($t3)
	addi $t3, $t0, 6512
	li $t1, 0xf8c5d4
	sw $t1, 0($t3)
	addi $t3, $t0, 6520
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6524
	sw $t1, 0($t3)
	addi $t3, $t0, 6536
	li $t1, 0xf2b5c7
	sw $t1, 0($t3)
	addi $t3, $t0, 6540
	li $t1, 0xffe4ee
	sw $t1, 0($t3)
	addi $t3, $t0, 6544
	sw $t1, 0($t3)
	addi $t3, $t0, 6564
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6568
	li $t1, 0xffcadb
	sw $t1, 0($t3)
	addi $t3, $t0, 6584
	li $t1, 0xf9abc1
	sw $t1, 0($t3)
	addi $t3, $t0, 6588
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6592
	sw $t1, 0($t3)
	addi $t3, $t0, 6720
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6724
	li $t1, 0xffc2d5
	sw $t1, 0($t3)
	addi $t3, $t0, 6728
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6748
	sw $t1, 0($t3)
	addi $t3, $t0, 6752
	sw $t1, 0($t3)
	addi $t3, $t0, 6756
	sw $t1, 0($t3)
	addi $t3, $t0, 6768
	li $t1, 0xfcc3d4
	sw $t1, 0($t3)
	addi $t3, $t0, 6772
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6776
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6780
	sw $t1, 0($t3)
	addi $t3, $t0, 6792
	li $t1, 0xffecf7
	sw $t1, 0($t3)
	addi $t3, $t0, 6796
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6800
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6820
	sw $t1, 0($t3)
	addi $t3, $t0, 6824
	sw $t1, 0($t3)
	addi $t3, $t0, 6840
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6844
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6848
	sw $t1, 0($t3)
	addi $t3, $t0, 6976
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6980
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6984
	sw $t1, 0($t3)
	addi $t3, $t0, 6992
	li $t1, 0xffe4ee
	sw $t1, 0($t3)
	addi $t3, $t0, 6996
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7004
	sw $t1, 0($t3)
	addi $t3, $t0, 7008
	sw $t1, 0($t3)
	addi $t3, $t0, 7012
	sw $t1, 0($t3)
	addi $t3, $t0, 7024
	sw $t1, 0($t3)
	addi $t3, $t0, 7028
	sw $t1, 0($t3)
	addi $t3, $t0, 7032
	sw $t1, 0($t3)
	addi $t3, $t0, 7036
	sw $t1, 0($t3)
	addi $t3, $t0, 7048
	sw $t1, 0($t3)
	addi $t3, $t0, 7052
	sw $t1, 0($t3)
	addi $t3, $t0, 7056
	sw $t1, 0($t3)
	addi $t3, $t0, 7076
	sw $t1, 0($t3)
	addi $t3, $t0, 7080
	sw $t1, 0($t3)
	addi $t3, $t0, 7092
	sw $t1, 0($t3)
	addi $t3, $t0, 7096
	sw $t1, 0($t3)
	addi $t3, $t0, 7100
	sw $t1, 0($t3)
	addi $t3, $t0, 7104
	sw $t1, 0($t3)
	addi $t3, $t0, 7232
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7236
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7240
	sw $t1, 0($t3)
	addi $t3, $t0, 7248
	sw $t1, 0($t3)
	addi $t3, $t0, 7252
	sw $t1, 0($t3)
	addi $t3, $t0, 7260
	sw $t1, 0($t3)
	addi $t3, $t0, 7264
	sw $t1, 0($t3)
	addi $t3, $t0, 7268
	sw $t1, 0($t3)
	addi $t3, $t0, 7280
	sw $t1, 0($t3)
	addi $t3, $t0, 7284
	sw $t1, 0($t3)
	addi $t3, $t0, 7288
	sw $t1, 0($t3)
	addi $t3, $t0, 7292
	sw $t1, 0($t3)
	addi $t3, $t0, 7304
	sw $t1, 0($t3)
	addi $t3, $t0, 7308
	sw $t1, 0($t3)
	addi $t3, $t0, 7312
	sw $t1, 0($t3)
	addi $t3, $t0, 7316
	sw $t1, 0($t3)
	addi $t3, $t0, 7332
	sw $t1, 0($t3)
	addi $t3, $t0, 7336
	sw $t1, 0($t3)
	addi $t3, $t0, 7348
	sw $t1, 0($t3)
	addi $t3, $t0, 7352
	sw $t1, 0($t3)
	addi $t3, $t0, 7356
	sw $t1, 0($t3)
	addi $t3, $t0, 7360
	sw $t1, 0($t3)
	addi $t3, $t0, 7488
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7492
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7496
	sw $t1, 0($t3)
	addi $t3, $t0, 7500
	sw $t1, 0($t3)
	addi $t3, $t0, 7504
	sw $t1, 0($t3)
	addi $t3, $t0, 7508
	li $t1, 0xf898b4
	sw $t1, 0($t3)
	addi $t3, $t0, 7512
	li $t1, 0xf799b4
	sw $t1, 0($t3)
	addi $t3, $t0, 7516
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7520
	sw $t1, 0($t3)
	addi $t3, $t0, 7524
	sw $t1, 0($t3)
	addi $t3, $t0, 7536
	sw $t1, 0($t3)
	addi $t3, $t0, 7540
	sw $t1, 0($t3)
	addi $t3, $t0, 7544
	sw $t1, 0($t3)
	addi $t3, $t0, 7548
	sw $t1, 0($t3)
	addi $t3, $t0, 7560
	sw $t1, 0($t3)
	addi $t3, $t0, 7564
	sw $t1, 0($t3)
	addi $t3, $t0, 7568
	sw $t1, 0($t3)
	addi $t3, $t0, 7572
	sw $t1, 0($t3)
	addi $t3, $t0, 7576
	sw $t1, 0($t3)
	addi $t3, $t0, 7584
	sw $t1, 0($t3)
	addi $t3, $t0, 7588
	sw $t1, 0($t3)
	addi $t3, $t0, 7592
	sw $t1, 0($t3)
	addi $t3, $t0, 7604
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7608
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7612
	sw $t1, 0($t3)
	addi $t3, $t0, 7616
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7744
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7748
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7752
	sw $t1, 0($t3)
	addi $t3, $t0, 7756
	sw $t1, 0($t3)
	addi $t3, $t0, 7760
	sw $t1, 0($t3)
	addi $t3, $t0, 7764
	sw $t1, 0($t3)
	addi $t3, $t0, 7768
	sw $t1, 0($t3)
	addi $t3, $t0, 7772
	sw $t1, 0($t3)
	addi $t3, $t0, 7776
	sw $t1, 0($t3)
	addi $t3, $t0, 7780
	sw $t1, 0($t3)
	addi $t3, $t0, 7792
	sw $t1, 0($t3)
	addi $t3, $t0, 7796
	sw $t1, 0($t3)
	addi $t3, $t0, 7800
	sw $t1, 0($t3)
	addi $t3, $t0, 7804
	sw $t1, 0($t3)
	addi $t3, $t0, 7816
	sw $t1, 0($t3)
	addi $t3, $t0, 7820
	sw $t1, 0($t3)
	addi $t3, $t0, 7824
	sw $t1, 0($t3)
	addi $t3, $t0, 7828
	sw $t1, 0($t3)
	addi $t3, $t0, 7832
	sw $t1, 0($t3)
	addi $t3, $t0, 7836
	sw $t1, 0($t3)
	addi $t3, $t0, 7840
	sw $t1, 0($t3)
	addi $t3, $t0, 7844
	sw $t1, 0($t3)
	addi $t3, $t0, 7848
	sw $t1, 0($t3)
	addi $t3, $t0, 7864
	li $t1, 0xfa95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7868
	sw $t1, 0($t3)
	addi $t3, $t0, 8000
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8004
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8008
	sw $t1, 0($t3)
	addi $t3, $t0, 8012
	sw $t1, 0($t3)
	addi $t3, $t0, 8016
	sw $t1, 0($t3)
	addi $t3, $t0, 8020
	sw $t1, 0($t3)
	addi $t3, $t0, 8024
	sw $t1, 0($t3)
	addi $t3, $t0, 8028
	sw $t1, 0($t3)
	addi $t3, $t0, 8032
	sw $t1, 0($t3)
	addi $t3, $t0, 8036
	sw $t1, 0($t3)
	addi $t3, $t0, 8048
	sw $t1, 0($t3)
	addi $t3, $t0, 8052
	sw $t1, 0($t3)
	addi $t3, $t0, 8056
	sw $t1, 0($t3)
	addi $t3, $t0, 8060
	sw $t1, 0($t3)
	addi $t3, $t0, 8072
	sw $t1, 0($t3)
	addi $t3, $t0, 8076
	sw $t1, 0($t3)
	addi $t3, $t0, 8080
	sw $t1, 0($t3)
	addi $t3, $t0, 8084
	sw $t1, 0($t3)
	addi $t3, $t0, 8088
	sw $t1, 0($t3)
	addi $t3, $t0, 8092
	sw $t1, 0($t3)
	addi $t3, $t0, 8096
	sw $t1, 0($t3)
	addi $t3, $t0, 8100
	sw $t1, 0($t3)
	addi $t3, $t0, 8104
	sw $t1, 0($t3)
	addi $t3, $t0, 8120
	li $t1, 0xeeb8c8
	sw $t1, 0($t3)
	addi $t3, $t0, 8124
	sw $t1, 0($t3)
	addi $t3, $t0, 8256
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8260
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8264
	sw $t1, 0($t3)
	addi $t3, $t0, 8268
	sw $t1, 0($t3)
	addi $t3, $t0, 8272
	sw $t1, 0($t3)
	addi $t3, $t0, 8276
	sw $t1, 0($t3)
	addi $t3, $t0, 8280
	sw $t1, 0($t3)
	addi $t3, $t0, 8284
	sw $t1, 0($t3)
	addi $t3, $t0, 8288
	sw $t1, 0($t3)
	addi $t3, $t0, 8292
	sw $t1, 0($t3)
	addi $t3, $t0, 8304
	sw $t1, 0($t3)
	addi $t3, $t0, 8308
	sw $t1, 0($t3)
	addi $t3, $t0, 8312
	sw $t1, 0($t3)
	addi $t3, $t0, 8316
	sw $t1, 0($t3)
	addi $t3, $t0, 8328
	sw $t1, 0($t3)
	addi $t3, $t0, 8332
	sw $t1, 0($t3)
	addi $t3, $t0, 8336
	sw $t1, 0($t3)
	addi $t3, $t0, 8348
	sw $t1, 0($t3)
	addi $t3, $t0, 8352
	sw $t1, 0($t3)
	addi $t3, $t0, 8356
	sw $t1, 0($t3)
	addi $t3, $t0, 8360
	sw $t1, 0($t3)
	addi $t3, $t0, 8372
	sw $t1, 0($t3)
	addi $t3, $t0, 8376
	sw $t1, 0($t3)
	addi $t3, $t0, 8380
	sw $t1, 0($t3)
	addi $t3, $t0, 8384
	sw $t1, 0($t3)
	addi $t3, $t0, 8512
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8516
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8520
	sw $t1, 0($t3)
	addi $t3, $t0, 8524
	sw $t1, 0($t3)
	addi $t3, $t0, 8528
	sw $t1, 0($t3)
	addi $t3, $t0, 8532
	li $t1, 0xf59bb5
	sw $t1, 0($t3)
	addi $t3, $t0, 8536
	li $t1, 0xf49ab4
	sw $t1, 0($t3)
	addi $t3, $t0, 8540
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8544
	sw $t1, 0($t3)
	addi $t3, $t0, 8548
	sw $t1, 0($t3)
	addi $t3, $t0, 8560
	sw $t1, 0($t3)
	addi $t3, $t0, 8564
	sw $t1, 0($t3)
	addi $t3, $t0, 8568
	sw $t1, 0($t3)
	addi $t3, $t0, 8572
	sw $t1, 0($t3)
	addi $t3, $t0, 8584
	sw $t1, 0($t3)
	addi $t3, $t0, 8588
	sw $t1, 0($t3)
	addi $t3, $t0, 8608
	sw $t1, 0($t3)
	addi $t3, $t0, 8612
	sw $t1, 0($t3)
	addi $t3, $t0, 8616
	sw $t1, 0($t3)
	addi $t3, $t0, 8628
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8632
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8636
	sw $t1, 0($t3)
	addi $t3, $t0, 8640
	sw $t1, 0($t3)
	addi $t3, $t0, 8772
	sw $t1, 0($t3)
	addi $t3, $t0, 8776
	sw $t1, 0($t3)
	addi $t3, $t0, 8780
	sw $t1, 0($t3)
	addi $t3, $t0, 8784
	li $t1, 0xfcc3d4
	sw $t1, 0($t3)
	addi $t3, $t0, 8796
	li $t1, 0xfad0de
	sw $t1, 0($t3)
	addi $t3, $t0, 8800
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8804
	li $t1, 0xf699b6
	sw $t1, 0($t3)
	addi $t3, $t0, 8816
	li $t1, 0xf8c5d4
	sw $t1, 0($t3)
	addi $t3, $t0, 8820
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8824
	sw $t1, 0($t3)
	addi $t3, $t0, 8828
	sw $t1, 0($t3)
	addi $t3, $t0, 8840
	li $t1, 0xf0a5bc
	sw $t1, 0($t3)
	addi $t3, $t0, 8844
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8864
	li $t1, 0xfefcfd
	sw $t1, 0($t3)
	addi $t3, $t0, 8868
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8872
	li $t1, 0xfcdbe6
	sw $t1, 0($t3)
	addi $t3, $t0, 8888
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8892
	sw $t1, 0($t3)
	addi $t3, $t0, 8896
	li $t1, 0xfefcfd
	sw $t1, 0($t3)
	addi $t3, $t0, 10620
	li $t1, 0xff0003
	sw $t1, 0($t3)
	addi $t3, $t0, 10624
	sw $t1, 0($t3)
	addi $t3, $t0, 10632
	sw $t1, 0($t3)
	addi $t3, $t0, 10636
	li $t1, 0xc20235
	sw $t1, 0($t3)
	addi $t3, $t0, 10876
	li $t1, 0xff0003
	sw $t1, 0($t3)
	addi $t3, $t0, 10880
	sw $t1, 0($t3)
	addi $t3, $t0, 10884
	sw $t1, 0($t3)
	addi $t3, $t0, 10888
	sw $t1, 0($t3)
	addi $t3, $t0, 10892
	li $t1, 0xc20235
	sw $t1, 0($t3)
	addi $t3, $t0, 11136
	li $t1, 0xff0003
	sw $t1, 0($t3)
	addi $t3, $t0, 11140
	sw $t1, 0($t3)
	addi $t3, $t0, 11144
	li $t1, 0xc20235
	sw $t1, 0($t3)
	addi $t3, $t0, 11396
	sw $t1, 0($t3)
	addi $t3, $t0, 11668
	li $t1, 0xe4a449
	sw $t1, 0($t3)
	addi $t3, $t0, 11672
	sw $t1, 0($t3)
	addi $t3, $t0, 11924
	li $t1, 0xf3cd0e
	sw $t1, 0($t3)
	addi $t3, $t0, 11928
	sw $t1, 0($t3)
	addi $t3, $t0, 11932
	sw $t1, 0($t3)
	addi $t3, $t0, 12136
	li $t1, 0xf44336
	sw $t1, 0($t3)
	addi $t3, $t0, 12140
	sw $t1, 0($t3)
	addi $t3, $t0, 12144
	sw $t1, 0($t3)
	addi $t3, $t0, 12148
	sw $t1, 0($t3)
	addi $t3, $t0, 12176
	li $t1, 0xf3cd0e
	sw $t1, 0($t3)
	addi $t3, $t0, 12180
	li $t1, 0xffebb4
	sw $t1, 0($t3)
	addi $t3, $t0, 12184
	sw $t1, 0($t3)
	addi $t3, $t0, 12188
	li $t1, 0xf3cd0e
	sw $t1, 0($t3)
	addi $t3, $t0, 12192
	sw $t1, 0($t3)
	addi $t3, $t0, 12392
	li $t1, 0xffcc80
	sw $t1, 0($t3)
	addi $t3, $t0, 12396
	li $t1, 0x795548
	sw $t1, 0($t3)
	addi $t3, $t0, 12400
	li $t1, 0xffcc80
	sw $t1, 0($t3)
	addi $t3, $t0, 12404
	sw $t1, 0($t3)
	addi $t3, $t0, 12408
	sw $t1, 0($t3)
	addi $t3, $t0, 12436
	li $t1, 0xffebb4
	sw $t1, 0($t3)
	addi $t3, $t0, 12440
	sw $t1, 0($t3)
	addi $t3, $t0, 12444
	li $t1, 0xf3cd0e
	sw $t1, 0($t3)
	addi $t3, $t0, 12652
	li $t1, 0xffcc80
	sw $t1, 0($t3)
	addi $t3, $t0, 12656
	sw $t1, 0($t3)
	addi $t3, $t0, 12660
	sw $t1, 0($t3)
	addi $t3, $t0, 12688
	li $t1, 0xff80ab
	sw $t1, 0($t3)
	addi $t3, $t0, 12692
	sw $t1, 0($t3)
	addi $t3, $t0, 12696
	sw $t1, 0($t3)
	addi $t3, $t0, 12700
	sw $t1, 0($t3)
	addi $t3, $t0, 12704
	li $t1, 0xf3cd0e
	sw $t1, 0($t3)
	addi $t3, $t0, 12900
	li $t1, 0xf44336
	sw $t1, 0($t3)
	addi $t3, $t0, 12904
	sw $t1, 0($t3)
	addi $t3, $t0, 12908
	li $t1, 0x304ffe
	sw $t1, 0($t3)
	addi $t3, $t0, 12912
	li $t1, 0xf44336
	sw $t1, 0($t3)
	addi $t3, $t0, 12916
	sw $t1, 0($t3)
	addi $t3, $t0, 12944
	li $t1, 0xffffff
	sw $t1, 0($t3)
	addi $t3, $t0, 12948
	li $t1, 0xec407a
	sw $t1, 0($t3)
	addi $t3, $t0, 12952
	sw $t1, 0($t3)
	addi $t3, $t0, 12956
	li $t1, 0xffffff
	sw $t1, 0($t3)
	addi $t3, $t0, 13156
	sw $t1, 0($t3)
	addi $t3, $t0, 13160
	li $t1, 0x304ffe
	sw $t1, 0($t3)
	addi $t3, $t0, 13164
	sw $t1, 0($t3)
	addi $t3, $t0, 13168
	sw $t1, 0($t3)
	addi $t3, $t0, 13172
	li $t1, 0xffffff
	sw $t1, 0($t3)
	addi $t3, $t0, 13200
	li $t1, 0xec407a
	sw $t1, 0($t3)
	addi $t3, $t0, 13204
	li $t1, 0xff80ab
	sw $t1, 0($t3)
	addi $t3, $t0, 13208
	sw $t1, 0($t3)
	addi $t3, $t0, 13212
	li $t1, 0xec407a
	sw $t1, 0($t3)
	addi $t3, $t0, 13416
	li $t1, 0x304ffe
	sw $t1, 0($t3)
	addi $t3, $t0, 13424
	sw $t1, 0($t3)
	addi $t3, $t0, 13456
	li $t1, 0xec407a
	sw $t1, 0($t3)
	addi $t3, $t0, 13460
	sw $t1, 0($t3)
	addi $t3, $t0, 13464
	sw $t1, 0($t3)
	addi $t3, $t0, 13468
	sw $t1, 0($t3)
	addi $t3, $t0, 13472
	sw $t1, 0($t3)
	addi $t0, $zero, BASE_ADDRESS
	addi $t3, $t0, 2632
	li $t1, 0xf99cb7
	sw $t1, 0($t3)
	addi $t3, $t0, 2636
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2640
	li $t1, 0xffebf3
	sw $t1, 0($t3)
	addi $t3, $t0, 2648
	li $t1, 0xfed4e0
	sw $t1, 0($t3)
	addi $t3, $t0, 2652
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2656
	sw $t1, 0($t3)
	addi $t3, $t0, 2660
	li $t1, 0xffe5ee
	sw $t1, 0($t3)
	addi $t3, $t0, 2672
	li $t1, 0xffeaf3
	sw $t1, 0($t3)
	addi $t3, $t0, 2676
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2680
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2684
	sw $t1, 0($t3)
	addi $t3, $t0, 2688
	sw $t1, 0($t3)
	addi $t3, $t0, 2692
	sw $t1, 0($t3)
	addi $t3, $t0, 2696
	sw $t1, 0($t3)
	addi $t3, $t0, 2700
	li $t1, 0xf9d8e1
	sw $t1, 0($t3)
	addi $t3, $t0, 2720
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2724
	sw $t1, 0($t3)
	addi $t3, $t0, 2728
	li $t1, 0xfad6e0
	sw $t1, 0($t3)
	addi $t3, $t0, 2736
	li $t1, 0xffd3e5
	sw $t1, 0($t3)
	addi $t3, $t0, 2740
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2744
	li $t1, 0xfc94b5
	sw $t1, 0($t3)
	addi $t3, $t0, 2884
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2888
	sw $t1, 0($t3)
	addi $t3, $t0, 2892
	sw $t1, 0($t3)
	addi $t3, $t0, 2896
	sw $t1, 0($t3)
	addi $t3, $t0, 2900
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2904
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2908
	sw $t1, 0($t3)
	addi $t3, $t0, 2912
	sw $t1, 0($t3)
	addi $t3, $t0, 2916
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2924
	sw $t1, 0($t3)
	addi $t3, $t0, 2928
	li $t1, 0xffe4f0
	sw $t1, 0($t3)
	addi $t3, $t0, 2932
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2936
	sw $t1, 0($t3)
	addi $t3, $t0, 2940
	sw $t1, 0($t3)
	addi $t3, $t0, 2944
	sw $t1, 0($t3)
	addi $t3, $t0, 2948
	sw $t1, 0($t3)
	addi $t3, $t0, 2952
	sw $t1, 0($t3)
	addi $t3, $t0, 2956
	sw $t1, 0($t3)
	addi $t3, $t0, 2968
	li $t1, 0xf897b6
	sw $t1, 0($t3)
	addi $t3, $t0, 2972
	li $t1, 0xf2adc2
	sw $t1, 0($t3)
	addi $t3, $t0, 2976
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2980
	sw $t1, 0($t3)
	addi $t3, $t0, 2984
	sw $t1, 0($t3)
	addi $t3, $t0, 2992
	sw $t1, 0($t3)
	addi $t3, $t0, 2996
	sw $t1, 0($t3)
	addi $t3, $t0, 3000
	sw $t1, 0($t3)
	addi $t3, $t0, 3140
	sw $t1, 0($t3)
	addi $t3, $t0, 3144
	sw $t1, 0($t3)
	addi $t3, $t0, 3148
	sw $t1, 0($t3)
	addi $t3, $t0, 3152
	sw $t1, 0($t3)
	addi $t3, $t0, 3156
	sw $t1, 0($t3)
	addi $t3, $t0, 3160
	sw $t1, 0($t3)
	addi $t3, $t0, 3164
	sw $t1, 0($t3)
	addi $t3, $t0, 3168
	sw $t1, 0($t3)
	addi $t3, $t0, 3172
	li $t1, 0xf399b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3180
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3184
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3188
	sw $t1, 0($t3)
	addi $t3, $t0, 3192
	sw $t1, 0($t3)
	addi $t3, $t0, 3196
	sw $t1, 0($t3)
	addi $t3, $t0, 3208
	sw $t1, 0($t3)
	addi $t3, $t0, 3212
	sw $t1, 0($t3)
	addi $t3, $t0, 3224
	sw $t1, 0($t3)
	addi $t3, $t0, 3228
	sw $t1, 0($t3)
	addi $t3, $t0, 3232
	sw $t1, 0($t3)
	addi $t3, $t0, 3236
	sw $t1, 0($t3)
	addi $t3, $t0, 3240
	sw $t1, 0($t3)
	addi $t3, $t0, 3248
	sw $t1, 0($t3)
	addi $t3, $t0, 3252
	sw $t1, 0($t3)
	addi $t3, $t0, 3256
	sw $t1, 0($t3)
	addi $t3, $t0, 3400
	li $t1, 0xf898b4
	sw $t1, 0($t3)
	addi $t3, $t0, 3404
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3408
	sw $t1, 0($t3)
	addi $t3, $t0, 3412
	sw $t1, 0($t3)
	addi $t3, $t0, 3416
	sw $t1, 0($t3)
	addi $t3, $t0, 3420
	sw $t1, 0($t3)
	addi $t3, $t0, 3436
	sw $t1, 0($t3)
	addi $t3, $t0, 3440
	sw $t1, 0($t3)
	addi $t3, $t0, 3444
	sw $t1, 0($t3)
	addi $t3, $t0, 3448
	sw $t1, 0($t3)
	addi $t3, $t0, 3452
	sw $t1, 0($t3)
	addi $t3, $t0, 3464
	sw $t1, 0($t3)
	addi $t3, $t0, 3468
	sw $t1, 0($t3)
	addi $t3, $t0, 3480
	sw $t1, 0($t3)
	addi $t3, $t0, 3484
	sw $t1, 0($t3)
	addi $t3, $t0, 3488
	sw $t1, 0($t3)
	addi $t3, $t0, 3492
	sw $t1, 0($t3)
	addi $t3, $t0, 3496
	sw $t1, 0($t3)
	addi $t3, $t0, 3504
	sw $t1, 0($t3)
	addi $t3, $t0, 3508
	sw $t1, 0($t3)
	addi $t3, $t0, 3512
	sw $t1, 0($t3)
	addi $t3, $t0, 3660
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3664
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3668
	sw $t1, 0($t3)
	addi $t3, $t0, 3672
	sw $t1, 0($t3)
	addi $t3, $t0, 3676
	li $t1, 0xffd7e3
	sw $t1, 0($t3)
	addi $t3, $t0, 3692
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3696
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3700
	sw $t1, 0($t3)
	addi $t3, $t0, 3704
	sw $t1, 0($t3)
	addi $t3, $t0, 3708
	sw $t1, 0($t3)
	addi $t3, $t0, 3720
	sw $t1, 0($t3)
	addi $t3, $t0, 3724
	sw $t1, 0($t3)
	addi $t3, $t0, 3736
	sw $t1, 0($t3)
	addi $t3, $t0, 3740
	sw $t1, 0($t3)
	addi $t3, $t0, 3744
	sw $t1, 0($t3)
	addi $t3, $t0, 3748
	sw $t1, 0($t3)
	addi $t3, $t0, 3752
	sw $t1, 0($t3)
	addi $t3, $t0, 3760
	sw $t1, 0($t3)
	addi $t3, $t0, 3764
	sw $t1, 0($t3)
	addi $t3, $t0, 3768
	sw $t1, 0($t3)
	addi $t3, $t0, 3916
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3920
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3924
	sw $t1, 0($t3)
	addi $t3, $t0, 3928
	sw $t1, 0($t3)
	addi $t3, $t0, 3932
	li $t1, 0xfbdae3
	sw $t1, 0($t3)
	addi $t3, $t0, 3948
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3952
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3956
	sw $t1, 0($t3)
	addi $t3, $t0, 3960
	sw $t1, 0($t3)
	addi $t3, $t0, 3964
	sw $t1, 0($t3)
	addi $t3, $t0, 3976
	sw $t1, 0($t3)
	addi $t3, $t0, 3980
	sw $t1, 0($t3)
	addi $t3, $t0, 3992
	sw $t1, 0($t3)
	addi $t3, $t0, 3996
	sw $t1, 0($t3)
	addi $t3, $t0, 4000
	sw $t1, 0($t3)
	addi $t3, $t0, 4004
	sw $t1, 0($t3)
	addi $t3, $t0, 4008
	sw $t1, 0($t3)
	addi $t3, $t0, 4016
	sw $t1, 0($t3)
	addi $t3, $t0, 4020
	sw $t1, 0($t3)
	addi $t3, $t0, 4024
	sw $t1, 0($t3)
	addi $t3, $t0, 4172
	sw $t1, 0($t3)
	addi $t3, $t0, 4176
	sw $t1, 0($t3)
	addi $t3, $t0, 4180
	sw $t1, 0($t3)
	addi $t3, $t0, 4184
	sw $t1, 0($t3)
	addi $t3, $t0, 4188
	li $t1, 0xfbdae3
	sw $t1, 0($t3)
	addi $t3, $t0, 4204
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4208
	sw $t1, 0($t3)
	addi $t3, $t0, 4212
	sw $t1, 0($t3)
	addi $t3, $t0, 4216
	sw $t1, 0($t3)
	addi $t3, $t0, 4220
	sw $t1, 0($t3)
	addi $t3, $t0, 4232
	sw $t1, 0($t3)
	addi $t3, $t0, 4236
	sw $t1, 0($t3)
	addi $t3, $t0, 4248
	sw $t1, 0($t3)
	addi $t3, $t0, 4252
	sw $t1, 0($t3)
	addi $t3, $t0, 4256
	sw $t1, 0($t3)
	addi $t3, $t0, 4260
	sw $t1, 0($t3)
	addi $t3, $t0, 4264
	sw $t1, 0($t3)
	addi $t3, $t0, 4272
	sw $t1, 0($t3)
	addi $t3, $t0, 4276
	sw $t1, 0($t3)
	addi $t3, $t0, 4280
	sw $t1, 0($t3)
	addi $t3, $t0, 4428
	sw $t1, 0($t3)
	addi $t3, $t0, 4432
	sw $t1, 0($t3)
	addi $t3, $t0, 4436
	sw $t1, 0($t3)
	addi $t3, $t0, 4440
	sw $t1, 0($t3)
	addi $t3, $t0, 4444
	li $t1, 0xffe9f2
	sw $t1, 0($t3)
	addi $t3, $t0, 4460
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4464
	sw $t1, 0($t3)
	addi $t3, $t0, 4468
	sw $t1, 0($t3)
	addi $t3, $t0, 4472
	sw $t1, 0($t3)
	addi $t3, $t0, 4476
	sw $t1, 0($t3)
	addi $t3, $t0, 4480
	sw $t1, 0($t3)
	addi $t3, $t0, 4484
	sw $t1, 0($t3)
	addi $t3, $t0, 4488
	sw $t1, 0($t3)
	addi $t3, $t0, 4492
	sw $t1, 0($t3)
	addi $t3, $t0, 4504
	sw $t1, 0($t3)
	addi $t3, $t0, 4508
	sw $t1, 0($t3)
	addi $t3, $t0, 4512
	sw $t1, 0($t3)
	addi $t3, $t0, 4516
	sw $t1, 0($t3)
	addi $t3, $t0, 4520
	sw $t1, 0($t3)
	addi $t3, $t0, 4524
	sw $t1, 0($t3)
	addi $t3, $t0, 4528
	sw $t1, 0($t3)
	addi $t3, $t0, 4532
	sw $t1, 0($t3)
	addi $t3, $t0, 4536
	sw $t1, 0($t3)
	addi $t3, $t0, 4684
	sw $t1, 0($t3)
	addi $t3, $t0, 4688
	sw $t1, 0($t3)
	addi $t3, $t0, 4692
	sw $t1, 0($t3)
	addi $t3, $t0, 4696
	sw $t1, 0($t3)
	addi $t3, $t0, 4700
	li $t1, 0xffe9f2
	sw $t1, 0($t3)
	addi $t3, $t0, 4716
	li $t1, 0xf59bb5
	sw $t1, 0($t3)
	addi $t3, $t0, 4720
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4724
	sw $t1, 0($t3)
	addi $t3, $t0, 4728
	sw $t1, 0($t3)
	addi $t3, $t0, 4732
	sw $t1, 0($t3)
	addi $t3, $t0, 4736
	sw $t1, 0($t3)
	addi $t3, $t0, 4740
	sw $t1, 0($t3)
	addi $t3, $t0, 4744
	sw $t1, 0($t3)
	addi $t3, $t0, 4748
	sw $t1, 0($t3)
	addi $t3, $t0, 4760
	li $t1, 0xf79ab5
	sw $t1, 0($t3)
	addi $t3, $t0, 4764
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4768
	sw $t1, 0($t3)
	addi $t3, $t0, 4772
	sw $t1, 0($t3)
	addi $t3, $t0, 4776
	sw $t1, 0($t3)
	addi $t3, $t0, 4780
	sw $t1, 0($t3)
	addi $t3, $t0, 4784
	sw $t1, 0($t3)
	addi $t3, $t0, 4788
	sw $t1, 0($t3)
	addi $t3, $t0, 4792
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4940
	li $t1, 0xfefcfd
	sw $t1, 0($t3)
	addi $t3, $t0, 4944
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4948
	sw $t1, 0($t3)
	addi $t3, $t0, 4952
	li $t1, 0xf796b5
	sw $t1, 0($t3)
	addi $t3, $t0, 4976
	li $t1, 0xffe2ef
	sw $t1, 0($t3)
	addi $t3, $t0, 4980
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4984
	sw $t1, 0($t3)
	addi $t3, $t0, 4988
	sw $t1, 0($t3)
	addi $t3, $t0, 4992
	sw $t1, 0($t3)
	addi $t3, $t0, 4996
	sw $t1, 0($t3)
	addi $t3, $t0, 5000
	sw $t1, 0($t3)
	addi $t3, $t0, 5020
	li $t1, 0xf4acc2
	sw $t1, 0($t3)
	addi $t3, $t0, 5024
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 5028
	sw $t1, 0($t3)
	addi $t3, $t0, 5032
	sw $t1, 0($t3)
	addi $t3, $t0, 5036
	sw $t1, 0($t3)
	addi $t3, $t0, 5040
	sw $t1, 0($t3)
	addi $t3, $t0, 5044
	sw $t1, 0($t3)
	addi $t3, $t0, 6464
	li $t1, 0xffe5ee
	sw $t1, 0($t3)
	addi $t3, $t0, 6468
	li $t1, 0xffe4ee
	sw $t1, 0($t3)
	addi $t3, $t0, 6472
	li $t1, 0xf898b4
	sw $t1, 0($t3)
	addi $t3, $t0, 6492
	li $t1, 0xffc2d5
	sw $t1, 0($t3)
	addi $t3, $t0, 6496
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6500
	li $t1, 0xf897b6
	sw $t1, 0($t3)
	addi $t3, $t0, 6512
	li $t1, 0xf8c5d4
	sw $t1, 0($t3)
	addi $t3, $t0, 6520
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6524
	sw $t1, 0($t3)
	addi $t3, $t0, 6536
	li $t1, 0xf2b5c7
	sw $t1, 0($t3)
	addi $t3, $t0, 6540
	li $t1, 0xffe4ee
	sw $t1, 0($t3)
	addi $t3, $t0, 6544
	sw $t1, 0($t3)
	addi $t3, $t0, 6564
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6568
	li $t1, 0xffcadb
	sw $t1, 0($t3)
	addi $t3, $t0, 6584
	li $t1, 0xf9abc1
	sw $t1, 0($t3)
	addi $t3, $t0, 6588
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6592
	sw $t1, 0($t3)
	addi $t3, $t0, 6720
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6724
	li $t1, 0xffc2d5
	sw $t1, 0($t3)
	addi $t3, $t0, 6728
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6748
	sw $t1, 0($t3)
	addi $t3, $t0, 6752
	sw $t1, 0($t3)
	addi $t3, $t0, 6756
	sw $t1, 0($t3)
	addi $t3, $t0, 6768
	li $t1, 0xfcc3d4
	sw $t1, 0($t3)
	addi $t3, $t0, 6772
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6776
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6780
	sw $t1, 0($t3)
	addi $t3, $t0, 6792
	li $t1, 0xffecf7
	sw $t1, 0($t3)
	addi $t3, $t0, 6796
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6800
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6820
	sw $t1, 0($t3)
	addi $t3, $t0, 6824
	sw $t1, 0($t3)
	addi $t3, $t0, 6840
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6844
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6848
	sw $t1, 0($t3)
	addi $t3, $t0, 6976
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6980
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6984
	sw $t1, 0($t3)
	addi $t3, $t0, 6992
	li $t1, 0xffe4ee
	sw $t1, 0($t3)
	addi $t3, $t0, 6996
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7004
	sw $t1, 0($t3)
	addi $t3, $t0, 7008
	sw $t1, 0($t3)
	addi $t3, $t0, 7012
	sw $t1, 0($t3)
	addi $t3, $t0, 7024
	sw $t1, 0($t3)
	addi $t3, $t0, 7028
	sw $t1, 0($t3)
	addi $t3, $t0, 7032
	sw $t1, 0($t3)
	addi $t3, $t0, 7036
	sw $t1, 0($t3)
	addi $t3, $t0, 7048
	sw $t1, 0($t3)
	addi $t3, $t0, 7052
	sw $t1, 0($t3)
	addi $t3, $t0, 7056
	sw $t1, 0($t3)
	addi $t3, $t0, 7076
	sw $t1, 0($t3)
	addi $t3, $t0, 7080
	sw $t1, 0($t3)
	addi $t3, $t0, 7092
	sw $t1, 0($t3)
	addi $t3, $t0, 7096
	sw $t1, 0($t3)
	addi $t3, $t0, 7100
	sw $t1, 0($t3)
	addi $t3, $t0, 7104
	sw $t1, 0($t3)
	addi $t3, $t0, 7232
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7236
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7240
	sw $t1, 0($t3)
	addi $t3, $t0, 7248
	sw $t1, 0($t3)
	addi $t3, $t0, 7252
	sw $t1, 0($t3)
	addi $t3, $t0, 7260
	sw $t1, 0($t3)
	addi $t3, $t0, 7264
	sw $t1, 0($t3)
	addi $t3, $t0, 7268
	sw $t1, 0($t3)
	addi $t3, $t0, 7280
	sw $t1, 0($t3)
	addi $t3, $t0, 7284
	sw $t1, 0($t3)
	addi $t3, $t0, 7288
	sw $t1, 0($t3)
	addi $t3, $t0, 7292
	sw $t1, 0($t3)
	addi $t3, $t0, 7304
	sw $t1, 0($t3)
	addi $t3, $t0, 7308
	sw $t1, 0($t3)
	addi $t3, $t0, 7312
	sw $t1, 0($t3)
	addi $t3, $t0, 7316
	sw $t1, 0($t3)
	addi $t3, $t0, 7332
	sw $t1, 0($t3)
	addi $t3, $t0, 7336
	sw $t1, 0($t3)
	addi $t3, $t0, 7348
	sw $t1, 0($t3)
	addi $t3, $t0, 7352
	sw $t1, 0($t3)
	addi $t3, $t0, 7356
	sw $t1, 0($t3)
	addi $t3, $t0, 7360
	sw $t1, 0($t3)
	addi $t3, $t0, 7488
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7492
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7496
	sw $t1, 0($t3)
	addi $t3, $t0, 7500
	sw $t1, 0($t3)
	addi $t3, $t0, 7504
	sw $t1, 0($t3)
	addi $t3, $t0, 7508
	li $t1, 0xf898b4
	sw $t1, 0($t3)
	addi $t3, $t0, 7512
	li $t1, 0xf799b4
	sw $t1, 0($t3)
	addi $t3, $t0, 7516
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7520
	sw $t1, 0($t3)
	addi $t3, $t0, 7524
	sw $t1, 0($t3)
	addi $t3, $t0, 7536
	sw $t1, 0($t3)
	addi $t3, $t0, 7540
	sw $t1, 0($t3)
	addi $t3, $t0, 7544
	sw $t1, 0($t3)
	addi $t3, $t0, 7548
	sw $t1, 0($t3)
	addi $t3, $t0, 7560
	sw $t1, 0($t3)
	addi $t3, $t0, 7564
	sw $t1, 0($t3)
	addi $t3, $t0, 7568
	sw $t1, 0($t3)
	addi $t3, $t0, 7572
	sw $t1, 0($t3)
	addi $t3, $t0, 7576
	sw $t1, 0($t3)
	addi $t3, $t0, 7584
	sw $t1, 0($t3)
	addi $t3, $t0, 7588
	sw $t1, 0($t3)
	addi $t3, $t0, 7592
	sw $t1, 0($t3)
	addi $t3, $t0, 7604
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7608
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7612
	sw $t1, 0($t3)
	addi $t3, $t0, 7616
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7744
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7748
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7752
	sw $t1, 0($t3)
	addi $t3, $t0, 7756
	sw $t1, 0($t3)
	addi $t3, $t0, 7760
	sw $t1, 0($t3)
	addi $t3, $t0, 7764
	sw $t1, 0($t3)
	addi $t3, $t0, 7768
	sw $t1, 0($t3)
	addi $t3, $t0, 7772
	sw $t1, 0($t3)
	addi $t3, $t0, 7776
	sw $t1, 0($t3)
	addi $t3, $t0, 7780
	sw $t1, 0($t3)
	addi $t3, $t0, 7792
	sw $t1, 0($t3)
	addi $t3, $t0, 7796
	sw $t1, 0($t3)
	addi $t3, $t0, 7800
	sw $t1, 0($t3)
	addi $t3, $t0, 7804
	sw $t1, 0($t3)
	addi $t3, $t0, 7816
	sw $t1, 0($t3)
	addi $t3, $t0, 7820
	sw $t1, 0($t3)
	addi $t3, $t0, 7824
	sw $t1, 0($t3)
	addi $t3, $t0, 7828
	sw $t1, 0($t3)
	addi $t3, $t0, 7832
	sw $t1, 0($t3)
	addi $t3, $t0, 7836
	sw $t1, 0($t3)
	addi $t3, $t0, 7840
	sw $t1, 0($t3)
	addi $t3, $t0, 7844
	sw $t1, 0($t3)
	addi $t3, $t0, 7848
	sw $t1, 0($t3)
	addi $t3, $t0, 7864
	li $t1, 0xfa95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7868
	sw $t1, 0($t3)
	addi $t3, $t0, 8000
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8004
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8008
	sw $t1, 0($t3)
	addi $t3, $t0, 8012
	sw $t1, 0($t3)
	addi $t3, $t0, 8016
	sw $t1, 0($t3)
	addi $t3, $t0, 8020
	sw $t1, 0($t3)
	addi $t3, $t0, 8024
	sw $t1, 0($t3)
	addi $t3, $t0, 8028
	sw $t1, 0($t3)
	addi $t3, $t0, 8032
	sw $t1, 0($t3)
	addi $t3, $t0, 8036
	sw $t1, 0($t3)
	addi $t3, $t0, 8048
	sw $t1, 0($t3)
	addi $t3, $t0, 8052
	sw $t1, 0($t3)
	addi $t3, $t0, 8056
	sw $t1, 0($t3)
	addi $t3, $t0, 8060
	sw $t1, 0($t3)
	addi $t3, $t0, 8072
	sw $t1, 0($t3)
	addi $t3, $t0, 8076
	sw $t1, 0($t3)
	addi $t3, $t0, 8080
	sw $t1, 0($t3)
	addi $t3, $t0, 8084
	sw $t1, 0($t3)
	addi $t3, $t0, 8088
	sw $t1, 0($t3)
	addi $t3, $t0, 8092
	sw $t1, 0($t3)
	addi $t3, $t0, 8096
	sw $t1, 0($t3)
	addi $t3, $t0, 8100
	sw $t1, 0($t3)
	addi $t3, $t0, 8104
	sw $t1, 0($t3)
	addi $t3, $t0, 8120
	li $t1, 0xeeb8c8
	sw $t1, 0($t3)
	addi $t3, $t0, 8124
	sw $t1, 0($t3)
	addi $t3, $t0, 8256
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8260
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8264
	sw $t1, 0($t3)
	addi $t3, $t0, 8268
	sw $t1, 0($t3)
	addi $t3, $t0, 8272
	sw $t1, 0($t3)
	addi $t3, $t0, 8276
	sw $t1, 0($t3)
	addi $t3, $t0, 8280
	sw $t1, 0($t3)
	addi $t3, $t0, 8284
	sw $t1, 0($t3)
	addi $t3, $t0, 8288
	sw $t1, 0($t3)
	addi $t3, $t0, 8292
	sw $t1, 0($t3)
	addi $t3, $t0, 8304
	sw $t1, 0($t3)
	addi $t3, $t0, 8308
	sw $t1, 0($t3)
	addi $t3, $t0, 8312
	sw $t1, 0($t3)
	addi $t3, $t0, 8316
	sw $t1, 0($t3)
	addi $t3, $t0, 8328
	sw $t1, 0($t3)
	addi $t3, $t0, 8332
	sw $t1, 0($t3)
	addi $t3, $t0, 8336
	sw $t1, 0($t3)
	addi $t3, $t0, 8348
	sw $t1, 0($t3)
	addi $t3, $t0, 8352
	sw $t1, 0($t3)
	addi $t3, $t0, 8356
	sw $t1, 0($t3)
	addi $t3, $t0, 8360
	sw $t1, 0($t3)
	addi $t3, $t0, 8372
	sw $t1, 0($t3)
	addi $t3, $t0, 8376
	sw $t1, 0($t3)
	addi $t3, $t0, 8380
	sw $t1, 0($t3)
	addi $t3, $t0, 8384
	sw $t1, 0($t3)
	addi $t3, $t0, 8512
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8516
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8520
	sw $t1, 0($t3)
	addi $t3, $t0, 8524
	sw $t1, 0($t3)
	addi $t3, $t0, 8528
	sw $t1, 0($t3)
	addi $t3, $t0, 8532
	li $t1, 0xf59bb5
	sw $t1, 0($t3)
	addi $t3, $t0, 8536
	li $t1, 0xf49ab4
	sw $t1, 0($t3)
	addi $t3, $t0, 8540
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8544
	sw $t1, 0($t3)
	addi $t3, $t0, 8548
	sw $t1, 0($t3)
	addi $t3, $t0, 8560
	sw $t1, 0($t3)
	addi $t3, $t0, 8564
	sw $t1, 0($t3)
	addi $t3, $t0, 8568
	sw $t1, 0($t3)
	addi $t3, $t0, 8572
	sw $t1, 0($t3)
	addi $t3, $t0, 8584
	sw $t1, 0($t3)
	addi $t3, $t0, 8588
	sw $t1, 0($t3)
	addi $t3, $t0, 8608
	sw $t1, 0($t3)
	addi $t3, $t0, 8612
	sw $t1, 0($t3)
	addi $t3, $t0, 8616
	sw $t1, 0($t3)
	addi $t3, $t0, 8628
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8632
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8636
	sw $t1, 0($t3)
	addi $t3, $t0, 8640
	sw $t1, 0($t3)
	addi $t3, $t0, 8772
	sw $t1, 0($t3)
	addi $t3, $t0, 8776
	sw $t1, 0($t3)
	addi $t3, $t0, 8780
	sw $t1, 0($t3)
	addi $t3, $t0, 8784
	li $t1, 0xfcc3d4
	sw $t1, 0($t3)
	addi $t3, $t0, 8796
	li $t1, 0xfad0de
	sw $t1, 0($t3)
	addi $t3, $t0, 8800
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8804
	li $t1, 0xf699b6
	sw $t1, 0($t3)
	addi $t3, $t0, 8816
	li $t1, 0xf8c5d4
	sw $t1, 0($t3)
	addi $t3, $t0, 8820
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8824
	sw $t1, 0($t3)
	addi $t3, $t0, 8828
	sw $t1, 0($t3)
	addi $t3, $t0, 8840
	li $t1, 0xf0a5bc
	sw $t1, 0($t3)
	addi $t3, $t0, 8844
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8864
	li $t1, 0xfefcfd
	sw $t1, 0($t3)
	addi $t3, $t0, 8868
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8872
	li $t1, 0xfcdbe6
	sw $t1, 0($t3)
	addi $t3, $t0, 8888
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8892
	sw $t1, 0($t3)
	addi $t3, $t0, 8896
	li $t1, 0xfefcfd
	sw $t1, 0($t3)
	addi $t3, $t0, 10620
	li $t1, 0xff0003
	sw $t1, 0($t3)
	addi $t3, $t0, 10624
	sw $t1, 0($t3)
	addi $t3, $t0, 10632
	sw $t1, 0($t3)
	addi $t3, $t0, 10636
	li $t1, 0xc20235
	sw $t1, 0($t3)
	addi $t3, $t0, 10876
	li $t1, 0xff0003
	sw $t1, 0($t3)
	addi $t3, $t0, 10880
	sw $t1, 0($t3)
	addi $t3, $t0, 10884
	sw $t1, 0($t3)
	addi $t3, $t0, 10888
	sw $t1, 0($t3)
	addi $t3, $t0, 10892
	li $t1, 0xc20235
	sw $t1, 0($t3)
	addi $t3, $t0, 11136
	li $t1, 0xff0003
	sw $t1, 0($t3)
	addi $t3, $t0, 11140
	sw $t1, 0($t3)
	addi $t3, $t0, 11144
	li $t1, 0xc20235
	sw $t1, 0($t3)
	addi $t3, $t0, 11396
	sw $t1, 0($t3)
	addi $t3, $t0, 11668
	li $t1, 0xe4a449
	sw $t1, 0($t3)
	addi $t3, $t0, 11672
	sw $t1, 0($t3)
	addi $t3, $t0, 11924
	li $t1, 0xf3cd0e
	sw $t1, 0($t3)
	addi $t3, $t0, 11928
	sw $t1, 0($t3)
	addi $t3, $t0, 11932
	sw $t1, 0($t3)
	addi $t3, $t0, 12136
	li $t1, 0xf44336
	sw $t1, 0($t3)
	addi $t3, $t0, 12140
	sw $t1, 0($t3)
	addi $t3, $t0, 12144
	sw $t1, 0($t3)
	addi $t3, $t0, 12148
	sw $t1, 0($t3)
	addi $t3, $t0, 12176
	li $t1, 0xf3cd0e
	sw $t1, 0($t3)
	addi $t3, $t0, 12180
	li $t1, 0xffebb4
	sw $t1, 0($t3)
	addi $t3, $t0, 12184
	sw $t1, 0($t3)
	addi $t3, $t0, 12188
	li $t1, 0xf3cd0e
	sw $t1, 0($t3)
	addi $t3, $t0, 12192
	sw $t1, 0($t3)
	addi $t3, $t0, 12392
	li $t1, 0xffcc80
	sw $t1, 0($t3)
	addi $t3, $t0, 12396
	li $t1, 0x795548
	sw $t1, 0($t3)
	addi $t3, $t0, 12400
	li $t1, 0xffcc80
	sw $t1, 0($t3)
	addi $t3, $t0, 12404
	sw $t1, 0($t3)
	addi $t3, $t0, 12408
	sw $t1, 0($t3)
	addi $t3, $t0, 12436
	li $t1, 0xffebb4
	sw $t1, 0($t3)
	addi $t3, $t0, 12440
	sw $t1, 0($t3)
	addi $t3, $t0, 12444
	li $t1, 0xf3cd0e
	sw $t1, 0($t3)
	addi $t3, $t0, 12652
	li $t1, 0xffcc80
	sw $t1, 0($t3)
	addi $t3, $t0, 12656
	sw $t1, 0($t3)
	addi $t3, $t0, 12660
	sw $t1, 0($t3)
	addi $t3, $t0, 12688
	li $t1, 0xff80ab
	sw $t1, 0($t3)
	addi $t3, $t0, 12692
	sw $t1, 0($t3)
	addi $t3, $t0, 12696
	sw $t1, 0($t3)
	addi $t3, $t0, 12700
	sw $t1, 0($t3)
	addi $t3, $t0, 12704
	li $t1, 0xf3cd0e
	sw $t1, 0($t3)
	addi $t3, $t0, 12900
	li $t1, 0xf44336
	sw $t1, 0($t3)
	addi $t3, $t0, 12904
	sw $t1, 0($t3)
	addi $t3, $t0, 12908
	li $t1, 0x304ffe
	sw $t1, 0($t3)
	addi $t3, $t0, 12912
	li $t1, 0xf44336
	sw $t1, 0($t3)
	addi $t3, $t0, 12916
	sw $t1, 0($t3)
	addi $t3, $t0, 12944
	li $t1, 0xffffff
	sw $t1, 0($t3)
	addi $t3, $t0, 12948
	li $t1, 0xec407a
	sw $t1, 0($t3)
	addi $t3, $t0, 12952
	sw $t1, 0($t3)
	addi $t3, $t0, 12956
	li $t1, 0xffffff
	sw $t1, 0($t3)
	addi $t3, $t0, 13156
	sw $t1, 0($t3)
	addi $t3, $t0, 13160
	li $t1, 0x304ffe
	sw $t1, 0($t3)
	addi $t3, $t0, 13164
	sw $t1, 0($t3)
	addi $t3, $t0, 13168
	sw $t1, 0($t3)
	addi $t3, $t0, 13172
	li $t1, 0xffffff
	sw $t1, 0($t3)
	addi $t3, $t0, 13200
	li $t1, 0xec407a
	sw $t1, 0($t3)
	addi $t3, $t0, 13204
	li $t1, 0xff80ab
	sw $t1, 0($t3)
	addi $t3, $t0, 13208
	sw $t1, 0($t3)
	addi $t3, $t0, 13212
	li $t1, 0xec407a
	sw $t1, 0($t3)
	addi $t3, $t0, 13416
	li $t1, 0x304ffe
	sw $t1, 0($t3)
	addi $t3, $t0, 13424
	sw $t1, 0($t3)
	addi $t3, $t0, 13456
	li $t1, 0xec407a
	sw $t1, 0($t3)
	addi $t3, $t0, 13460
	sw $t1, 0($t3)
	addi $t3, $t0, 13464
	sw $t1, 0($t3)
	addi $t3, $t0, 13468
	sw $t1, 0($t3)
	addi $t3, $t0, 13472
	sw $t1, 0($t3)
	addi $t0, $zero, BASE_ADDRESS
	addi $t3, $t0, 2632
	li $t1, 0xf99cb7
	sw $t1, 0($t3)
	addi $t3, $t0, 2636
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2640
	li $t1, 0xffebf3
	sw $t1, 0($t3)
	addi $t3, $t0, 2648
	li $t1, 0xfed4e0
	sw $t1, 0($t3)
	addi $t3, $t0, 2652
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2656
	sw $t1, 0($t3)
	addi $t3, $t0, 2660
	li $t1, 0xffe5ee
	sw $t1, 0($t3)
	addi $t3, $t0, 2672
	li $t1, 0xffeaf3
	sw $t1, 0($t3)
	addi $t3, $t0, 2676
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2680
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2684
	sw $t1, 0($t3)
	addi $t3, $t0, 2688
	sw $t1, 0($t3)
	addi $t3, $t0, 2692
	sw $t1, 0($t3)
	addi $t3, $t0, 2696
	sw $t1, 0($t3)
	addi $t3, $t0, 2700
	li $t1, 0xf9d8e1
	sw $t1, 0($t3)
	addi $t3, $t0, 2720
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2724
	sw $t1, 0($t3)
	addi $t3, $t0, 2728
	li $t1, 0xfad6e0
	sw $t1, 0($t3)
	addi $t3, $t0, 2736
	li $t1, 0xffd3e5
	sw $t1, 0($t3)
	addi $t3, $t0, 2740
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2744
	li $t1, 0xfc94b5
	sw $t1, 0($t3)
	addi $t3, $t0, 2884
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2888
	sw $t1, 0($t3)
	addi $t3, $t0, 2892
	sw $t1, 0($t3)
	addi $t3, $t0, 2896
	sw $t1, 0($t3)
	addi $t3, $t0, 2900
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2904
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2908
	sw $t1, 0($t3)
	addi $t3, $t0, 2912
	sw $t1, 0($t3)
	addi $t3, $t0, 2916
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2924
	sw $t1, 0($t3)
	addi $t3, $t0, 2928
	li $t1, 0xffe4f0
	sw $t1, 0($t3)
	addi $t3, $t0, 2932
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2936
	sw $t1, 0($t3)
	addi $t3, $t0, 2940
	sw $t1, 0($t3)
	addi $t3, $t0, 2944
	sw $t1, 0($t3)
	addi $t3, $t0, 2948
	sw $t1, 0($t3)
	addi $t3, $t0, 2952
	sw $t1, 0($t3)
	addi $t3, $t0, 2956
	sw $t1, 0($t3)
	addi $t3, $t0, 2968
	li $t1, 0xf897b6
	sw $t1, 0($t3)
	addi $t3, $t0, 2972
	li $t1, 0xf2adc2
	sw $t1, 0($t3)
	addi $t3, $t0, 2976
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2980
	sw $t1, 0($t3)
	addi $t3, $t0, 2984
	sw $t1, 0($t3)
	addi $t3, $t0, 2992
	sw $t1, 0($t3)
	addi $t3, $t0, 2996
	sw $t1, 0($t3)
	addi $t3, $t0, 3000
	sw $t1, 0($t3)
	addi $t3, $t0, 3140
	sw $t1, 0($t3)
	addi $t3, $t0, 3144
	sw $t1, 0($t3)
	addi $t3, $t0, 3148
	sw $t1, 0($t3)
	addi $t3, $t0, 3152
	sw $t1, 0($t3)
	addi $t3, $t0, 3156
	sw $t1, 0($t3)
	addi $t3, $t0, 3160
	sw $t1, 0($t3)
	addi $t3, $t0, 3164
	sw $t1, 0($t3)
	addi $t3, $t0, 3168
	sw $t1, 0($t3)
	addi $t3, $t0, 3172
	li $t1, 0xf399b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3180
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3184
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3188
	sw $t1, 0($t3)
	addi $t3, $t0, 3192
	sw $t1, 0($t3)
	addi $t3, $t0, 3196
	sw $t1, 0($t3)
	addi $t3, $t0, 3208
	sw $t1, 0($t3)
	addi $t3, $t0, 3212
	sw $t1, 0($t3)
	addi $t3, $t0, 3224
	sw $t1, 0($t3)
	addi $t3, $t0, 3228
	sw $t1, 0($t3)
	addi $t3, $t0, 3232
	sw $t1, 0($t3)
	addi $t3, $t0, 3236
	sw $t1, 0($t3)
	addi $t3, $t0, 3240
	sw $t1, 0($t3)
	addi $t3, $t0, 3248
	sw $t1, 0($t3)
	addi $t3, $t0, 3252
	sw $t1, 0($t3)
	addi $t3, $t0, 3256
	sw $t1, 0($t3)
	addi $t3, $t0, 3400
	li $t1, 0xf898b4
	sw $t1, 0($t3)
	addi $t3, $t0, 3404
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3408
	sw $t1, 0($t3)
	addi $t3, $t0, 3412
	sw $t1, 0($t3)
	addi $t3, $t0, 3416
	sw $t1, 0($t3)
	addi $t3, $t0, 3420
	sw $t1, 0($t3)
	addi $t3, $t0, 3436
	sw $t1, 0($t3)
	addi $t3, $t0, 3440
	sw $t1, 0($t3)
	addi $t3, $t0, 3444
	sw $t1, 0($t3)
	addi $t3, $t0, 3448
	sw $t1, 0($t3)
	addi $t3, $t0, 3452
	sw $t1, 0($t3)
	addi $t3, $t0, 3464
	sw $t1, 0($t3)
	addi $t3, $t0, 3468
	sw $t1, 0($t3)
	addi $t3, $t0, 3480
	sw $t1, 0($t3)
	addi $t3, $t0, 3484
	sw $t1, 0($t3)
	addi $t3, $t0, 3488
	sw $t1, 0($t3)
	addi $t3, $t0, 3492
	sw $t1, 0($t3)
	addi $t3, $t0, 3496
	sw $t1, 0($t3)
	addi $t3, $t0, 3504
	sw $t1, 0($t3)
	addi $t3, $t0, 3508
	sw $t1, 0($t3)
	addi $t3, $t0, 3512
	sw $t1, 0($t3)
	addi $t3, $t0, 3660
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3664
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3668
	sw $t1, 0($t3)
	addi $t3, $t0, 3672
	sw $t1, 0($t3)
	addi $t3, $t0, 3676
	li $t1, 0xffd7e3
	sw $t1, 0($t3)
	addi $t3, $t0, 3692
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3696
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3700
	sw $t1, 0($t3)
	addi $t3, $t0, 3704
	sw $t1, 0($t3)
	addi $t3, $t0, 3708
	sw $t1, 0($t3)
	addi $t3, $t0, 3720
	sw $t1, 0($t3)
	addi $t3, $t0, 3724
	sw $t1, 0($t3)
	addi $t3, $t0, 3736
	sw $t1, 0($t3)
	addi $t3, $t0, 3740
	sw $t1, 0($t3)
	addi $t3, $t0, 3744
	sw $t1, 0($t3)
	addi $t3, $t0, 3748
	sw $t1, 0($t3)
	addi $t3, $t0, 3752
	sw $t1, 0($t3)
	addi $t3, $t0, 3760
	sw $t1, 0($t3)
	addi $t3, $t0, 3764
	sw $t1, 0($t3)
	addi $t3, $t0, 3768
	sw $t1, 0($t3)
	addi $t3, $t0, 3916
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3920
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3924
	sw $t1, 0($t3)
	addi $t3, $t0, 3928
	sw $t1, 0($t3)
	addi $t3, $t0, 3932
	li $t1, 0xfbdae3
	sw $t1, 0($t3)
	addi $t3, $t0, 3948
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3952
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3956
	sw $t1, 0($t3)
	addi $t3, $t0, 3960
	sw $t1, 0($t3)
	addi $t3, $t0, 3964
	sw $t1, 0($t3)
	addi $t3, $t0, 3976
	sw $t1, 0($t3)
	addi $t3, $t0, 3980
	sw $t1, 0($t3)
	addi $t3, $t0, 3992
	sw $t1, 0($t3)
	addi $t3, $t0, 3996
	sw $t1, 0($t3)
	addi $t3, $t0, 4000
	sw $t1, 0($t3)
	addi $t3, $t0, 4004
	sw $t1, 0($t3)
	addi $t3, $t0, 4008
	sw $t1, 0($t3)
	addi $t3, $t0, 4016
	sw $t1, 0($t3)
	addi $t3, $t0, 4020
	sw $t1, 0($t3)
	addi $t3, $t0, 4024
	sw $t1, 0($t3)
	addi $t3, $t0, 4172
	sw $t1, 0($t3)
	addi $t3, $t0, 4176
	sw $t1, 0($t3)
	addi $t3, $t0, 4180
	sw $t1, 0($t3)
	addi $t3, $t0, 4184
	sw $t1, 0($t3)
	addi $t3, $t0, 4188
	li $t1, 0xfbdae3
	sw $t1, 0($t3)
	addi $t3, $t0, 4204
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4208
	sw $t1, 0($t3)
	addi $t3, $t0, 4212
	sw $t1, 0($t3)
	addi $t3, $t0, 4216
	sw $t1, 0($t3)
	addi $t3, $t0, 4220
	sw $t1, 0($t3)
	addi $t3, $t0, 4232
	sw $t1, 0($t3)
	addi $t3, $t0, 4236
	sw $t1, 0($t3)
	addi $t3, $t0, 4248
	sw $t1, 0($t3)
	addi $t3, $t0, 4252
	sw $t1, 0($t3)
	addi $t3, $t0, 4256
	sw $t1, 0($t3)
	addi $t3, $t0, 4260
	sw $t1, 0($t3)
	addi $t3, $t0, 4264
	sw $t1, 0($t3)
	addi $t3, $t0, 4272
	sw $t1, 0($t3)
	addi $t3, $t0, 4276
	sw $t1, 0($t3)
	addi $t3, $t0, 4280
	sw $t1, 0($t3)
	addi $t3, $t0, 4428
	sw $t1, 0($t3)
	addi $t3, $t0, 4432
	sw $t1, 0($t3)
	addi $t3, $t0, 4436
	sw $t1, 0($t3)
	addi $t3, $t0, 4440
	sw $t1, 0($t3)
	addi $t3, $t0, 4444
	li $t1, 0xffe9f2
	sw $t1, 0($t3)
	addi $t3, $t0, 4460
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4464
	sw $t1, 0($t3)
	addi $t3, $t0, 4468
	sw $t1, 0($t3)
	addi $t3, $t0, 4472
	sw $t1, 0($t3)
	addi $t3, $t0, 4476
	sw $t1, 0($t3)
	addi $t3, $t0, 4480
	sw $t1, 0($t3)
	addi $t3, $t0, 4484
	sw $t1, 0($t3)
	addi $t3, $t0, 4488
	sw $t1, 0($t3)
	addi $t3, $t0, 4492
	sw $t1, 0($t3)
	addi $t3, $t0, 4504
	sw $t1, 0($t3)
	addi $t3, $t0, 4508
	sw $t1, 0($t3)
	addi $t3, $t0, 4512
	sw $t1, 0($t3)
	addi $t3, $t0, 4516
	sw $t1, 0($t3)
	addi $t3, $t0, 4520
	sw $t1, 0($t3)
	addi $t3, $t0, 4524
	sw $t1, 0($t3)
	addi $t3, $t0, 4528
	sw $t1, 0($t3)
	addi $t3, $t0, 4532
	sw $t1, 0($t3)
	addi $t3, $t0, 4536
	sw $t1, 0($t3)
	addi $t3, $t0, 4684
	sw $t1, 0($t3)
	addi $t3, $t0, 4688
	sw $t1, 0($t3)
	addi $t3, $t0, 4692
	sw $t1, 0($t3)
	addi $t3, $t0, 4696
	sw $t1, 0($t3)
	addi $t3, $t0, 4700
	li $t1, 0xffe9f2
	sw $t1, 0($t3)
	addi $t3, $t0, 4716
	li $t1, 0xf59bb5
	sw $t1, 0($t3)
	addi $t3, $t0, 4720
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4724
	sw $t1, 0($t3)
	addi $t3, $t0, 4728
	sw $t1, 0($t3)
	addi $t3, $t0, 4732
	sw $t1, 0($t3)
	addi $t3, $t0, 4736
	sw $t1, 0($t3)
	addi $t3, $t0, 4740
	sw $t1, 0($t3)
	addi $t3, $t0, 4744
	sw $t1, 0($t3)
	addi $t3, $t0, 4748
	sw $t1, 0($t3)
	addi $t3, $t0, 4760
	li $t1, 0xf79ab5
	sw $t1, 0($t3)
	addi $t3, $t0, 4764
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4768
	sw $t1, 0($t3)
	addi $t3, $t0, 4772
	sw $t1, 0($t3)
	addi $t3, $t0, 4776
	sw $t1, 0($t3)
	addi $t3, $t0, 4780
	sw $t1, 0($t3)
	addi $t3, $t0, 4784
	sw $t1, 0($t3)
	addi $t3, $t0, 4788
	sw $t1, 0($t3)
	addi $t3, $t0, 4792
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4940
	li $t1, 0xfefcfd
	sw $t1, 0($t3)
	addi $t3, $t0, 4944
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4948
	sw $t1, 0($t3)
	addi $t3, $t0, 4952
	li $t1, 0xf796b5
	sw $t1, 0($t3)
	addi $t3, $t0, 4976
	li $t1, 0xffe2ef
	sw $t1, 0($t3)
	addi $t3, $t0, 4980
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4984
	sw $t1, 0($t3)
	addi $t3, $t0, 4988
	sw $t1, 0($t3)
	addi $t3, $t0, 4992
	sw $t1, 0($t3)
	addi $t3, $t0, 4996
	sw $t1, 0($t3)
	addi $t3, $t0, 5000
	sw $t1, 0($t3)
	addi $t3, $t0, 5020
	li $t1, 0xf4acc2
	sw $t1, 0($t3)
	addi $t3, $t0, 5024
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 5028
	sw $t1, 0($t3)
	addi $t3, $t0, 5032
	sw $t1, 0($t3)
	addi $t3, $t0, 5036
	sw $t1, 0($t3)
	addi $t3, $t0, 5040
	sw $t1, 0($t3)
	addi $t3, $t0, 5044
	sw $t1, 0($t3)
	addi $t3, $t0, 6464
	li $t1, 0xffe5ee
	sw $t1, 0($t3)
	addi $t3, $t0, 6468
	li $t1, 0xffe4ee
	sw $t1, 0($t3)
	addi $t3, $t0, 6472
	li $t1, 0xf898b4
	sw $t1, 0($t3)
	addi $t3, $t0, 6492
	li $t1, 0xffc2d5
	sw $t1, 0($t3)
	addi $t3, $t0, 6496
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6500
	li $t1, 0xf897b6
	sw $t1, 0($t3)
	addi $t3, $t0, 6512
	li $t1, 0xf8c5d4
	sw $t1, 0($t3)
	addi $t3, $t0, 6520
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6524
	sw $t1, 0($t3)
	addi $t3, $t0, 6536
	li $t1, 0xf2b5c7
	sw $t1, 0($t3)
	addi $t3, $t0, 6540
	li $t1, 0xffe4ee
	sw $t1, 0($t3)
	addi $t3, $t0, 6544
	sw $t1, 0($t3)
	addi $t3, $t0, 6564
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6568
	li $t1, 0xffcadb
	sw $t1, 0($t3)
	addi $t3, $t0, 6584
	li $t1, 0xf9abc1
	sw $t1, 0($t3)
	addi $t3, $t0, 6588
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6592
	sw $t1, 0($t3)
	addi $t3, $t0, 6720
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6724
	li $t1, 0xffc2d5
	sw $t1, 0($t3)
	addi $t3, $t0, 6728
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6748
	sw $t1, 0($t3)
	addi $t3, $t0, 6752
	sw $t1, 0($t3)
	addi $t3, $t0, 6756
	sw $t1, 0($t3)
	addi $t3, $t0, 6768
	li $t1, 0xfcc3d4
	sw $t1, 0($t3)
	addi $t3, $t0, 6772
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6776
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6780
	sw $t1, 0($t3)
	addi $t3, $t0, 6792
	li $t1, 0xffecf7
	sw $t1, 0($t3)
	addi $t3, $t0, 6796
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6800
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6820
	sw $t1, 0($t3)
	addi $t3, $t0, 6824
	sw $t1, 0($t3)
	addi $t3, $t0, 6840
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6844
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6848
	sw $t1, 0($t3)
	addi $t3, $t0, 6976
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6980
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6984
	sw $t1, 0($t3)
	addi $t3, $t0, 6992
	li $t1, 0xffe4ee
	sw $t1, 0($t3)
	addi $t3, $t0, 6996
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7004
	sw $t1, 0($t3)
	addi $t3, $t0, 7008
	sw $t1, 0($t3)
	addi $t3, $t0, 7012
	sw $t1, 0($t3)
	addi $t3, $t0, 7024
	sw $t1, 0($t3)
	addi $t3, $t0, 7028
	sw $t1, 0($t3)
	addi $t3, $t0, 7032
	sw $t1, 0($t3)
	addi $t3, $t0, 7036
	sw $t1, 0($t3)
	addi $t3, $t0, 7048
	sw $t1, 0($t3)
	addi $t3, $t0, 7052
	sw $t1, 0($t3)
	addi $t3, $t0, 7056
	sw $t1, 0($t3)
	addi $t3, $t0, 7076
	sw $t1, 0($t3)
	addi $t3, $t0, 7080
	sw $t1, 0($t3)
	addi $t3, $t0, 7092
	sw $t1, 0($t3)
	addi $t3, $t0, 7096
	sw $t1, 0($t3)
	addi $t3, $t0, 7100
	sw $t1, 0($t3)
	addi $t3, $t0, 7104
	sw $t1, 0($t3)
	addi $t3, $t0, 7232
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7236
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7240
	sw $t1, 0($t3)
	addi $t3, $t0, 7248
	sw $t1, 0($t3)
	addi $t3, $t0, 7252
	sw $t1, 0($t3)
	addi $t3, $t0, 7260
	sw $t1, 0($t3)
	addi $t3, $t0, 7264
	sw $t1, 0($t3)
	addi $t3, $t0, 7268
	sw $t1, 0($t3)
	addi $t3, $t0, 7280
	sw $t1, 0($t3)
	addi $t3, $t0, 7284
	sw $t1, 0($t3)
	addi $t3, $t0, 7288
	sw $t1, 0($t3)
	addi $t3, $t0, 7292
	sw $t1, 0($t3)
	addi $t3, $t0, 7304
	sw $t1, 0($t3)
	addi $t3, $t0, 7308
	sw $t1, 0($t3)
	addi $t3, $t0, 7312
	sw $t1, 0($t3)
	addi $t3, $t0, 7316
	sw $t1, 0($t3)
	addi $t3, $t0, 7332
	sw $t1, 0($t3)
	addi $t3, $t0, 7336
	sw $t1, 0($t3)
	addi $t3, $t0, 7348
	sw $t1, 0($t3)
	addi $t3, $t0, 7352
	sw $t1, 0($t3)
	addi $t3, $t0, 7356
	sw $t1, 0($t3)
	addi $t3, $t0, 7360
	sw $t1, 0($t3)
	addi $t3, $t0, 7488
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7492
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7496
	sw $t1, 0($t3)
	addi $t3, $t0, 7500
	sw $t1, 0($t3)
	addi $t3, $t0, 7504
	sw $t1, 0($t3)
	addi $t3, $t0, 7508
	li $t1, 0xf898b4
	sw $t1, 0($t3)
	addi $t3, $t0, 7512
	li $t1, 0xf799b4
	sw $t1, 0($t3)
	addi $t3, $t0, 7516
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7520
	sw $t1, 0($t3)
	addi $t3, $t0, 7524
	sw $t1, 0($t3)
	addi $t3, $t0, 7536
	sw $t1, 0($t3)
	addi $t3, $t0, 7540
	sw $t1, 0($t3)
	addi $t3, $t0, 7544
	sw $t1, 0($t3)
	addi $t3, $t0, 7548
	sw $t1, 0($t3)
	addi $t3, $t0, 7560
	sw $t1, 0($t3)
	addi $t3, $t0, 7564
	sw $t1, 0($t3)
	addi $t3, $t0, 7568
	sw $t1, 0($t3)
	addi $t3, $t0, 7572
	sw $t1, 0($t3)
	addi $t3, $t0, 7576
	sw $t1, 0($t3)
	addi $t3, $t0, 7584
	sw $t1, 0($t3)
	addi $t3, $t0, 7588
	sw $t1, 0($t3)
	addi $t3, $t0, 7592
	sw $t1, 0($t3)
	addi $t3, $t0, 7604
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7608
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7612
	sw $t1, 0($t3)
	addi $t3, $t0, 7616
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7744
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7748
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7752
	sw $t1, 0($t3)
	addi $t3, $t0, 7756
	sw $t1, 0($t3)
	addi $t3, $t0, 7760
	sw $t1, 0($t3)
	addi $t3, $t0, 7764
	sw $t1, 0($t3)
	addi $t3, $t0, 7768
	sw $t1, 0($t3)
	addi $t3, $t0, 7772
	sw $t1, 0($t3)
	addi $t3, $t0, 7776
	sw $t1, 0($t3)
	addi $t3, $t0, 7780
	sw $t1, 0($t3)
	addi $t3, $t0, 7792
	sw $t1, 0($t3)
	addi $t3, $t0, 7796
	sw $t1, 0($t3)
	addi $t3, $t0, 7800
	sw $t1, 0($t3)
	addi $t3, $t0, 7804
	sw $t1, 0($t3)
	addi $t3, $t0, 7816
	sw $t1, 0($t3)
	addi $t3, $t0, 7820
	sw $t1, 0($t3)
	addi $t3, $t0, 7824
	sw $t1, 0($t3)
	addi $t3, $t0, 7828
	sw $t1, 0($t3)
	addi $t3, $t0, 7832
	sw $t1, 0($t3)
	addi $t3, $t0, 7836
	sw $t1, 0($t3)
	addi $t3, $t0, 7840
	sw $t1, 0($t3)
	addi $t3, $t0, 7844
	sw $t1, 0($t3)
	addi $t3, $t0, 7848
	sw $t1, 0($t3)
	addi $t3, $t0, 7864
	li $t1, 0xfa95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7868
	sw $t1, 0($t3)
	addi $t3, $t0, 8000
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8004
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8008
	sw $t1, 0($t3)
	addi $t3, $t0, 8012
	sw $t1, 0($t3)
	addi $t3, $t0, 8016
	sw $t1, 0($t3)
	addi $t3, $t0, 8020
	sw $t1, 0($t3)
	addi $t3, $t0, 8024
	sw $t1, 0($t3)
	addi $t3, $t0, 8028
	sw $t1, 0($t3)
	addi $t3, $t0, 8032
	sw $t1, 0($t3)
	addi $t3, $t0, 8036
	sw $t1, 0($t3)
	addi $t3, $t0, 8048
	sw $t1, 0($t3)
	addi $t3, $t0, 8052
	sw $t1, 0($t3)
	addi $t3, $t0, 8056
	sw $t1, 0($t3)
	addi $t3, $t0, 8060
	sw $t1, 0($t3)
	addi $t3, $t0, 8072
	sw $t1, 0($t3)
	addi $t3, $t0, 8076
	sw $t1, 0($t3)
	addi $t3, $t0, 8080
	sw $t1, 0($t3)
	addi $t3, $t0, 8084
	sw $t1, 0($t3)
	addi $t3, $t0, 8088
	sw $t1, 0($t3)
	addi $t3, $t0, 8092
	sw $t1, 0($t3)
	addi $t3, $t0, 8096
	sw $t1, 0($t3)
	addi $t3, $t0, 8100
	sw $t1, 0($t3)
	addi $t3, $t0, 8104
	sw $t1, 0($t3)
	addi $t3, $t0, 8120
	li $t1, 0xeeb8c8
	sw $t1, 0($t3)
	addi $t3, $t0, 8124
	sw $t1, 0($t3)
	addi $t3, $t0, 8256
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8260
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8264
	sw $t1, 0($t3)
	addi $t3, $t0, 8268
	sw $t1, 0($t3)
	addi $t3, $t0, 8272
	sw $t1, 0($t3)
	addi $t3, $t0, 8276
	sw $t1, 0($t3)
	addi $t3, $t0, 8280
	sw $t1, 0($t3)
	addi $t3, $t0, 8284
	sw $t1, 0($t3)
	addi $t3, $t0, 8288
	sw $t1, 0($t3)
	addi $t3, $t0, 8292
	sw $t1, 0($t3)
	addi $t3, $t0, 8304
	sw $t1, 0($t3)
	addi $t3, $t0, 8308
	sw $t1, 0($t3)
	addi $t3, $t0, 8312
	sw $t1, 0($t3)
	addi $t3, $t0, 8316
	sw $t1, 0($t3)
	addi $t3, $t0, 8328
	sw $t1, 0($t3)
	addi $t3, $t0, 8332
	sw $t1, 0($t3)
	addi $t3, $t0, 8336
	sw $t1, 0($t3)
	addi $t3, $t0, 8348
	sw $t1, 0($t3)
	addi $t3, $t0, 8352
	sw $t1, 0($t3)
	addi $t3, $t0, 8356
	sw $t1, 0($t3)
	addi $t3, $t0, 8360
	sw $t1, 0($t3)
	addi $t3, $t0, 8372
	sw $t1, 0($t3)
	addi $t3, $t0, 8376
	sw $t1, 0($t3)
	addi $t3, $t0, 8380
	sw $t1, 0($t3)
	addi $t3, $t0, 8384
	sw $t1, 0($t3)
	addi $t3, $t0, 8512
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8516
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8520
	sw $t1, 0($t3)
	addi $t3, $t0, 8524
	sw $t1, 0($t3)
	addi $t3, $t0, 8528
	sw $t1, 0($t3)
	addi $t3, $t0, 8532
	li $t1, 0xf59bb5
	sw $t1, 0($t3)
	addi $t3, $t0, 8536
	li $t1, 0xf49ab4
	sw $t1, 0($t3)
	addi $t3, $t0, 8540
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8544
	sw $t1, 0($t3)
	addi $t3, $t0, 8548
	sw $t1, 0($t3)
	addi $t3, $t0, 8560
	sw $t1, 0($t3)
	addi $t3, $t0, 8564
	sw $t1, 0($t3)
	addi $t3, $t0, 8568
	sw $t1, 0($t3)
	addi $t3, $t0, 8572
	sw $t1, 0($t3)
	addi $t3, $t0, 8584
	sw $t1, 0($t3)
	addi $t3, $t0, 8588
	sw $t1, 0($t3)
	addi $t3, $t0, 8608
	sw $t1, 0($t3)
	addi $t3, $t0, 8612
	sw $t1, 0($t3)
	addi $t3, $t0, 8616
	sw $t1, 0($t3)
	addi $t3, $t0, 8628
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8632
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8636
	sw $t1, 0($t3)
	addi $t3, $t0, 8640
	sw $t1, 0($t3)
	addi $t3, $t0, 8772
	sw $t1, 0($t3)
	addi $t3, $t0, 8776
	sw $t1, 0($t3)
	addi $t3, $t0, 8780
	sw $t1, 0($t3)
	addi $t3, $t0, 8784
	li $t1, 0xfcc3d4
	sw $t1, 0($t3)
	addi $t3, $t0, 8796
	li $t1, 0xfad0de
	sw $t1, 0($t3)
	addi $t3, $t0, 8800
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8804
	li $t1, 0xf699b6
	sw $t1, 0($t3)
	addi $t3, $t0, 8816
	li $t1, 0xf8c5d4
	sw $t1, 0($t3)
	addi $t3, $t0, 8820
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8824
	sw $t1, 0($t3)
	addi $t3, $t0, 8828
	sw $t1, 0($t3)
	addi $t3, $t0, 8840
	li $t1, 0xf0a5bc
	sw $t1, 0($t3)
	addi $t3, $t0, 8844
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8864
	li $t1, 0xfefcfd
	sw $t1, 0($t3)
	addi $t3, $t0, 8868
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8872
	li $t1, 0xfcdbe6
	sw $t1, 0($t3)
	addi $t3, $t0, 8888
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8892
	sw $t1, 0($t3)
	addi $t3, $t0, 8896
	li $t1, 0xfefcfd
	sw $t1, 0($t3)
	addi $t3, $t0, 10620
	li $t1, 0xff0003
	sw $t1, 0($t3)
	addi $t3, $t0, 10624
	sw $t1, 0($t3)
	addi $t3, $t0, 10632
	sw $t1, 0($t3)
	addi $t3, $t0, 10636
	li $t1, 0xc20235
	sw $t1, 0($t3)
	addi $t3, $t0, 10876
	li $t1, 0xff0003
	sw $t1, 0($t3)
	addi $t3, $t0, 10880
	sw $t1, 0($t3)
	addi $t3, $t0, 10884
	sw $t1, 0($t3)
	addi $t3, $t0, 10888
	sw $t1, 0($t3)
	addi $t3, $t0, 10892
	li $t1, 0xc20235
	sw $t1, 0($t3)
	addi $t3, $t0, 11136
	li $t1, 0xff0003
	sw $t1, 0($t3)
	addi $t3, $t0, 11140
	sw $t1, 0($t3)
	addi $t3, $t0, 11144
	li $t1, 0xc20235
	sw $t1, 0($t3)
	addi $t3, $t0, 11396
	sw $t1, 0($t3)
	addi $t3, $t0, 11668
	li $t1, 0xe4a449
	sw $t1, 0($t3)
	addi $t3, $t0, 11672
	sw $t1, 0($t3)
	addi $t3, $t0, 11924
	li $t1, 0xf3cd0e
	sw $t1, 0($t3)
	addi $t3, $t0, 11928
	sw $t1, 0($t3)
	addi $t3, $t0, 11932
	sw $t1, 0($t3)
	addi $t3, $t0, 12136
	li $t1, 0xf44336
	sw $t1, 0($t3)
	addi $t3, $t0, 12140
	sw $t1, 0($t3)
	addi $t3, $t0, 12144
	sw $t1, 0($t3)
	addi $t3, $t0, 12148
	sw $t1, 0($t3)
	addi $t3, $t0, 12176
	li $t1, 0xf3cd0e
	sw $t1, 0($t3)
	addi $t3, $t0, 12180
	li $t1, 0xffebb4
	sw $t1, 0($t3)
	addi $t3, $t0, 12184
	sw $t1, 0($t3)
	addi $t3, $t0, 12188
	li $t1, 0xf3cd0e
	sw $t1, 0($t3)
	addi $t3, $t0, 12192
	sw $t1, 0($t3)
	addi $t3, $t0, 12392
	li $t1, 0xffcc80
	sw $t1, 0($t3)
	addi $t3, $t0, 12396
	li $t1, 0x795548
	sw $t1, 0($t3)
	addi $t3, $t0, 12400
	li $t1, 0xffcc80
	sw $t1, 0($t3)
	addi $t3, $t0, 12404
	sw $t1, 0($t3)
	addi $t3, $t0, 12408
	sw $t1, 0($t3)
	addi $t3, $t0, 12436
	li $t1, 0xffebb4
	sw $t1, 0($t3)
	addi $t3, $t0, 12440
	sw $t1, 0($t3)
	addi $t3, $t0, 12444
	li $t1, 0xf3cd0e
	sw $t1, 0($t3)
	addi $t3, $t0, 12652
	li $t1, 0xffcc80
	sw $t1, 0($t3)
	addi $t3, $t0, 12656
	sw $t1, 0($t3)
	addi $t3, $t0, 12660
	sw $t1, 0($t3)
	addi $t3, $t0, 12688
	li $t1, 0xff80ab
	sw $t1, 0($t3)
	addi $t3, $t0, 12692
	sw $t1, 0($t3)
	addi $t3, $t0, 12696
	sw $t1, 0($t3)
	addi $t3, $t0, 12700
	sw $t1, 0($t3)
	addi $t3, $t0, 12704
	li $t1, 0xf3cd0e
	sw $t1, 0($t3)
	addi $t3, $t0, 12900
	li $t1, 0xf44336
	sw $t1, 0($t3)
	addi $t3, $t0, 12904
	sw $t1, 0($t3)
	addi $t3, $t0, 12908
	li $t1, 0x304ffe
	sw $t1, 0($t3)
	addi $t3, $t0, 12912
	li $t1, 0xf44336
	sw $t1, 0($t3)
	addi $t3, $t0, 12916
	sw $t1, 0($t3)
	addi $t3, $t0, 12944
	li $t1, 0xffffff
	sw $t1, 0($t3)
	addi $t3, $t0, 12948
	li $t1, 0xec407a
	sw $t1, 0($t3)
	addi $t3, $t0, 12952
	sw $t1, 0($t3)
	addi $t3, $t0, 12956
	li $t1, 0xffffff
	sw $t1, 0($t3)
	addi $t3, $t0, 13156
	sw $t1, 0($t3)
	addi $t3, $t0, 13160
	li $t1, 0x304ffe
	sw $t1, 0($t3)
	addi $t3, $t0, 13164
	sw $t1, 0($t3)
	addi $t3, $t0, 13168
	sw $t1, 0($t3)
	addi $t3, $t0, 13172
	li $t1, 0xffffff
	sw $t1, 0($t3)
	addi $t3, $t0, 13200
	li $t1, 0xec407a
	sw $t1, 0($t3)
	addi $t3, $t0, 13204
	li $t1, 0xff80ab
	sw $t1, 0($t3)
	addi $t3, $t0, 13208
	sw $t1, 0($t3)
	addi $t3, $t0, 13212
	li $t1, 0xec407a
	sw $t1, 0($t3)
	addi $t3, $t0, 13416
	li $t1, 0x304ffe
	sw $t1, 0($t3)
	addi $t3, $t0, 13424
	sw $t1, 0($t3)
	addi $t3, $t0, 13456
	li $t1, 0xec407a
	sw $t1, 0($t3)
	addi $t3, $t0, 13460
	sw $t1, 0($t3)
	addi $t3, $t0, 13464
	sw $t1, 0($t3)
	addi $t3, $t0, 13468
	sw $t1, 0($t3)
	addi $t3, $t0, 13472
	sw $t1, 0($t3)

	jr $ra


#### DRAW GAME OVER ####
# function draw_game_over():
# this function draws the game over screen	
draw_game_over:
	li $t1, PINK_GAME_OVER
	li $t3, 0
	move $t4, $t0
draw_go_l:
	bgt $t3, 4095, draw_go_l_end
	sw $t1, 0($t4)
	addi $t4, $t4, 4
	addi $t3, $t3, 1
	j draw_go_l
	
draw_go_l_end:
	li $v0, 32
	li $a0, 30
	addi $t3, $t0, 2100
	li $t1, 0xf7b8cb
	sw $t1, 0($t3)
	addi $t3, $t0, 2104
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2108
	sw $t1, 0($t3)
	addi $t3, $t0, 2112
	sw $t1, 0($t3)
	addi $t3, $t0, 2116
	sw $t1, 0($t3)
	addi $t3, $t0, 2120
	sw $t1, 0($t3)
	addi $t3, $t0, 2124
	sw $t1, 0($t3)
	addi $t3, $t0, 2128
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2144
	li $t1, 0xf898b4
	sw $t1, 0($t3)
	addi $t3, $t0, 2148
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2152
	sw $t1, 0($t3)
	addi $t3, $t0, 2156
	sw $t1, 0($t3)
	addi $t3, $t0, 2160
	sw $t1, 0($t3)
	addi $t3, $t0, 2164
	sw $t1, 0($t3)
	addi $t3, $t0, 2188
	sw $t1, 0($t3)
	addi $t3, $t0, 2192
	sw $t1, 0($t3)
	addi $t3, $t0, 2196
	sw $t1, 0($t3)
	addi $t3, $t0, 2204
	li $t1, 0xffe7f2
	sw $t1, 0($t3)
	addi $t3, $t0, 2208
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2212
	sw $t1, 0($t3)
	addi $t3, $t0, 2216
	sw $t1, 0($t3)
	addi $t3, $t0, 2232
	li $t1, 0xfff7fd
	sw $t1, 0($t3)
	addi $t3, $t0, 2236
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2240
	sw $t1, 0($t3)
	addi $t3, $t0, 2244
	sw $t1, 0($t3)
	addi $t3, $t0, 2248
	sw $t1, 0($t3)
	addi $t3, $t0, 2252
	sw $t1, 0($t3)
	addi $t3, $t0, 2256
	sw $t1, 0($t3)
	addi $t3, $t0, 2260
	sw $t1, 0($t3)
	addi $t3, $t0, 2348
	li $t1, 0xf49ab4
	sw $t1, 0($t3)
	addi $t3, $t0, 2352
	li $t1, 0xfffcfd
	sw $t1, 0($t3)
	addi $t3, $t0, 2356
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2360
	sw $t1, 0($t3)
	addi $t3, $t0, 2364
	sw $t1, 0($t3)
	addi $t3, $t0, 2368
	li $t1, 0xff94b4
	sw $t1, 0($t3)
	addi $t3, $t0, 2372
	li $t1, 0xfe95b4
	sw $t1, 0($t3)
	addi $t3, $t0, 2376
	sw $t1, 0($t3)
	addi $t3, $t0, 2380
	sw $t1, 0($t3)
	addi $t3, $t0, 2392
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2396
	li $t1, 0xffe3ef
	sw $t1, 0($t3)
	addi $t3, $t0, 2400
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	syscall
	addi $t3, $t0, 2404
	sw $t1, 0($t3)
	addi $t3, $t0, 2408
	sw $t1, 0($t3)
	addi $t3, $t0, 2412
	li $t1, 0xfe95b4
	sw $t1, 0($t3)
	addi $t3, $t0, 2416
	li $t1, 0xff94b4
	sw $t1, 0($t3)
	addi $t3, $t0, 2420
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2424
	sw $t1, 0($t3)
	addi $t3, $t0, 2436
	li $t1, 0xf996b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2440
	li $t1, 0xf4acc2
	sw $t1, 0($t3)
	addi $t3, $t0, 2444
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2448
	sw $t1, 0($t3)
	addi $t3, $t0, 2452
	sw $t1, 0($t3)
	addi $t3, $t0, 2460
	li $t1, 0xfbdae5
	sw $t1, 0($t3)
	addi $t3, $t0, 2464
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2468
	sw $t1, 0($t3)
	addi $t3, $t0, 2472
	sw $t1, 0($t3)
	addi $t3, $t0, 2484
	li $t1, 0xfffcfd
	sw $t1, 0($t3)
	addi $t3, $t0, 2488
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2492
	sw $t1, 0($t3)
	addi $t3, $t0, 2496
	sw $t1, 0($t3)
	addi $t3, $t0, 2500
	li $t1, 0xfe95b4
	sw $t1, 0($t3)
	addi $t3, $t0, 2504
	sw $t1, 0($t3)
	addi $t3, $t0, 2508
	sw $t1, 0($t3)
	addi $t3, $t0, 2512
	sw $t1, 0($t3)
	addi $t3, $t0, 2516
	li $t1, 0xefedee
	sw $t1, 0($t3)
	addi $t3, $t0, 2604
	li $t1, 0xf49ab4
	sw $t1, 0($t3)
	addi $t3, $t0, 2608
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2612
	sw $t1, 0($t3)
	addi $t3, $t0, 2616
	sw $t1, 0($t3)
	addi $t3, $t0, 2620
	sw $t1, 0($t3)
	addi $t3, $t0, 2624
	li $t1, 0xfffbfe
	sw $t1, 0($t3)
	addi $t3, $t0, 2648
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2652
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2656
	sw $t1, 0($t3)
	addi $t3, $t0, 2660
	sw $t1, 0($t3)
	addi $t3, $t0, 2664
	sw $t1, 0($t3)
	addi $t3, $t0, 2676
	sw $t1, 0($t3)
	addi $t3, $t0, 2680
	sw $t1, 0($t3)
	addi $t3, $t0, 2692
	sw $t1, 0($t3)
	addi $t3, $t0, 2696
	sw $t1, 0($t3)
	addi $t3, $t0, 2700
	sw $t1, 0($t3)
	addi $t3, $t0, 2704
	sw $t1, 0($t3)
	addi $t3, $t0, 2708
	sw $t1, 0($t3)
	addi $t3, $t0, 2716
	li $t1, 0xfdd9e5
	sw $t1, 0($t3)
	addi $t3, $t0, 2720
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2724
	sw $t1, 0($t3)
	addi $t3, $t0, 2728
	sw $t1, 0($t3)
	addi $t3, $t0, 2740
	sw $t1, 0($t3)
	addi $t3, $t0, 2744
	sw $t1, 0($t3)
	addi $t3, $t0, 2748
	sw $t1, 0($t3)
	addi $t3, $t0, 2752
	sw $t1, 0($t3)
	addi $t3, $t0, 2860
	li $t1, 0xf49ab4
	sw $t1, 0($t3)
	addi $t3, $t0, 2864
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2868
	sw $t1, 0($t3)
	addi $t3, $t0, 2872
	sw $t1, 0($t3)
	addi $t3, $t0, 2876
	sw $t1, 0($t3)
	addi $t3, $t0, 2880
	li $t1, 0xfffbfe
	sw $t1, 0($t3)
	addi $t3, $t0, 2888
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2892
	sw $t1, 0($t3)
	addi $t3, $t0, 2904
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2908
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2912
	sw $t1, 0($t3)
	addi $t3, $t0, 2916
	sw $t1, 0($t3)
	addi $t3, $t0, 2920
	sw $t1, 0($t3)
	addi $t3, $t0, 2924
	sw $t1, 0($t3)
	addi $t3, $t0, 2928
	sw $t1, 0($t3)
	addi $t3, $t0, 2932
	sw $t1, 0($t3)
	addi $t3, $t0, 2936
	sw $t1, 0($t3)
	addi $t3, $t0, 2948
	sw $t1, 0($t3)
	addi $t3, $t0, 2952
	sw $t1, 0($t3)
	addi $t3, $t0, 2956
	sw $t1, 0($t3)
	addi $t3, $t0, 2960
	sw $t1, 0($t3)
	addi $t3, $t0, 2964
	sw $t1, 0($t3)
	addi $t3, $t0, 2968
	li $t1, 0xf39ab6
	sw $t1, 0($t3)
	addi $t3, $t0, 2972
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 2976
	sw $t1, 0($t3)
	addi $t3, $t0, 2980
	sw $t1, 0($t3)
	addi $t3, $t0, 2984
	sw $t1, 0($t3)
	addi $t3, $t0, 2996
	sw $t1, 0($t3)
	addi $t3, $t0, 3000
	sw $t1, 0($t3)
	syscall
	addi $t3, $t0, 3004
	sw $t1, 0($t3)
	addi $t3, $t0, 3008
	sw $t1, 0($t3)
	addi $t3, $t0, 3012
	sw $t1, 0($t3)
	addi $t3, $t0, 3016
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3020
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3024
	sw $t1, 0($t3)
	addi $t3, $t0, 3116
	li $t1, 0xf49ab4
	sw $t1, 0($t3)
	addi $t3, $t0, 3120
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3124
	sw $t1, 0($t3)
	addi $t3, $t0, 3128
	sw $t1, 0($t3)
	addi $t3, $t0, 3132
	sw $t1, 0($t3)
	addi $t3, $t0, 3144
	li $t1, 0xff94b4
	sw $t1, 0($t3)
	addi $t3, $t0, 3148
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3152
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3160
	sw $t1, 0($t3)
	addi $t3, $t0, 3164
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3168
	sw $t1, 0($t3)
	addi $t3, $t0, 3172
	sw $t1, 0($t3)
	addi $t3, $t0, 3176
	sw $t1, 0($t3)
	addi $t3, $t0, 3188
	sw $t1, 0($t3)
	addi $t3, $t0, 3192
	sw $t1, 0($t3)
	addi $t3, $t0, 3204
	sw $t1, 0($t3)
	addi $t3, $t0, 3208
	sw $t1, 0($t3)
	addi $t3, $t0, 3212
	sw $t1, 0($t3)
	addi $t3, $t0, 3216
	sw $t1, 0($t3)
	addi $t3, $t0, 3220
	sw $t1, 0($t3)
	addi $t3, $t0, 3224
	sw $t1, 0($t3)
	addi $t3, $t0, 3228
	sw $t1, 0($t3)
	addi $t3, $t0, 3232
	sw $t1, 0($t3)
	addi $t3, $t0, 3236
	sw $t1, 0($t3)
	addi $t3, $t0, 3240
	sw $t1, 0($t3)
	addi $t3, $t0, 3252
	sw $t1, 0($t3)
	addi $t3, $t0, 3256
	sw $t1, 0($t3)
	addi $t3, $t0, 3260
	sw $t1, 0($t3)
	addi $t3, $t0, 3264
	sw $t1, 0($t3)
	addi $t3, $t0, 3268
	li $t1, 0xff94b4
	sw $t1, 0($t3)
	addi $t3, $t0, 3272
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3276
	sw $t1, 0($t3)
	addi $t3, $t0, 3280
	sw $t1, 0($t3)
	addi $t3, $t0, 3372
	li $t1, 0xf49ab4
	sw $t1, 0($t3)
	addi $t3, $t0, 3376
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3380
	sw $t1, 0($t3)
	addi $t3, $t0, 3384
	sw $t1, 0($t3)
	addi $t3, $t0, 3388
	sw $t1, 0($t3)
	addi $t3, $t0, 3400
	li $t1, 0xf1a7be
	sw $t1, 0($t3)
	syscall
	addi $t3, $t0, 3404
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3408
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3416
	sw $t1, 0($t3)
	addi $t3, $t0, 3420
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3424
	sw $t1, 0($t3)
	addi $t3, $t0, 3428
	sw $t1, 0($t3)
	addi $t3, $t0, 3432
	sw $t1, 0($t3)
	addi $t3, $t0, 3444
	sw $t1, 0($t3)
	addi $t3, $t0, 3448
	sw $t1, 0($t3)
	addi $t3, $t0, 3460
	sw $t1, 0($t3)
	addi $t3, $t0, 3464
	sw $t1, 0($t3)
	addi $t3, $t0, 3468
	sw $t1, 0($t3)
	addi $t3, $t0, 3472
	sw $t1, 0($t3)
	addi $t3, $t0, 3476
	sw $t1, 0($t3)
	addi $t3, $t0, 3480
	sw $t1, 0($t3)
	addi $t3, $t0, 3484
	sw $t1, 0($t3)
	addi $t3, $t0, 3488
	sw $t1, 0($t3)
	addi $t3, $t0, 3492
	sw $t1, 0($t3)
	addi $t3, $t0, 3496
	sw $t1, 0($t3)
	addi $t3, $t0, 3508
	sw $t1, 0($t3)
	addi $t3, $t0, 3512
	sw $t1, 0($t3)
	addi $t3, $t0, 3516
	sw $t1, 0($t3)
	addi $t3, $t0, 3520
	sw $t1, 0($t3)
	addi $t3, $t0, 3628
	li $t1, 0xf49ab4
	sw $t1, 0($t3)
	addi $t3, $t0, 3632
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3636
	sw $t1, 0($t3)
	addi $t3, $t0, 3640
	sw $t1, 0($t3)
	addi $t3, $t0, 3644
	sw $t1, 0($t3)
	addi $t3, $t0, 3648
	sw $t1, 0($t3)
	addi $t3, $t0, 3652
	sw $t1, 0($t3)
	addi $t3, $t0, 3656
	sw $t1, 0($t3)
	addi $t3, $t0, 3660
	sw $t1, 0($t3)
	addi $t3, $t0, 3664
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3672
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3676
	sw $t1, 0($t3)
	addi $t3, $t0, 3680
	sw $t1, 0($t3)
	addi $t3, $t0, 3684
	sw $t1, 0($t3)
	addi $t3, $t0, 3688
	sw $t1, 0($t3)
	addi $t3, $t0, 3700
	sw $t1, 0($t3)
	addi $t3, $t0, 3704
	sw $t1, 0($t3)
	addi $t3, $t0, 3716
	sw $t1, 0($t3)
	addi $t3, $t0, 3720
	sw $t1, 0($t3)
	addi $t3, $t0, 3724
	sw $t1, 0($t3)
	addi $t3, $t0, 3728
	sw $t1, 0($t3)
	addi $t3, $t0, 3732
	sw $t1, 0($t3)
	addi $t3, $t0, 3736
	sw $t1, 0($t3)
	addi $t3, $t0, 3740
	sw $t1, 0($t3)
	addi $t3, $t0, 3744
	sw $t1, 0($t3)
	addi $t3, $t0, 3748
	sw $t1, 0($t3)
	addi $t3, $t0, 3752
	sw $t1, 0($t3)
	addi $t3, $t0, 3764
	sw $t1, 0($t3)
	addi $t3, $t0, 3768
	sw $t1, 0($t3)
	addi $t3, $t0, 3772
	sw $t1, 0($t3)
	addi $t3, $t0, 3776
	sw $t1, 0($t3)
	addi $t3, $t0, 3884
	li $t1, 0xf49ab4
	sw $t1, 0($t3)
	addi $t3, $t0, 3888
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3892
	sw $t1, 0($t3)
	addi $t3, $t0, 3896
	sw $t1, 0($t3)
	addi $t3, $t0, 3900
	sw $t1, 0($t3)
	addi $t3, $t0, 3904
	sw $t1, 0($t3)
	addi $t3, $t0, 3908
	sw $t1, 0($t3)
	addi $t3, $t0, 3912
	sw $t1, 0($t3)
	addi $t3, $t0, 3916
	sw $t1, 0($t3)
	addi $t3, $t0, 3920
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3928
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 3932
	sw $t1, 0($t3)
	addi $t3, $t0, 3936
	sw $t1, 0($t3)
	addi $t3, $t0, 3940
	sw $t1, 0($t3)
	addi $t3, $t0, 3944
	sw $t1, 0($t3)
	addi $t3, $t0, 3956
	sw $t1, 0($t3)
	addi $t3, $t0, 3960
	sw $t1, 0($t3)
	addi $t3, $t0, 3972
	sw $t1, 0($t3)
	addi $t3, $t0, 3976
	sw $t1, 0($t3)
	addi $t3, $t0, 3980
	sw $t1, 0($t3)
	addi $t3, $t0, 3984
	sw $t1, 0($t3)
	addi $t3, $t0, 3988
	sw $t1, 0($t3)
	addi $t3, $t0, 3996
	li $t1, 0xfbdae5
	sw $t1, 0($t3)
	addi $t3, $t0, 4000
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	syscall
	addi $t3, $t0, 4004
	sw $t1, 0($t3)
	addi $t3, $t0, 4008
	sw $t1, 0($t3)
	addi $t3, $t0, 4020
	sw $t1, 0($t3)
	addi $t3, $t0, 4024
	sw $t1, 0($t3)
	addi $t3, $t0, 4028
	sw $t1, 0($t3)
	addi $t3, $t0, 4032
	sw $t1, 0($t3)
	addi $t3, $t0, 4036
	sw $t1, 0($t3)
	addi $t3, $t0, 4040
	sw $t1, 0($t3)
	addi $t3, $t0, 4044
	sw $t1, 0($t3)
	addi $t3, $t0, 4048
	sw $t1, 0($t3)
	addi $t3, $t0, 4052
	li $t1, 0xffdbe7
	sw $t1, 0($t3)
	addi $t3, $t0, 4140
	li $t1, 0xf5eaee
	sw $t1, 0($t3)
	addi $t3, $t0, 4144
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4148
	sw $t1, 0($t3)
	addi $t3, $t0, 4152
	sw $t1, 0($t3)
	addi $t3, $t0, 4156
	sw $t1, 0($t3)
	addi $t3, $t0, 4160
	sw $t1, 0($t3)
	addi $t3, $t0, 4164
	sw $t1, 0($t3)
	addi $t3, $t0, 4168
	sw $t1, 0($t3)
	addi $t3, $t0, 4172
	sw $t1, 0($t3)
	addi $t3, $t0, 4184
	sw $t1, 0($t3)
	addi $t3, $t0, 4188
	sw $t1, 0($t3)
	addi $t3, $t0, 4192
	sw $t1, 0($t3)
	addi $t3, $t0, 4196
	sw $t1, 0($t3)
	addi $t3, $t0, 4200
	sw $t1, 0($t3)
	syscall
	addi $t3, $t0, 4212
	sw $t1, 0($t3)
	addi $t3, $t0, 4216
	sw $t1, 0($t3)
	addi $t3, $t0, 4228
	sw $t1, 0($t3)
	addi $t3, $t0, 4232
	sw $t1, 0($t3)
	addi $t3, $t0, 4236
	sw $t1, 0($t3)
	addi $t3, $t0, 4240
	sw $t1, 0($t3)
	addi $t3, $t0, 4244
	sw $t1, 0($t3)
	addi $t3, $t0, 4252
	li $t1, 0xffe7f2
	sw $t1, 0($t3)
	addi $t3, $t0, 4256
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4260
	sw $t1, 0($t3)
	addi $t3, $t0, 4264
	li $t1, 0xff94b4
	sw $t1, 0($t3)
	addi $t3, $t0, 4276
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4280
	sw $t1, 0($t3)
	addi $t3, $t0, 4284
	sw $t1, 0($t3)
	addi $t3, $t0, 4288
	sw $t1, 0($t3)
	addi $t3, $t0, 4292
	sw $t1, 0($t3)
	addi $t3, $t0, 4296
	sw $t1, 0($t3)
	addi $t3, $t0, 4300
	sw $t1, 0($t3)
	addi $t3, $t0, 4304
	sw $t1, 0($t3)
	addi $t3, $t0, 4308
	sw $t1, 0($t3)
	addi $t3, $t0, 4404
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4408
	sw $t1, 0($t3)
	addi $t3, $t0, 4412
	sw $t1, 0($t3)
	addi $t3, $t0, 4416
	sw $t1, 0($t3)
	addi $t3, $t0, 4420
	sw $t1, 0($t3)
	addi $t3, $t0, 4424
	sw $t1, 0($t3)
	addi $t3, $t0, 4428
	li $t1, 0xfff7fd
	sw $t1, 0($t3)
	addi $t3, $t0, 4444
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4448
	sw $t1, 0($t3)
	addi $t3, $t0, 4452
	sw $t1, 0($t3)
	addi $t3, $t0, 4456
	li $t1, 0xfbdae3
	sw $t1, 0($t3)
	addi $t3, $t0, 4468
	li $t1, 0xf8bbcd
	sw $t1, 0($t3)
	addi $t3, $t0, 4472
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4488
	sw $t1, 0($t3)
	addi $t3, $t0, 4492
	sw $t1, 0($t3)
	addi $t3, $t0, 4496
	sw $t1, 0($t3)
	addi $t3, $t0, 4512
	li $t1, 0xf799b4
	sw $t1, 0($t3)
	addi $t3, $t0, 4516
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4520
	li $t1, 0xffe4f0
	sw $t1, 0($t3)
	addi $t3, $t0, 4532
	li $t1, 0xfc95b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4536
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4540
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 4544
	sw $t1, 0($t3)
	addi $t3, $t0, 4548
	sw $t1, 0($t3)
	addi $t3, $t0, 4552
	sw $t1, 0($t3)
	addi $t3, $t0, 4556
	sw $t1, 0($t3)
	addi $t3, $t0, 4560
	sw $t1, 0($t3)
	addi $t3, $t0, 5680
	li $t1, 0xfefefc
	sw $t1, 0($t3)
	addi $t3, $t0, 5684
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 5688
	sw $t1, 0($t3)
	addi $t3, $t0, 5692
	sw $t1, 0($t3)
	addi $t3, $t0, 5696
	sw $t1, 0($t3)
	addi $t3, $t0, 5700
	sw $t1, 0($t3)
	addi $t3, $t0, 5704
	sw $t1, 0($t3)
	addi $t3, $t0, 5708
	li $t1, 0xf5bacc
	sw $t1, 0($t3)
	addi $t3, $t0, 5720
	li $t1, 0xf09db7
	sw $t1, 0($t3)
	addi $t3, $t0, 5724
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 5728
	sw $t1, 0($t3)
	addi $t3, $t0, 5732
	li $t1, 0xfcdce7
	sw $t1, 0($t3)
	addi $t3, $t0, 5744
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 5748
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 5768
	li $t1, 0xfff0f8
	sw $t1, 0($t3)
	addi $t3, $t0, 5772
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 5776
	sw $t1, 0($t3)
	addi $t3, $t0, 5780
	sw $t1, 0($t3)
	addi $t3, $t0, 5784
	sw $t1, 0($t3)
	addi $t3, $t0, 5788
	sw $t1, 0($t3)
	addi $t3, $t0, 5792
	sw $t1, 0($t3)
	addi $t3, $t0, 5796
	sw $t1, 0($t3)
	addi $t3, $t0, 5808
	li $t1, 0xf39bb4
	sw $t1, 0($t3)
	addi $t3, $t0, 5816
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 5820
	sw $t1, 0($t3)
	addi $t3, $t0, 5824
	sw $t1, 0($t3)
	addi $t3, $t0, 5828
	sw $t1, 0($t3)
	addi $t3, $t0, 5832
	sw $t1, 0($t3)
	addi $t3, $t0, 5836
	sw $t1, 0($t3)
	addi $t3, $t0, 5840
	sw $t1, 0($t3)
	addi $t3, $t0, 5932
	li $t1, 0xfbc2d3
	sw $t1, 0($t3)
	addi $t3, $t0, 5936
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 5940
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 5944
	sw $t1, 0($t3)
	addi $t3, $t0, 5948
	li $t1, 0xfe95b4
	sw $t1, 0($t3)
	addi $t3, $t0, 5952
	sw $t1, 0($t3)
	addi $t3, $t0, 5956
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 5960
	sw $t1, 0($t3)
	addi $t3, $t0, 5964
	sw $t1, 0($t3)
	addi $t3, $t0, 5984
	sw $t1, 0($t3)
	addi $t3, $t0, 5988
	sw $t1, 0($t3)
	addi $t3, $t0, 5996
	li $t1, 0xf8c8d6
	sw $t1, 0($t3)
	addi $t3, $t0, 6000
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	syscall
	addi $t3, $t0, 6004
	sw $t1, 0($t3)
	addi $t3, $t0, 6008
	sw $t1, 0($t3)
	addi $t3, $t0, 6024
	li $t1, 0xff94b2
	sw $t1, 0($t3)
	addi $t3, $t0, 6028
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6032
	sw $t1, 0($t3)
	addi $t3, $t0, 6036
	li $t1, 0xfe95b4
	sw $t1, 0($t3)
	addi $t3, $t0, 6040
	sw $t1, 0($t3)
	addi $t3, $t0, 6044
	sw $t1, 0($t3)
	addi $t3, $t0, 6048
	sw $t1, 0($t3)
	addi $t3, $t0, 6064
	li $t1, 0xf49ab4
	sw $t1, 0($t3)
	addi $t3, $t0, 6068
	li $t1, 0xfefcfd
	sw $t1, 0($t3)
	addi $t3, $t0, 6072
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6076
	sw $t1, 0($t3)
	addi $t3, $t0, 6080
	sw $t1, 0($t3)
	addi $t3, $t0, 6084
	li $t1, 0xfe95b4
	sw $t1, 0($t3)
	addi $t3, $t0, 6088
	sw $t1, 0($t3)
	addi $t3, $t0, 6092
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6096
	sw $t1, 0($t3)
	addi $t3, $t0, 6100
	sw $t1, 0($t3)
	addi $t3, $t0, 6188
	sw $t1, 0($t3)
	addi $t3, $t0, 6192
	sw $t1, 0($t3)
	addi $t3, $t0, 6196
	sw $t1, 0($t3)
	addi $t3, $t0, 6200
	sw $t1, 0($t3)
	syscall
	addi $t3, $t0, 6212
	li $t1, 0xefa4bb
	sw $t1, 0($t3)
	addi $t3, $t0, 6216
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6220
	sw $t1, 0($t3)
	addi $t3, $t0, 6232
	li $t1, 0xfc97b5
	sw $t1, 0($t3)
	addi $t3, $t0, 6236
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6240
	sw $t1, 0($t3)
	addi $t3, $t0, 6244
	sw $t1, 0($t3)
	addi $t3, $t0, 6252
	li $t1, 0xf8c8d6
	sw $t1, 0($t3)
	addi $t3, $t0, 6256
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6260
	sw $t1, 0($t3)
	addi $t3, $t0, 6264
	sw $t1, 0($t3)
	addi $t3, $t0, 6276
	sw $t1, 0($t3)
	addi $t3, $t0, 6280
	sw $t1, 0($t3)
	addi $t3, $t0, 6284
	sw $t1, 0($t3)
	addi $t3, $t0, 6288
	sw $t1, 0($t3)
	addi $t3, $t0, 6320
	li $t1, 0xf39bb4
	sw $t1, 0($t3)
	addi $t3, $t0, 6324
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6328
	sw $t1, 0($t3)
	addi $t3, $t0, 6332
	sw $t1, 0($t3)
	addi $t3, $t0, 6336
	sw $t1, 0($t3)
	addi $t3, $t0, 6348
	sw $t1, 0($t3)
	addi $t3, $t0, 6352
	sw $t1, 0($t3)
	addi $t3, $t0, 6356
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6444
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6448
	sw $t1, 0($t3)
	addi $t3, $t0, 6452
	sw $t1, 0($t3)
	addi $t3, $t0, 6456
	sw $t1, 0($t3)
	addi $t3, $t0, 6468
	li $t1, 0xefa4bb
	sw $t1, 0($t3)
	addi $t3, $t0, 6472
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6476
	sw $t1, 0($t3)
	addi $t3, $t0, 6488
	sw $t1, 0($t3)
	addi $t3, $t0, 6492
	sw $t1, 0($t3)
	addi $t3, $t0, 6496
	sw $t1, 0($t3)
	addi $t3, $t0, 6500
	sw $t1, 0($t3)
	addi $t3, $t0, 6508
	li $t1, 0xf8c8d6
	sw $t1, 0($t3)
	addi $t3, $t0, 6512
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6516
	sw $t1, 0($t3)
	addi $t3, $t0, 6520
	sw $t1, 0($t3)
	addi $t3, $t0, 6532
	sw $t1, 0($t3)
	addi $t3, $t0, 6536
	sw $t1, 0($t3)
	addi $t3, $t0, 6540
	sw $t1, 0($t3)
	addi $t3, $t0, 6544
	sw $t1, 0($t3)
	addi $t3, $t0, 6548
	sw $t1, 0($t3)
	addi $t3, $t0, 6552
	sw $t1, 0($t3)
	addi $t3, $t0, 6556
	sw $t1, 0($t3)
	addi $t3, $t0, 6560
	sw $t1, 0($t3)
	addi $t3, $t0, 6576
	li $t1, 0xf39bb4
	sw $t1, 0($t3)
	addi $t3, $t0, 6580
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6584
	sw $t1, 0($t3)
	addi $t3, $t0, 6588
	sw $t1, 0($t3)
	addi $t3, $t0, 6592
	sw $t1, 0($t3)
	addi $t3, $t0, 6596
	sw $t1, 0($t3)
	addi $t3, $t0, 6600
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	syscall
	addi $t3, $t0, 6604
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6608
	sw $t1, 0($t3)
	addi $t3, $t0, 6612
	sw $t1, 0($t3)
	addi $t3, $t0, 6700
	sw $t1, 0($t3)
	addi $t3, $t0, 6704
	sw $t1, 0($t3)
	addi $t3, $t0, 6708
	sw $t1, 0($t3)
	addi $t3, $t0, 6712
	sw $t1, 0($t3)
	addi $t3, $t0, 6724
	li $t1, 0xf0a5bc
	sw $t1, 0($t3)
	addi $t3, $t0, 6728
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6732
	sw $t1, 0($t3)
	addi $t3, $t0, 6744
	sw $t1, 0($t3)
	addi $t3, $t0, 6748
	sw $t1, 0($t3)
	addi $t3, $t0, 6752
	sw $t1, 0($t3)
	addi $t3, $t0, 6756
	sw $t1, 0($t3)
	addi $t3, $t0, 6764
	sw $t1, 0($t3)
	addi $t3, $t0, 6768
	sw $t1, 0($t3)
	addi $t3, $t0, 6772
	sw $t1, 0($t3)
	addi $t3, $t0, 6776
	sw $t1, 0($t3)
	addi $t3, $t0, 6788
	sw $t1, 0($t3)
	addi $t3, $t0, 6792
	sw $t1, 0($t3)
	addi $t3, $t0, 6796
	sw $t1, 0($t3)
	addi $t3, $t0, 6800
	sw $t1, 0($t3)
	syscall
	addi $t3, $t0, 6804
	sw $t1, 0($t3)
	addi $t3, $t0, 6808
	sw $t1, 0($t3)
	addi $t3, $t0, 6812
	sw $t1, 0($t3)
	addi $t3, $t0, 6816
	sw $t1, 0($t3)
	addi $t3, $t0, 6832
	li $t1, 0xf39bb4
	sw $t1, 0($t3)
	addi $t3, $t0, 6836
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6840
	sw $t1, 0($t3)
	addi $t3, $t0, 6844
	sw $t1, 0($t3)
	addi $t3, $t0, 6848
	sw $t1, 0($t3)
	addi $t3, $t0, 6852
	sw $t1, 0($t3)
	addi $t3, $t0, 6856
	sw $t1, 0($t3)
	addi $t3, $t0, 6860
	sw $t1, 0($t3)
	addi $t3, $t0, 6864
	sw $t1, 0($t3)
	addi $t3, $t0, 6956
	sw $t1, 0($t3)
	addi $t3, $t0, 6960
	sw $t1, 0($t3)
	addi $t3, $t0, 6964
	sw $t1, 0($t3)
	addi $t3, $t0, 6968
	sw $t1, 0($t3)
	addi $t3, $t0, 6980
	li $t1, 0xf0a5bc
	sw $t1, 0($t3)
	addi $t3, $t0, 6984
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 6988
	sw $t1, 0($t3)
	addi $t3, $t0, 7000
	sw $t1, 0($t3)
	syscall
	addi $t3, $t0, 7004
	sw $t1, 0($t3)
	addi $t3, $t0, 7008
	sw $t1, 0($t3)
	addi $t3, $t0, 7012
	sw $t1, 0($t3)
	addi $t3, $t0, 7016
	sw $t1, 0($t3)
	addi $t3, $t0, 7020
	sw $t1, 0($t3)
	addi $t3, $t0, 7024
	sw $t1, 0($t3)
	addi $t3, $t0, 7028
	sw $t1, 0($t3)
	addi $t3, $t0, 7032
	li $t1, 0xffcfdd
	sw $t1, 0($t3)
	addi $t3, $t0, 7044
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7048
	sw $t1, 0($t3)
	addi $t3, $t0, 7052
	sw $t1, 0($t3)
	addi $t3, $t0, 7056
	sw $t1, 0($t3)
	addi $t3, $t0, 7088
	li $t1, 0xf39bb4
	sw $t1, 0($t3)
	addi $t3, $t0, 7092
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7096
	sw $t1, 0($t3)
	addi $t3, $t0, 7100
	sw $t1, 0($t3)
	addi $t3, $t0, 7104
	sw $t1, 0($t3)
	addi $t3, $t0, 7108
	sw $t1, 0($t3)
	addi $t3, $t0, 7112
	sw $t1, 0($t3)
	addi $t3, $t0, 7116
	sw $t1, 0($t3)
	addi $t3, $t0, 7120
	li $t1, 0xffacc6
	sw $t1, 0($t3)
	addi $t3, $t0, 7212
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7216
	sw $t1, 0($t3)
	addi $t3, $t0, 7220
	sw $t1, 0($t3)
	addi $t3, $t0, 7224
	sw $t1, 0($t3)
	addi $t3, $t0, 7236
	li $t1, 0xefa4bb
	sw $t1, 0($t3)
	addi $t3, $t0, 7240
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7244
	sw $t1, 0($t3)
	addi $t3, $t0, 7256
	sw $t1, 0($t3)
	addi $t3, $t0, 7260
	sw $t1, 0($t3)
	addi $t3, $t0, 7264
	sw $t1, 0($t3)
	addi $t3, $t0, 7268
	sw $t1, 0($t3)
	addi $t3, $t0, 7272
	sw $t1, 0($t3)
	addi $t3, $t0, 7276
	sw $t1, 0($t3)
	addi $t3, $t0, 7280
	sw $t1, 0($t3)
	addi $t3, $t0, 7284
	li $t1, 0xf19bb6
	sw $t1, 0($t3)
	addi $t3, $t0, 7300
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7304
	sw $t1, 0($t3)
	addi $t3, $t0, 7308
	sw $t1, 0($t3)
	addi $t3, $t0, 7312
	sw $t1, 0($t3)
	addi $t3, $t0, 7344
	li $t1, 0xf49ab4
	sw $t1, 0($t3)
	addi $t3, $t0, 7348
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7352
	sw $t1, 0($t3)
	addi $t3, $t0, 7356
	sw $t1, 0($t3)
	addi $t3, $t0, 7360
	sw $t1, 0($t3)
	addi $t3, $t0, 7364
	sw $t1, 0($t3)
	addi $t3, $t0, 7368
	sw $t1, 0($t3)
	addi $t3, $t0, 7372
	sw $t1, 0($t3)
	addi $t3, $t0, 7376
	sw $t1, 0($t3)
	addi $t3, $t0, 7380
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7468
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7472
	sw $t1, 0($t3)
	addi $t3, $t0, 7476
	sw $t1, 0($t3)
	addi $t3, $t0, 7480
	sw $t1, 0($t3)
	addi $t3, $t0, 7484
	sw $t1, 0($t3)
	addi $t3, $t0, 7488
	sw $t1, 0($t3)
	addi $t3, $t0, 7492
	sw $t1, 0($t3)
	addi $t3, $t0, 7496
	sw $t1, 0($t3)
	addi $t3, $t0, 7500
	sw $t1, 0($t3)
	addi $t3, $t0, 7512
	sw $t1, 0($t3)
	addi $t3, $t0, 7516
	sw $t1, 0($t3)
	addi $t3, $t0, 7520
	sw $t1, 0($t3)
	addi $t3, $t0, 7524
	sw $t1, 0($t3)
	addi $t3, $t0, 7528
	sw $t1, 0($t3)
	addi $t3, $t0, 7532
	sw $t1, 0($t3)
	addi $t3, $t0, 7536
	li $t1, 0xf0a5bc
	sw $t1, 0($t3)
	addi $t3, $t0, 7556
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7560
	sw $t1, 0($t3)
	addi $t3, $t0, 7564
	sw $t1, 0($t3)
	addi $t3, $t0, 7568
	sw $t1, 0($t3)
	addi $t3, $t0, 7572
	sw $t1, 0($t3)
	addi $t3, $t0, 7576
	sw $t1, 0($t3)
	addi $t3, $t0, 7580
	sw $t1, 0($t3)
	addi $t3, $t0, 7584
	sw $t1, 0($t3)
	addi $t3, $t0, 7588
	li $t1, 0xfcdce7
	sw $t1, 0($t3)
	addi $t3, $t0, 7600
	li $t1, 0xf39bb4
	sw $t1, 0($t3)
	syscall
	addi $t3, $t0, 7604
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7608
	sw $t1, 0($t3)
	addi $t3, $t0, 7612
	sw $t1, 0($t3)
	addi $t3, $t0, 7616
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7620
	li $t1, 0xf7d1dc
	sw $t1, 0($t3)
	addi $t3, $t0, 7624
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7628
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7632
	sw $t1, 0($t3)
	addi $t3, $t0, 7636
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7728
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7732
	sw $t1, 0($t3)
	addi $t3, $t0, 7736
	sw $t1, 0($t3)
	addi $t3, $t0, 7740
	sw $t1, 0($t3)
	addi $t3, $t0, 7744
	sw $t1, 0($t3)
	addi $t3, $t0, 7748
	sw $t1, 0($t3)
	addi $t3, $t0, 7752
	sw $t1, 0($t3)
	addi $t3, $t0, 7756
	li $t1, 0xf8b9cc
	sw $t1, 0($t3)
	addi $t3, $t0, 7764
	li $t1, 0xefedee
	sw $t1, 0($t3)
	addi $t3, $t0, 7768
	li $t1, 0xf29cb5
	sw $t1, 0($t3)
	addi $t3, $t0, 7772
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7776
	sw $t1, 0($t3)
	addi $t3, $t0, 7780
	sw $t1, 0($t3)
	addi $t3, $t0, 7784
	sw $t1, 0($t3)
	addi $t3, $t0, 7788
	li $t1, 0xfdbed1
	sw $t1, 0($t3)
	addi $t3, $t0, 7812
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7816
	sw $t1, 0($t3)
	addi $t3, $t0, 7820
	sw $t1, 0($t3)
	addi $t3, $t0, 7824
	sw $t1, 0($t3)
	addi $t3, $t0, 7828
	sw $t1, 0($t3)
	addi $t3, $t0, 7832
	sw $t1, 0($t3)
	addi $t3, $t0, 7836
	sw $t1, 0($t3)
	addi $t3, $t0, 7840
	sw $t1, 0($t3)
	addi $t3, $t0, 7844
	sw $t1, 0($t3)
	addi $t3, $t0, 7856
	li $t1, 0xf39bb4
	sw $t1, 0($t3)
	addi $t3, $t0, 7860
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7864
	sw $t1, 0($t3)
	addi $t3, $t0, 7868
	sw $t1, 0($t3)
	addi $t3, $t0, 7872
	sw $t1, 0($t3)
	addi $t3, $t0, 7880
	li $t1, 0xf5eaee
	sw $t1, 0($t3)
	addi $t3, $t0, 7884
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7888
	sw $t1, 0($t3)
	addi $t3, $t0, 7892
	sw $t1, 0($t3)
	addi $t3, $t0, 7984
	li $t1, 0xfd94b3
	sw $t1, 0($t3)
	addi $t3, $t0, 7988
	sw $t1, 0($t3)
	addi $t3, $t0, 7992
	sw $t1, 0($t3)
	addi $t3, $t0, 7996
	sw $t1, 0($t3)
	addi $t3, $t0, 8000
	sw $t1, 0($t3)
	syscall
	addi $t3, $t0, 8004
	sw $t1, 0($t3)
	addi $t3, $t0, 8008
	sw $t1, 0($t3)
	addi $t3, $t0, 8028
	sw $t1, 0($t3)
	addi $t3, $t0, 8032
	sw $t1, 0($t3)
	addi $t3, $t0, 8036
	sw $t1, 0($t3)
	addi $t3, $t0, 8040
	sw $t1, 0($t3)
	addi $t3, $t0, 8068
	sw $t1, 0($t3)
	addi $t3, $t0, 8072
	sw $t1, 0($t3)
	addi $t3, $t0, 8076
	sw $t1, 0($t3)
	addi $t3, $t0, 8080
	sw $t1, 0($t3)
	addi $t3, $t0, 8084
	sw $t1, 0($t3)
	addi $t3, $t0, 8088
	sw $t1, 0($t3)
	addi $t3, $t0, 8092
	sw $t1, 0($t3)
	addi $t3, $t0, 8096
	sw $t1, 0($t3)
	addi $t3, $t0, 8116
	sw $t1, 0($t3)
	addi $t3, $t0, 8120
	sw $t1, 0($t3)
	addi $t3, $t0, 8124
	li $t1, 0xff93b3
	sw $t1, 0($t3)
	addi $t3, $t0, 8140
	li $t1, 0xfff3fc
	sw $t1, 0($t3)
	addi $t3, $t0, 8144
	li $t1, 0xfe95b4
	sw $t1, 0($t3)
	addi $t3, $t0, 10296
	li $t1, 0x000000
	sw $t1, 0($t3)
	addi $t3, $t0, 10300
	li $t1, 0x71360b
	sw $t1, 0($t3)
	addi $t3, $t0, 10304
	sw $t1, 0($t3)
	addi $t3, $t0, 10312
	li $t1, 0x000000
	sw $t1, 0($t3)
	addi $t3, $t0, 10424
	sw $t1, 0($t3)
	addi $t3, $t0, 10432
	li $t1, 0x71360b
	sw $t1, 0($t3)
	addi $t3, $t0, 10436
	sw $t1, 0($t3)
	addi $t3, $t0, 10440
	li $t1, 0x000000
	sw $t1, 0($t3)
	addi $t3, $t0, 10552
	li $t1, 0x71360b
	sw $t1, 0($t3)
	addi $t3, $t0, 10556
	li $t1, 0x000000
	sw $t1, 0($t3)
	addi $t3, $t0, 10560
	li $t1, 0x71360b
	sw $t1, 0($t3)
	addi $t3, $t0, 10564
	li $t1, 0x000000
	sw $t1, 0($t3)
	addi $t3, $t0, 10684
	sw $t1, 0($t3)
	addi $t3, $t0, 10688
	li $t1, 0x71360b
	sw $t1, 0($t3)
	addi $t3, $t0, 10692
	li $t1, 0x000000
	sw $t1, 0($t3)
	addi $t3, $t0, 10696
	li $t1, 0x71360b
	sw $t1, 0($t3)
	addi $t3, $t0, 10804
	sw $t1, 0($t3)
	addi $t3, $t0, 10808
	sw $t1, 0($t3)
	addi $t3, $t0, 10812
	li $t1, 0xffffff
	sw $t1, 0($t3)
	addi $t3, $t0, 10816
	li $t1, 0x71360b
	sw $t1, 0($t3)
	addi $t3, $t0, 10820
	li $t1, 0xffffff
	sw $t1, 0($t3)
	addi $t3, $t0, 10824
	li $t1, 0x71360b
	sw $t1, 0($t3)
	addi $t3, $t0, 10936
	sw $t1, 0($t3)
	addi $t3, $t0, 10940
	li $t1, 0xffffff
	sw $t1, 0($t3)
	addi $t3, $t0, 10944
	li $t1, 0x71360b
	sw $t1, 0($t3)
	addi $t3, $t0, 10948
	li $t1, 0xffffff
	sw $t1, 0($t3)
	addi $t3, $t0, 10952
	li $t1, 0x71360b
	sw $t1, 0($t3)
	addi $t3, $t0, 10956
	sw $t1, 0($t3)
	addi $t3, $t0, 11060
	sw $t1, 0($t3)
	addi $t3, $t0, 11064
	sw $t1, 0($t3)
	addi $t3, $t0, 11068
	sw $t1, 0($t3)
	addi $t3, $t0, 11072
	sw $t1, 0($t3)
	addi $t3, $t0, 11076
	sw $t1, 0($t3)
	addi $t3, $t0, 11080
	sw $t1, 0($t3)
	addi $t3, $t0, 11192
	sw $t1, 0($t3)
	addi $t3, $t0, 11196
	sw $t1, 0($t3)
	addi $t3, $t0, 11200
	sw $t1, 0($t3)
	syscall
	addi $t3, $t0, 11204
	sw $t1, 0($t3)
	addi $t3, $t0, 11208
	sw $t1, 0($t3)
	addi $t3, $t0, 11212
	sw $t1, 0($t3)
	addi $t3, $t0, 11324
	li $t1, 0xc88b5f
	sw $t1, 0($t3)
	addi $t3, $t0, 11328
	sw $t1, 0($t3)
	addi $t3, $t0, 11456
	sw $t1, 0($t3)
	addi $t3, $t0, 11460
	sw $t1, 0($t3)
	addi $t3, $t0, 11580
	li $t1, 0x000000
	sw $t1, 0($t3)
	addi $t3, $t0, 11584
	li $t1, 0xc88b5f
	sw $t1, 0($t3)
	addi $t3, $t0, 11588
	li $t1, 0x000000
	sw $t1, 0($t3)
	addi $t3, $t0, 11616
	li $t1, 0xffcc80
	sw $t1, 0($t3)
	addi $t3, $t0, 11624
	li $t1, 0xf44336
	sw $t1, 0($t3)
	addi $t3, $t0, 11628
	li $t1, 0xffffff
	sw $t1, 0($t3)
	addi $t3, $t0, 11664
	li $t1, 0xf3cd0e
	sw $t1, 0($t3)
	addi $t3, $t0, 11672
	li $t1, 0xff80ab
	sw $t1, 0($t3)
	addi $t3, $t0, 11676
	li $t1, 0xffffff
	sw $t1, 0($t3)
	addi $t3, $t0, 11680
	li $t1, 0xec407a
	sw $t1, 0($t3)
	addi $t3, $t0, 11684
	sw $t1, 0($t3)
	addi $t3, $t0, 11708
	li $t1, 0x000000
	sw $t1, 0($t3)
	addi $t3, $t0, 11712
	li $t1, 0xc88b5f
	sw $t1, 0($t3)
	addi $t3, $t0, 11716
	li $t1, 0x000000
	sw $t1, 0($t3)
	addi $t3, $t0, 11868
	li $t1, 0xf44336
	sw $t1, 0($t3)
	addi $t3, $t0, 11872
	li $t1, 0xffcc80
	sw $t1, 0($t3)
	addi $t3, $t0, 11876
	sw $t1, 0($t3)
	addi $t3, $t0, 11880
	li $t1, 0xf44336
	sw $t1, 0($t3)
	addi $t3, $t0, 11884
	li $t1, 0x304ffe
	sw $t1, 0($t3)
	addi $t3, $t0, 11888
	sw $t1, 0($t3)
	addi $t3, $t0, 11912
	li $t1, 0xe4a449
	sw $t1, 0($t3)
	addi $t3, $t0, 11916
	li $t1, 0xf3cd0e
	sw $t1, 0($t3)
	addi $t3, $t0, 11920
	li $t1, 0xf85050
	sw $t1, 0($t3)
	addi $t3, $t0, 11924
	li $t1, 0xffebb4
	sw $t1, 0($t3)
	addi $t3, $t0, 11928
	li $t1, 0xff80ab
	sw $t1, 0($t3)
	addi $t3, $t0, 11932
	li $t1, 0xec407a
	sw $t1, 0($t3)
	addi $t3, $t0, 11936
	li $t1, 0xff80ab
	sw $t1, 0($t3)
	addi $t3, $t0, 11940
	li $t1, 0xec407a
	sw $t1, 0($t3)
	addi $t3, $t0, 12124
	li $t1, 0xf44336
	sw $t1, 0($t3)
	addi $t3, $t0, 12128
	li $t1, 0xffcc80
	sw $t1, 0($t3)
	addi $t3, $t0, 12132
	sw $t1, 0($t3)
	addi $t3, $t0, 12136
	li $t1, 0x304ffe
	sw $t1, 0($t3)
	addi $t3, $t0, 12140
	sw $t1, 0($t3)
	addi $t3, $t0, 12168
	li $t1, 0xe4a449
	sw $t1, 0($t3)
	addi $t3, $t0, 12172
	li $t1, 0xf3cd0e
	sw $t1, 0($t3)
	addi $t3, $t0, 12176
	li $t1, 0xffebb4
	sw $t1, 0($t3)
	addi $t3, $t0, 12180
	sw $t1, 0($t3)
	addi $t3, $t0, 12184
	li $t1, 0xff80ab
	sw $t1, 0($t3)
	addi $t3, $t0, 12188
	li $t1, 0xec407a
	sw $t1, 0($t3)
	addi $t3, $t0, 12192
	li $t1, 0xff80ab
	sw $t1, 0($t3)
	addi $t3, $t0, 12196
	li $t1, 0xec407a
	sw $t1, 0($t3)
	addi $t3, $t0, 12380
	li $t1, 0xf44336
	sw $t1, 0($t3)
	addi $t3, $t0, 12384
	li $t1, 0x795548
	sw $t1, 0($t3)
	addi $t3, $t0, 12388
	li $t1, 0xffcc80
	sw $t1, 0($t3)
	addi $t3, $t0, 12392
	li $t1, 0xf44336
	sw $t1, 0($t3)
	addi $t3, $t0, 12396
	li $t1, 0x304ffe
	sw $t1, 0($t3)
	addi $t3, $t0, 12400
	sw $t1, 0($t3)
	syscall
	addi $t3, $t0, 12428
	li $t1, 0xf3cd0e
	sw $t1, 0($t3)
	addi $t3, $t0, 12432
	sw $t1, 0($t3)
	addi $t3, $t0, 12436
	sw $t1, 0($t3)
	addi $t3, $t0, 12440
	li $t1, 0xff80ab
	sw $t1, 0($t3)
	addi $t3, $t0, 12444
	li $t1, 0xffffff
	sw $t1, 0($t3)
	addi $t3, $t0, 12448
	li $t1, 0xec407a
	sw $t1, 0($t3)
	addi $t3, $t0, 12452
	sw $t1, 0($t3)
	addi $t3, $t0, 12636
	li $t1, 0xf44336
	sw $t1, 0($t3)
	addi $t3, $t0, 12640
	li $t1, 0xffcc80
	sw $t1, 0($t3)
	addi $t3, $t0, 12648
	li $t1, 0xf44336
	sw $t1, 0($t3)
	addi $t3, $t0, 12652
	li $t1, 0xffffff
	sw $t1, 0($t3)
	addi $t3, $t0, 12680
	li $t1, 0xf85050
	sw $t1, 0($t3)
	addi $t3, $t0, 12684
	li $t1, 0xc0c0c0
	sw $t1, 0($t3)
	addi $t3, $t0, 12688
	li $t1, 0xf3cd0e
	sw $t1, 0($t3)
	addi $t3, $t0, 12692
	li $t1, 0xf85050
	sw $t1, 0($t3)
	addi $t3, $t0, 12696
	li $t1, 0xf3cd0e
	sw $t1, 0($t3)
	addi $t3, $t0, 12708
	li $t1, 0xec407a
	sw $t1, 0($t3)
	addi $t3, $t0, 12928
	li $t1, 0xf85050
	sw $t1, 0($t3)
	addi $t3, $t0, 12936
	sw $t1, 0($t3)
	addi $t3, $t0, 12940
	sw $t1, 0($t3)
	addi $t3, $t0, 12944
	sw $t1, 0($t3)
	addi $t3, $t0, 12948
	sw $t1, 0($t3)
	addi $t3, $t0, 13180
	sw $t1, 0($t3)
	addi $t3, $t0, 13184
	sw $t1, 0($t3)
	addi $t3, $t0, 13188
	sw $t1, 0($t3)
	addi $t3, $t0, 13192
	sw $t1, 0($t3)
	addi $t3, $t0, 13196
	sw $t1, 0($t3)
	addi $t3, $t0, 13200
	sw $t1, 0($t3)
	syscall
	addi $t3, $t0, 13440
	sw $t1, 0($t3)
	addi $t3, $t0, 13444
	sw $t1, 0($t3)
	addi $t3, $t0, 13448
	sw $t1, 0($t3)
	addi $t3, $t0, 13452
	sw $t1, 0($t3)
	addi $t3, $t0, 13456
	sw $t1, 0($t3)
	addi $t3, $t0, 13460
	sw $t1, 0($t3)
	addi $t3, $t0, 13688
	sw $t1, 0($t3)
	addi $t3, $t0, 13692
	sw $t1, 0($t3)
	addi $t3, $t0, 13696
	sw $t1, 0($t3)
	addi $t3, $t0, 13700
	sw $t1, 0($t3)
	addi $t3, $t0, 13704
	sw $t1, 0($t3)
	addi $t3, $t0, 13708
	sw $t1, 0($t3)
	addi $t3, $t0, 13712
	sw $t1, 0($t3)
	addi $t3, $t0, 13716
	sw $t1, 0($t3)
	addi $t3, $t0, 13720
	sw $t1, 0($t3)
	addi $t3, $t0, 13724
	sw $t1, 0($t3)
	addi $t3, $t0, 13728
	sw $t1, 0($t3)
	addi $t3, $t0, 13940
	sw $t1, 0($t3)
	addi $t3, $t0, 13944
	sw $t1, 0($t3)
	addi $t3, $t0, 13948
	sw $t1, 0($t3)
	addi $t3, $t0, 13952
	sw $t1, 0($t3)
	addi $t3, $t0, 13956
	sw $t1, 0($t3)
	addi $t3, $t0, 13960
	sw $t1, 0($t3)
	addi $t3, $t0, 13964
	sw $t1, 0($t3)
	addi $t3, $t0, 13968
	sw $t1, 0($t3)
	addi $t3, $t0, 13972
	sw $t1, 0($t3)
	addi $t3, $t0, 13976
	sw $t1, 0($t3)
	addi $t3, $t0, 14196
	sw $t1, 0($t3)
	addi $t3, $t0, 14200
	sw $t1, 0($t3)
	syscall
	addi $t3, $t0, 14204
	sw $t1, 0($t3)
	addi $t3, $t0, 14208
	sw $t1, 0($t3)
	addi $t3, $t0, 14212
	sw $t1, 0($t3)
	addi $t3, $t0, 14216
	sw $t1, 0($t3)
	addi $t3, $t0, 14220
	sw $t1, 0($t3)
	addi $t3, $t0, 14224
	sw $t1, 0($t3)
	addi $t3, $t0, 14228
	sw $t1, 0($t3)
	addi $t3, $t0, 14232
	sw $t1, 0($t3)
	addi $t3, $t0, 14456
	sw $t1, 0($t3)
	addi $t3, $t0, 14460
	sw $t1, 0($t3)
	addi $t3, $t0, 14464
	sw $t1, 0($t3)
	addi $t3, $t0, 14468
	sw $t1, 0($t3)
	addi $t3, $t0, 14472
	sw $t1, 0($t3)
	addi $t3, $t0, 14476
	sw $t1, 0($t3)
	addi $t3, $t0, 14480
	sw $t1, 0($t3)
	addi $t3, $t0, 14484
	sw $t1, 0($t3)
	addi $t3, $t0, 14488
	sw $t1, 0($t3)
	addi $t3, $t0, 14492
	sw $t1, 0($t3)
	addi $t3, $t0, 14716
	sw $t1, 0($t3)
	addi $t3, $t0, 14724
	sw $t1, 0($t3)
	addi $t3, $t0, 14728
	sw $t1, 0($t3)
	addi $t3, $t0, 14732
	sw $t1, 0($t3)
	addi $t3, $t0, 14740
	sw $t1, 0($t3)
	addi $t3, $t0, 14980
	sw $t1, 0($t3)
	addi $t3, $t0, 14984
	sw $t1, 0($t3)
	addi $t3, $t0, 14988
	sw $t1, 0($t3)
	addi $t3, $t0, 15232
	sw $t1, 0($t3)
	addi $t3, $t0, 15236
	sw $t1, 0($t3)
	jr $ra


###### DRAW_GOOMBA ######
# function draw_goomba(int a):
# a is the starting offset of the goomba
# this function draws a goomba at a given offset
draw_goomba_a:

	lw $s4, 0($sp)		# pop a
	add $s3, $t0, $s4	# la $s3, a($t0)
	li $t1, GOOM1
	sw $t1, -516($s3)
	sw $t1, -512($s3)
	sw $t1, -264($s3)
	sw $t1, -256($s3)
	sw $t1, -12($s3)
	sw $t1, -8($s3)
	sw $t1, 0($s3)
	sw $t1, 8($s3)
	sw $t1, 244($s3)
	sw $t1, 248($s3)
	sw $t1, 252($s3)
	sw $t1, 256($s3)
	sw $t1, 260($s3)
	sw $t1, 264($s3)
	li $t1, BLACK
	sw $t1, -520($s3)
	sw $t1, -504($s3)
	sw $t1, -260($s3)
	sw $t1, -252($s3)
	sw $t1, 764($s3)
	sw $t1, 772($s3)
	li $t1, WHITE
	sw $t1, -4($s3)
	sw $t1, 4($s3)
	li $t1, GOOM2
	sw $t1, 508($s3)
	sw $t1, 512($s3)
	sw $t1, 768($s3)
	
	addi $sp, $sp, 4
	jr $ra
	
###### clear_GOOMBA ######
# function clear_goomba(int a):
# a is the starting offset of the goomba
# this function clears a goomba at a given offset
clear_goomba_a:

	lw $s4, 0($sp)		# pop a
	add $s3, $t0, $s4	# la $s3, a($t0)
	li $t1, BLUE_SKY
	sw $t1, -516($s3)
	sw $t1, -512($s3)
	sw $t1, -264($s3)
	sw $t1, -256($s3)
	sw $t1, -12($s3)
	sw $t1, -8($s3)
	sw $t1, 0($s3)
	sw $t1, 8($s3)
	sw $t1, 244($s3)
	sw $t1, 248($s3)
	sw $t1, 252($s3)
	sw $t1, 256($s3)
	sw $t1, 260($s3)
	sw $t1, 264($s3)
	sw $t1, -520($s3)
	sw $t1, -504($s3)
	sw $t1, -260($s3)
	sw $t1, -252($s3)
	sw $t1, 764($s3)
	sw $t1, 772($s3)
	sw $t1, -4($s3)
	sw $t1, 4($s3)
	sw $t1, 508($s3)
	sw $t1, 512($s3)
	sw $t1, 768($s3)
	
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

###### DRAW_HEART ######
# function draw_heart(int a):
# a is the starting offset of the heart
# this function draws a heart at a given index
draw_heart_a:

	lw $t4, 0($sp)		# pop a
	add $t3, $t0, $t4	#la $t3, a($t0)
	li $t1, HEART1
	sw $t1, -260($t3)
	sw $t1, -252($t3)
	sw $t1, -8($t3)
	sw $t1, -4($t3)
	sw $t1, 0($t3)
	sw $t1, 4($t3)
	sw $t1, 8($t3)
	sw $t1, 252($t3)
	sw $t1, 256($t3)
	li $t1, WHITE
	sw $t1, -264($t3)
	li $t1, HEART2
	sw $t1, -248($t3)
	sw $t1, 8($t3)
	sw $t1, 260($t3)
	sw $t1, 512($t3)

	addi $sp, $sp, 4
	jr $ra
	
###### CLEAR_HEART ######
# function clear_heart(int a):
# a is the starting offset of the heart
# this function clears a heart at a given index
clear_heart_a:

	lw $t4, 0($sp)		# pop a
	add $t3, $t0, $t4	#la $t3, a($t0)
	li $t1, BLUE_SKY
	sw $t1, -260($t3)
	sw $t1, -252($t3)
	sw $t1, -8($t3)
	sw $t1, -4($t3)
	sw $t1, 4($t3)
	sw $t1, 8($t3)
	sw $t1, 252($t3)
	sw $t1, 256($t3)
	sw $t1, -264($t3)
	sw $t1, -248($t3)
	sw $t1, 8($t3)
	sw $t1, 260($t3)
	sw $t1, 512($t3)
	li $t1, HEART1
	sw $t1, 0($t3)

	addi $sp, $sp, 4
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
# if bullet collides with an object, perform action depending on the object
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
	lw $s2, 4($t4)		# load color into $s2 at the address + 4 in $t4 (checks the right pixel)
	j u_else1
u_left1: 
	lw $s2, -4($t4)		# load color into $s2 at the address - 4 in $t4 (checks the left pixel)

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
	# deletes bullet
	li $t1, 1
	sw $t1, 8($t3)		# change value of deleted in bullet to be 1
	
	# removes it from screen
	li $t1, BLUE_SKY
	lw $t4, 0($t3)		# load address of bullet
	sw $t1, 0($t4)
	
	# increment loop variables
	addi $t3, $t3, 12
	addi $t8, $t8, 1
	j u_l1
	
u_goom:	
	# deletes bullet
	li $t1, 1
	sw $t1, 8($t3)		# change value of deleted in bullet to be 1
	
	# removes it from screen
	li $t1, BLUE_SKY
	lw $t4, 0($t3)		# load address of bullet
	sw $t1, 0($t4)
	
	# deletes goomba
u_delete_goom:
	la $s5, enemy_array
	la $s6, num_enemy_array
	lw $s6, 0($s6)
	
	lw $t4, 0($t3)		# load address of bullet
	# calculate offset of bullet
	sub $t1, $t4, $t0	# $t1 is the offset
	
	li $s0, 0
u_delete_l:
	bge $s0, $s6, u_delete_l_end
	
	lw $s3, 0($s5)		# load offset of enemy to $s1
	

u_delete_if:
	addi $s3, $s3, -520	
	blt $t1, $s3, u_delete_else	# if bullet is above the enemy
	addi $s3, $s3, 1292
	bgt $t1, $s3, u_delete_else	# if bullet is below the enemy
	
	# deletes the goomba
	li $s2, 1
	sw $s2, 4($s5)		# save deleted = 1 to enemy
	
	# deletes goomba
	lw $s4, 0($s5)		# load offset of enemy to $s4
	add $s3, $t0, $s4	# la $s3, $s4($t0)
	li $t1, BLUE_SKY
	sw $t1, -516($s3)
	sw $t1, -512($s3)
	sw $t1, -264($s3)
	sw $t1, -256($s3)
	sw $t1, -12($s3)
	sw $t1, -8($s3)
	sw $t1, 0($s3)
	sw $t1, 8($s3)
	sw $t1, 244($s3)
	sw $t1, 248($s3)
	sw $t1, 252($s3)
	sw $t1, 256($s3)
	sw $t1, 260($s3)
	sw $t1, 264($s3)
	sw $t1, -520($s3)
	sw $t1, -504($s3)
	sw $t1, -260($s3)
	sw $t1, -252($s3)
	sw $t1, 764($s3)
	sw $t1, 772($s3)
	sw $t1, -4($s3)
	sw $t1, 4($s3)
	sw $t1, 508($s3)
	sw $t1, 512($s3)
	sw $t1, 768($s3)

u_delete_else:	
	addi $s5, $s5, 8
	addi $s0, $s0, 1
	j u_delete_l
	
u_delete_l_end:

	# increment loop variables
	addi $t3, $t3, 12
	addi $t8, $t8, 1
	j u_l1
	
u_platform:
	# deletes bullet
	li $t1, 1
	sw $t1, 8($t3)		# change value of deleted in bullet to be 1
	
	# removes it from screen
	li $t1, BLUE_SKY
	lw $t4, 0($t3)		# load address of bullet
	sw $t1, 0($t4)
	
	# increment loop variables
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

##### PAINTING CHARACTERS #####
	
##### Draw goombas according to the enemy_array and num_enemy_array #####
draw_goombas:
	la $t3, enemy_array
	la $s1, num_enemy_array
	lw $s1, 0($s1)
	
	add $t8, $zero, $zero
draw_goom_l:	
	bge $t8, $s1, draw_goom_l_end
	
	lw $t4, 0($t3)		# load offset of enemy
	lw $s4, 4($t3)		# load deleted of enemy
	
	beq $s4, 1, draw_goom_cont # doesn't draw the goomba if deleted == 1
	# paint goomba
	addi $sp, $sp, -4
	sw $t4, 0($sp)
	jal draw_goomba_a
	
draw_goom_cont:	
	addi $t3, $t3, 8
	addi $t8, $t8, 1
	
	j draw_goom_l
draw_goom_l_end:

	# paint mario
	addi $t8, $zero, 3376
	addi $sp, $sp, -4
	sw $t8, 0($sp)
	jal draw_mario_a
	
	# paint player
	jal draw_player
	
##### DRAW HEARTS #####

	li $t4, 1432
	li $s3, 4
	li $s2, 28
	mult $s3, $s2
	mflo $s3 
	add $s3, $s3, $t4
clear_hearts_l:
	bge $t4, $s3, clear_hearts_end
	
	addi $sp, $sp, -4
	sw $t4, 0($sp)
	jal clear_heart_a
	addi $t4, $t4, 28
	j clear_hearts_l

clear_hearts_end:

	li $t4, 1432
	la $s3, num_hearts
	lw $s3, 0($s3) 
	li $s2, 28
	mult $s3, $s2
	mflo $s3 
	add $s3, $s3, $t4
draw_hearts_l:
	bge $t4, $s3, draw_hearts_end
	
	addi $sp, $sp, -4
	sw $t4, 0($sp)
	jal draw_heart_a
	addi $t4, $t4, 28
	j draw_hearts_l

draw_hearts_end:

##### PLATFORM CREATE #####

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
	addi $t8, $zero, 20
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
	beq $t6, 0x70, p_clicked	# p clicked
	j key_no_clicked

##### do code below if the 'p' key is clicked ##### 
p_clicked:
	# reset values
	la $t4, num_player_bullets
	sw $zero, 0($t4)
	la $t4, jump_count
	sw $zero, 0($t4)
	li $t3, 1
	la $t4, current_level
	sw $t3, 0($t4)
	la $t4, num_hearts
	li $t3, 4
	sw $t3, 0($t4)
	
	# reset goomba delete values
p_restore_goom:
	la $s5, enemy_array
	la $s4, total_num_enemy
	lw $s4, 0($s4)
	
	li $s0, 0
p_restore_goom_l:
	bge $s0, $s4, p_restore_goom_end
	
	# restores the goomba
	li $s2, 0
	sw $s2, 4($s5)		# save deleted = 0 to enemy
	
	addi $s5, $s5, 8
	addi $s0, $s0, 1
	j p_restore_goom_l

p_restore_goom_end:
	j main
	
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
	
	addi $t4, $t4, -768
	ble $t4, 320, key_no_clicked # jumps if index is less than 320
	sw $t4, 4($t2)
	
	jal clear_player
	lw $t4, 0($t2) 	# retrieves position address of player
	addi $t4, $t4, -3072
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
	beq $t1, $t3, a_goom_hit
	lw $t3, -20($t4)
	beq $t1, $t3, a_goom_hit
	lw $t3, -528($t4)
	beq $t1, $t3, a_goom_hit
	lw $t3, -532($t4)
	beq $t1, $t3, a_goom_hit
	lw $t3, 496($t4)
	beq $t1, $t3, a_goom_hit
	lw $t3, 492($t4)
	beq $t1, $t3, a_goom_hit
	lw $t3, 1008($t4)
	beq $t1, $t3, a_goom_hit
	lw $t3, 1004($t4)
	bne $t1, $t3, a_if1
	
a_goom_hit:
	la $t1, num_hearts
	lw $s4, 0($t1)
	addi $s4, $s4, -1
	sw $s4, 0($t1)
	j key_no_clicked	

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
	beq $t1, $t3, d_goom_hit
	lw $t3, 20($t4)
	beq $t1, $t3, d_goom_hit
	lw $t3, 528($t4)
	beq $t1, $t3, d_goom_hit
	lw $t3, 532($t4)
	beq $t1, $t3, d_goom_hit
	lw $t3, -496($t4)
	beq $t1, $t3, d_goom_hit
	lw $t3, -492($t4)
	beq $t1, $t3, d_goom_hit
	lw $t3, 1040($t4)
	beq $t1, $t3, d_goom_hit
	lw $t3, 1044($t4)
	bne $t1, $t3, d_if1
	
d_goom_hit:
	la $t1, num_hearts
	lw $s4, 0($t1)
	addi $s4, $s4, -1
	sw $s4, 0($t1)
	j key_no_clicked
	
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

	la $t4, num_player_bullets
	lw $t4, 0($t4)
	bge $t4, 20, key_no_clicked	# can't shoot anymore after 20 bullets

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
	
	lw $s4, 8($t2)		# retrives direction of player
	beq $s4, 1, check_left
	lw $t3, 1012($t4)
	j check_if_end
check_left:	
	lw $t3, 1036($t4)
	
check_if_end:
	bne $t1, $t3, gravity

IF1:	j grounded


##### simulates gravity ##### 
gravity:
	# the 2 is a timing thing. The higher the value, the slower the player falls
	#bgt $t5, 2, do_grav
	#j end_iteration
	
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

##### check hearts #####

check_hearts:
	la $s3, num_hearts
	lw $s3, 0($s3)
	bgt $s3, 0, check_hearts_else
	j limbo

check_hearts_else: 

##### this loop is finished, call sleep and jump to MAIN_L #####
end_iteration:	
	# sleep
	li $v0, 32 
	li $a0, REFRESH_RATE
	syscall

	# while loop counter
	addi $t5,$t5, 1
	j MAIN_L
	
	j END
	
##### at this point, the game is either lost or won. pressing p will reset the game. #####
limbo:
	li $t9, KEY_ADDRESS
	addi $t5,$zero, 1
	
	jal draw_game_over

limbo_l:
	beq $t5, $zero, END
	lw $t7, 0($t9)	# 1 if there is a new keypress
	lw $t6, 4($t9)	# value of the key press
	
limbo_if_key:	
	bne $t7, 1, limbo_key_no_clicked
	
##### do code below if a key is clicked ##### 
limbo_key_clicked:
	beq $t6, 0x70, p_clicked	# p clicked

limbo_key_no_clicked:
	j limbo_l

##### End program #####
END:	
	li $v0, 10
	syscall

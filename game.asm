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
# - Milestone 3
# 
# Which approved features have been implemented for milestone 3? 
# 1. Health/Score (2 marks)
# 2. Fail Condition (1 mark)
# 3. Win Condition (1 mark)
# 4. Shoot Enemies (2 marks)
# 5. Double Jump (1 mark)
# 6. Different Levels (2 marks)
# 7. Enemies shoot back (2 marks)
# 
# Link to video demonstration for final submission: 
# - (insert YouTube / MyMedia / other URL here)
# 
# Are you OK with us sharing the video with people outside course staff? 
# - yes, and please share this project github link as well. 
# 
# Any additional information that the TA needs to know: 
# - Name of the game: Mario, but Princess Peach Saves Him
# - There can be at most 20 bullets on the screen (trying to do more than 20 is impossible since
# 	the game does't allow it)
# 
##################################################################### 

# bowser colours
.eqv  BOWSER1  0x780f0f
.eqv  BOWSER2  0xb71c1c
.eqv  BOWSER3  0x757575
.eqv  BOWSER4  0x1b5e20
.eqv  BOWSER5  0x558b2f
.eqv  BOWSER6  0xa66c07
.eqv  BOWSER7  0x999999
.eqv  BOWSER8  0xffb300
.eqv  BOWSER9  0x6b3900
.eqv  BOWSER10 0x996600
.eqv  BOWSER11 0x995400
.eqv  BOWSER_BULLET 0xff0000

.data
player: .space 12
jump_count: .word 0
num_player_bullets: .word 0
player_bullet_array: .space 240 	# each bullet has space of 12, so the array only allows 20 bullets
enemy_array: .word 
	8296, 0, 1, 
	13968, 0, 1, 
	4532, 0, 1, 
	3508, 0, 2, 
	6864, 0, 2, 
	13924, 0, 2, 
	10040, 0, 2,
	8296, 0, 3, 
	13908, 0, 3,
	4532, 0, 3,
total_num_enemy: .word 10
platform_array: .word 
	11400, 24, 1, 
	9296, 8, 1, 
	5500, 16, 1, 
	4360, 20, 1, 
	4504, 10, 2, 
	7860, 10, 2, 
	11036, 15, 2, 
	7700, 15, 2
	11400, 24, 3, 
	9296, 8, 3, 
	11036, 15, 3,
	5532, 10, 3, 
total_platforms: .word 12
num_enemy_array: .word 3, 4, 5		# each element at index i represents the number of enemies at level i
num_enemy_killed: .word 0
current_level: .word 1
num_hearts: .word 3					# player starts with 3 hearts
bowser_colors: .word BOWSER1, BOWSER2, BOWSER3, BOWSER4, BOWSER5, BOWSER6, BOWSER7, BOWSER8, BOWSER9, BOWSER10, BOWSER11
bowser_health: .word 10				# bowser requires 10 bullets to kill him
num_enemy_bullets: .word 0
enemy_bullet_array: .space 80 	# each bullet has space of 8, so the array only allows 10 bullets


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
.eqv  PEACH_BULLET 0xe5994d

# mario colours
.eqv  MARIO1  0xfa3838
.eqv  MARIO2  0x704b41
.eqv  MARIO3  0xffc57d
.eqv  MARIO4  0x1d46f6
.eqv  MARIO5  0xffff00

# goomba colours
.eqv  GOOM1  0x6a3917
.eqv  GOOM2  0xc08d66

# heart colours
.eqv  HEART1  0xff334b
.eqv  HEART2  0xcd335b

# sign colours
.eqv  SIGN1  0x2ed56a
.eqv  SIGN2  0x31c665

####### RESERVED REGISTERS #######
# $t0 stores the BASE_ADDRESS
# $t1 is ocassionally used to store color
# $t2 stores player position at all times (has a beginning position)
# $t5, $t6, $t7, $t9 is used inside the main loop
# $t4, $t3, $t8 can be used for other stuff
# $s0-$s7 can be used for computations inside functions
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
	li $v0, 32
	li $a0, 30
	li $t1, 0xf99cb7
	sw $t1, 2632($t0)
	li $t1, 0xff93b3
	sw $t1, 2636($t0)
	li $t1, 0xffebf3
	sw $t1, 2640($t0)
	li $t1, 0xfed4e0
	sw $t1, 2648($t0)
	li $t1, 0xff93b3
	sw $t1, 2652($t0)
	sw $t1, 2656($t0)
	li $t1, 0xffe5ee
	sw $t1, 2660($t0)
	li $t1, 0xffeaf3
	sw $t1, 2672($t0)
	li $t1, 0xfd94b3
	sw $t1, 2676($t0)
	li $t1, 0xff93b3
	sw $t1, 2680($t0)
	sw $t1, 2684($t0)
	sw $t1, 2688($t0)
	sw $t1, 2692($t0)
	sw $t1, 2696($t0)
	li $t1, 0xf9d8e1
	sw $t1, 2700($t0)
	li $t1, 0xff93b3
	sw $t1, 2720($t0)
	sw $t1, 2724($t0)
	li $t1, 0xfad6e0
	sw $t1, 2728($t0)
	li $t1, 0xffd3e5
	sw $t1, 2736($t0)
	li $t1, 0xff93b3
	sw $t1, 2740($t0)
	li $t1, 0xfc94b5
	sw $t1, 2744($t0)
	li $t1, 0xff93b3
	sw $t1, 2884($t0)
	sw $t1, 2888($t0)
	sw $t1, 2892($t0)
	sw $t1, 2896($t0)
	li $t1, 0xfd94b3
	sw $t1, 2900($t0)
	li $t1, 0xff93b3
	sw $t1, 2904($t0)
	sw $t1, 2908($t0)
	sw $t1, 2912($t0)
	li $t1, 0xfd94b3
	sw $t1, 2916($t0)
	sw $t1, 2924($t0)
	li $t1, 0xffe4f0
	sw $t1, 2928($t0)
	li $t1, 0xff93b3
	sw $t1, 2932($t0)
	sw $t1, 2936($t0)
	sw $t1, 2940($t0)
	sw $t1, 2944($t0)
	sw $t1, 2948($t0)
	sw $t1, 2952($t0)
	sw $t1, 2956($t0)
	li $t1, 0xf897b6
	sw $t1, 2968($t0)
	li $t1, 0xf2adc2
	sw $t1, 2972($t0)
	li $t1, 0xff93b3
	sw $t1, 2976($t0)
	sw $t1, 2980($t0)
	sw $t1, 2984($t0)
	sw $t1, 2992($t0)
	sw $t1, 2996($t0)
	sw $t1, 3000($t0)
	syscall
	sw $t1, 3140($t0)
	sw $t1, 3144($t0)
	sw $t1, 3148($t0)
	sw $t1, 3152($t0)
	sw $t1, 3156($t0)
	sw $t1, 3160($t0)
	sw $t1, 3164($t0)
	sw $t1, 3168($t0)
	li $t1, 0xf399b3
	sw $t1, 3172($t0)
	li $t1, 0xfd94b3
	sw $t1, 3180($t0)
	li $t1, 0xff93b3
	sw $t1, 3184($t0)
	sw $t1, 3188($t0)
	sw $t1, 3192($t0)
	sw $t1, 3196($t0)
	sw $t1, 3208($t0)
	sw $t1, 3212($t0)
	sw $t1, 3224($t0)
	sw $t1, 3228($t0)
	sw $t1, 3232($t0)
	sw $t1, 3236($t0)
	sw $t1, 3240($t0)
	sw $t1, 3248($t0)
	sw $t1, 3252($t0)
	sw $t1, 3256($t0)
	li $t1, 0xf898b4
	sw $t1, 3400($t0)
	syscall
	li $t1, 0xff93b3
	sw $t1, 3404($t0)
	sw $t1, 3408($t0)
	sw $t1, 3412($t0)
	sw $t1, 3416($t0)
	sw $t1, 3420($t0)
	sw $t1, 3436($t0)
	sw $t1, 3440($t0)
	sw $t1, 3444($t0)
	sw $t1, 3448($t0)
	sw $t1, 3452($t0)
	sw $t1, 3464($t0)
	sw $t1, 3468($t0)
	sw $t1, 3480($t0)
	sw $t1, 3484($t0)
	sw $t1, 3488($t0)
	sw $t1, 3492($t0)
	sw $t1, 3496($t0)
	sw $t1, 3504($t0)
	sw $t1, 3508($t0)
	sw $t1, 3512($t0)
	li $t1, 0xfd94b3
	sw $t1, 3660($t0)
	li $t1, 0xff93b3
	sw $t1, 3664($t0)
	sw $t1, 3668($t0)
	sw $t1, 3672($t0)
	li $t1, 0xffd7e3
	sw $t1, 3676($t0)
	li $t1, 0xfd94b3
	sw $t1, 3692($t0)
	li $t1, 0xff93b3
	sw $t1, 3696($t0)
	sw $t1, 3700($t0)
	sw $t1, 3704($t0)
	sw $t1, 3708($t0)
	sw $t1, 3720($t0)
	sw $t1, 3724($t0)
	sw $t1, 3736($t0)
	sw $t1, 3740($t0)
	sw $t1, 3744($t0)
	sw $t1, 3748($t0)
	sw $t1, 3752($t0)
	sw $t1, 3760($t0)
	sw $t1, 3764($t0)
	sw $t1, 3768($t0)
	li $t1, 0xfd94b3
	sw $t1, 3916($t0)
	li $t1, 0xff93b3
	sw $t1, 3920($t0)
	sw $t1, 3924($t0)
	sw $t1, 3928($t0)
	li $t1, 0xfbdae3
	sw $t1, 3932($t0)
	li $t1, 0xfd94b3
	sw $t1, 3948($t0)
	li $t1, 0xff93b3
	sw $t1, 3952($t0)
	sw $t1, 3956($t0)
	sw $t1, 3960($t0)
	sw $t1, 3964($t0)
	sw $t1, 3976($t0)
	sw $t1, 3980($t0)
	sw $t1, 3992($t0)
	sw $t1, 3996($t0)
	sw $t1, 4000($t0)
	syscall
	sw $t1, 4004($t0)
	sw $t1, 4008($t0)
	sw $t1, 4016($t0)
	sw $t1, 4020($t0)
	sw $t1, 4024($t0)
	sw $t1, 4172($t0)
	sw $t1, 4176($t0)
	sw $t1, 4180($t0)
	sw $t1, 4184($t0)
	li $t1, 0xfbdae3
	sw $t1, 4188($t0)
	li $t1, 0xff93b3
	sw $t1, 4204($t0)
	sw $t1, 4208($t0)
	sw $t1, 4212($t0)
	sw $t1, 4216($t0)
	sw $t1, 4220($t0)
	sw $t1, 4232($t0)
	sw $t1, 4236($t0)
	sw $t1, 4248($t0)
	sw $t1, 4252($t0)
	sw $t1, 4256($t0)
	sw $t1, 4260($t0)
	sw $t1, 4264($t0)
	sw $t1, 4272($t0)
	sw $t1, 4276($t0)
	sw $t1, 4280($t0)
	sw $t1, 4428($t0)
	sw $t1, 4432($t0)
	sw $t1, 4436($t0)
	sw $t1, 4440($t0)
	li $t1, 0xffe9f2
	sw $t1, 4444($t0)
	li $t1, 0xff93b3
	sw $t1, 4460($t0)
	sw $t1, 4464($t0)
	sw $t1, 4468($t0)
	sw $t1, 4472($t0)
	sw $t1, 4476($t0)
	sw $t1, 4480($t0)
	sw $t1, 4484($t0)
	sw $t1, 4488($t0)
	sw $t1, 4492($t0)
	sw $t1, 4504($t0)
	sw $t1, 4508($t0)
	sw $t1, 4512($t0)
	sw $t1, 4516($t0)
	sw $t1, 4520($t0)
	sw $t1, 4524($t0)
	sw $t1, 4528($t0)
	sw $t1, 4532($t0)
	sw $t1, 4536($t0)
	sw $t1, 4684($t0)
	sw $t1, 4688($t0)
	sw $t1, 4692($t0)
	sw $t1, 4696($t0)
	li $t1, 0xffe9f2
	sw $t1, 4700($t0)
	li $t1, 0xf59bb5
	sw $t1, 4716($t0)
	li $t1, 0xff93b3
	sw $t1, 4720($t0)
	sw $t1, 4724($t0)
	sw $t1, 4728($t0)
	sw $t1, 4732($t0)
	sw $t1, 4736($t0)
	sw $t1, 4740($t0)
	sw $t1, 4744($t0)
	sw $t1, 4748($t0)
	li $t1, 0xf79ab5
	sw $t1, 4760($t0)
	li $t1, 0xff93b3
	sw $t1, 4764($t0)
	sw $t1, 4768($t0)
	sw $t1, 4772($t0)
	sw $t1, 4776($t0)
	sw $t1, 4780($t0)
	sw $t1, 4784($t0)
	sw $t1, 4788($t0)
	li $t1, 0xfd94b3
	sw $t1, 4792($t0)
	li $t1, 0xfefcfd
	sw $t1, 4940($t0)
	li $t1, 0xff93b3
	sw $t1, 4944($t0)
	sw $t1, 4948($t0)
	li $t1, 0xf796b5
	sw $t1, 4952($t0)
	li $t1, 0xffe2ef
	sw $t1, 4976($t0)
	li $t1, 0xff93b3
	sw $t1, 4980($t0)
	sw $t1, 4984($t0)
	sw $t1, 4988($t0)
	sw $t1, 4992($t0)
	sw $t1, 4996($t0)
	sw $t1, 5000($t0)
	syscall
	li $t1, 0xf4acc2
	sw $t1, 5020($t0)
	li $t1, 0xff93b3
	sw $t1, 5024($t0)
	sw $t1, 5028($t0)
	sw $t1, 5032($t0)
	sw $t1, 5036($t0)
	sw $t1, 5040($t0)
	sw $t1, 5044($t0)
	li $t1, 0xffe5ee
	sw $t1, 6464($t0)
	li $t1, 0xffe4ee
	sw $t1, 6468($t0)
	li $t1, 0xf898b4
	sw $t1, 6472($t0)
	li $t1, 0xffc2d5
	sw $t1, 6492($t0)
	li $t1, 0xff93b3
	sw $t1, 6496($t0)
	li $t1, 0xf897b6
	sw $t1, 6500($t0)
	li $t1, 0xf8c5d4
	sw $t1, 6512($t0)
	li $t1, 0xff93b3
	sw $t1, 6520($t0)
	sw $t1, 6524($t0)
	li $t1, 0xf2b5c7
	sw $t1, 6536($t0)
	li $t1, 0xffe4ee
	sw $t1, 6540($t0)
	sw $t1, 6544($t0)
	li $t1, 0xff93b3
	sw $t1, 6564($t0)
	li $t1, 0xffcadb
	sw $t1, 6568($t0)
	li $t1, 0xf9abc1
	sw $t1, 6584($t0)
	li $t1, 0xff93b3
	sw $t1, 6588($t0)
	sw $t1, 6592($t0)
	li $t1, 0xfc95b3
	sw $t1, 6720($t0)
	li $t1, 0xffc2d5
	sw $t1, 6724($t0)
	li $t1, 0xff93b3
	sw $t1, 6728($t0)
	sw $t1, 6748($t0)
	sw $t1, 6752($t0)
	sw $t1, 6756($t0)
	li $t1, 0xfcc3d4
	sw $t1, 6768($t0)
	li $t1, 0xfc95b3
	sw $t1, 6772($t0)
	li $t1, 0xff93b3
	sw $t1, 6776($t0)
	sw $t1, 6780($t0)
	li $t1, 0xffecf7
	sw $t1, 6792($t0)
	li $t1, 0xfd94b3
	sw $t1, 6796($t0)
	li $t1, 0xff93b3
	sw $t1, 6800($t0)
	syscall
	sw $t1, 6820($t0)
	sw $t1, 6824($t0)
	li $t1, 0xfd94b3
	sw $t1, 6840($t0)
	li $t1, 0xff93b3
	sw $t1, 6844($t0)
	sw $t1, 6848($t0)
	li $t1, 0xfc95b3
	sw $t1, 6976($t0)
	li $t1, 0xff93b3
	sw $t1, 6980($t0)
	sw $t1, 6984($t0)
	li $t1, 0xffe4ee
	sw $t1, 6992($t0)
	li $t1, 0xff93b3
	sw $t1, 6996($t0)
	sw $t1, 7004($t0)
	sw $t1, 7008($t0)
	sw $t1, 7012($t0)
	sw $t1, 7024($t0)
	sw $t1, 7028($t0)
	sw $t1, 7032($t0)
	sw $t1, 7036($t0)
	sw $t1, 7048($t0)
	sw $t1, 7052($t0)
	sw $t1, 7056($t0)
	sw $t1, 7076($t0)
	sw $t1, 7080($t0)
	sw $t1, 7092($t0)
	sw $t1, 7096($t0)
	sw $t1, 7100($t0)
	sw $t1, 7104($t0)
	li $t1, 0xfc95b3
	sw $t1, 7232($t0)
	li $t1, 0xff93b3
	sw $t1, 7236($t0)
	sw $t1, 7240($t0)
	sw $t1, 7248($t0)
	sw $t1, 7252($t0)
	sw $t1, 7260($t0)
	sw $t1, 7264($t0)
	sw $t1, 7268($t0)
	sw $t1, 7280($t0)
	sw $t1, 7284($t0)
	sw $t1, 7288($t0)
	sw $t1, 7292($t0)
	sw $t1, 7304($t0)
	sw $t1, 7308($t0)
	sw $t1, 7312($t0)
	sw $t1, 7316($t0)
	sw $t1, 7332($t0)
	sw $t1, 7336($t0)
	sw $t1, 7348($t0)
	sw $t1, 7352($t0)
	sw $t1, 7356($t0)
	sw $t1, 7360($t0)
	li $t1, 0xfc95b3
	sw $t1, 7488($t0)
	li $t1, 0xff93b3
	sw $t1, 7492($t0)
	sw $t1, 7496($t0)
	sw $t1, 7500($t0)
	sw $t1, 7504($t0)
	li $t1, 0xf898b4
	sw $t1, 7508($t0)
	li $t1, 0xf799b4
	sw $t1, 7512($t0)
	li $t1, 0xff93b3
	sw $t1, 7516($t0)
	sw $t1, 7520($t0)
	sw $t1, 7524($t0)
	sw $t1, 7536($t0)
	sw $t1, 7540($t0)
	sw $t1, 7544($t0)
	sw $t1, 7548($t0)
	sw $t1, 7560($t0)
	sw $t1, 7564($t0)
	sw $t1, 7568($t0)
	sw $t1, 7572($t0)
	sw $t1, 7576($t0)
	sw $t1, 7584($t0)
	sw $t1, 7588($t0)
	sw $t1, 7592($t0)
	li $t1, 0xfd94b3
	sw $t1, 7604($t0)
	li $t1, 0xff93b3
	sw $t1, 7608($t0)
	sw $t1, 7612($t0)
	li $t1, 0xfd94b3
	sw $t1, 7616($t0)
	li $t1, 0xfc95b3
	sw $t1, 7744($t0)
	li $t1, 0xff93b3
	sw $t1, 7748($t0)
	sw $t1, 7752($t0)
	sw $t1, 7756($t0)
	sw $t1, 7760($t0)
	sw $t1, 7764($t0)
	sw $t1, 7768($t0)
	sw $t1, 7772($t0)
	sw $t1, 7776($t0)
	sw $t1, 7780($t0)
	sw $t1, 7792($t0)
	sw $t1, 7796($t0)
	sw $t1, 7800($t0)
	syscall
	sw $t1, 7804($t0)
	sw $t1, 7816($t0)
	sw $t1, 7820($t0)
	sw $t1, 7824($t0)
	sw $t1, 7828($t0)
	sw $t1, 7832($t0)
	sw $t1, 7836($t0)
	sw $t1, 7840($t0)
	sw $t1, 7844($t0)
	sw $t1, 7848($t0)
	li $t1, 0xfa95b3
	sw $t1, 7864($t0)
	sw $t1, 7868($t0)
	li $t1, 0xfc95b3
	sw $t1, 8000($t0)
	syscall
	li $t1, 0xff93b3
	sw $t1, 8004($t0)
	sw $t1, 8008($t0)
	sw $t1, 8012($t0)
	sw $t1, 8016($t0)
	sw $t1, 8020($t0)
	sw $t1, 8024($t0)
	sw $t1, 8028($t0)
	sw $t1, 8032($t0)
	sw $t1, 8036($t0)
	sw $t1, 8048($t0)
	sw $t1, 8052($t0)
	sw $t1, 8056($t0)
	sw $t1, 8060($t0)
	sw $t1, 8072($t0)
	sw $t1, 8076($t0)
	sw $t1, 8080($t0)
	sw $t1, 8084($t0)
	sw $t1, 8088($t0)
	sw $t1, 8092($t0)
	sw $t1, 8096($t0)
	sw $t1, 8100($t0)
	sw $t1, 8104($t0)
	li $t1, 0xeeb8c8
	sw $t1, 8120($t0)
	sw $t1, 8124($t0)
	li $t1, 0xfc95b3
	sw $t1, 8256($t0)
	li $t1, 0xff93b3
	sw $t1, 8260($t0)
	sw $t1, 8264($t0)
	sw $t1, 8268($t0)
	sw $t1, 8272($t0)
	sw $t1, 8276($t0)
	sw $t1, 8280($t0)
	sw $t1, 8284($t0)
	sw $t1, 8288($t0)
	sw $t1, 8292($t0)
	sw $t1, 8304($t0)
	sw $t1, 8308($t0)
	sw $t1, 8312($t0)
	sw $t1, 8316($t0)
	sw $t1, 8328($t0)
	sw $t1, 8332($t0)
	sw $t1, 8336($t0)
	sw $t1, 8348($t0)
	sw $t1, 8352($t0)
	sw $t1, 8356($t0)
	sw $t1, 8360($t0)
	sw $t1, 8372($t0)
	sw $t1, 8376($t0)
	sw $t1, 8380($t0)
	sw $t1, 8384($t0)
	li $t1, 0xfc95b3
	sw $t1, 8512($t0)
	li $t1, 0xff93b3
	sw $t1, 8516($t0)
	sw $t1, 8520($t0)
	sw $t1, 8524($t0)
	sw $t1, 8528($t0)
	li $t1, 0xf59bb5
	sw $t1, 8532($t0)
	li $t1, 0xf49ab4
	sw $t1, 8536($t0)
	li $t1, 0xff93b3
	sw $t1, 8540($t0)
	sw $t1, 8544($t0)
	sw $t1, 8548($t0)
	sw $t1, 8560($t0)
	sw $t1, 8564($t0)
	sw $t1, 8568($t0)
	sw $t1, 8572($t0)
	sw $t1, 8584($t0)
	sw $t1, 8588($t0)
	sw $t1, 8608($t0)
	sw $t1, 8612($t0)
	sw $t1, 8616($t0)
	li $t1, 0xfd94b3
	sw $t1, 8628($t0)
	li $t1, 0xff93b3
	sw $t1, 8632($t0)
	sw $t1, 8636($t0)
	sw $t1, 8640($t0)
	sw $t1, 8772($t0)
	sw $t1, 8776($t0)
	sw $t1, 8780($t0)
	li $t1, 0xfcc3d4
	sw $t1, 8784($t0)
	li $t1, 0xfad0de
	sw $t1, 8796($t0)
	li $t1, 0xff93b3
	sw $t1, 8800($t0)
	syscall
	li $t1, 0xf699b6
	sw $t1, 8804($t0)
	li $t1, 0xf8c5d4
	sw $t1, 8816($t0)
	li $t1, 0xff93b3
	sw $t1, 8820($t0)
	sw $t1, 8824($t0)
	sw $t1, 8828($t0)
	li $t1, 0xf0a5bc
	sw $t1, 8840($t0)
	li $t1, 0xff93b3
	sw $t1, 8844($t0)
	li $t1, 0xfefcfd
	sw $t1, 8864($t0)
	li $t1, 0xff93b3
	sw $t1, 8868($t0)
	li $t1, 0xfcdbe6
	sw $t1, 8872($t0)
	li $t1, 0xff93b3
	sw $t1, 8888($t0)
	sw $t1, 8892($t0)
	li $t1, 0xfefcfd
	sw $t1, 8896($t0)
	li $t1, 0xff0003
	sw $t1, 10620($t0)
	sw $t1, 10624($t0)
	sw $t1, 10632($t0)
	li $t1, 0xc20235
	sw $t1, 10636($t0)
	li $t1, 0xff0003
	sw $t1, 10876($t0)
	sw $t1, 10880($t0)
	sw $t1, 10884($t0)
	sw $t1, 10888($t0)
	li $t1, 0xc20235
	sw $t1, 10892($t0)
	li $t1, 0xff0003
	sw $t1, 11136($t0)
	sw $t1, 11140($t0)
	li $t1, 0xc20235
	sw $t1, 11144($t0)
	sw $t1, 11396($t0)
	li $t1, 0xe4a449
	sw $t1, 11668($t0)
	sw $t1, 11672($t0)
	li $t1, 0xf3cd0e
	sw $t1, 11924($t0)
	sw $t1, 11928($t0)
	sw $t1, 11932($t0)
	li $t1, 0xf44336
	sw $t1, 12136($t0)
	sw $t1, 12140($t0)
	sw $t1, 12144($t0)
	sw $t1, 12148($t0)
	li $t1, 0xf3cd0e
	sw $t1, 12176($t0)
	li $t1, 0xffebb4
	sw $t1, 12180($t0)
	sw $t1, 12184($t0)
	li $t1, 0xf3cd0e
	sw $t1, 12188($t0)
	sw $t1, 12192($t0)
	li $t1, 0xffcc80
	sw $t1, 12392($t0)
	li $t1, 0x795548
	sw $t1, 12396($t0)
	li $t1, 0xffcc80
	sw $t1, 12400($t0)
	syscall
	sw $t1, 12404($t0)
	sw $t1, 12408($t0)
	li $t1, 0xffebb4
	sw $t1, 12436($t0)
	sw $t1, 12440($t0)
	li $t1, 0xf3cd0e
	sw $t1, 12444($t0)
	li $t1, 0xffcc80
	sw $t1, 12652($t0)
	sw $t1, 12656($t0)
	sw $t1, 12660($t0)
	li $t1, 0xff80ab
	sw $t1, 12688($t0)
	sw $t1, 12692($t0)
	sw $t1, 12696($t0)
	sw $t1, 12700($t0)
	li $t1, 0xf3cd0e
	sw $t1, 12704($t0)
	li $t1, 0xf44336
	sw $t1, 12900($t0)
	sw $t1, 12904($t0)
	li $t1, 0x304ffe
	sw $t1, 12908($t0)
	li $t1, 0xf44336
	sw $t1, 12912($t0)
	sw $t1, 12916($t0)
	li $t1, 0xffffff
	sw $t1, 12944($t0)
	li $t1, 0xec407a
	sw $t1, 12948($t0)
	sw $t1, 12952($t0)
	li $t1, 0xffffff
	sw $t1, 12956($t0)
	sw $t1, 13156($t0)
	li $t1, 0x304ffe
	sw $t1, 13160($t0)
	sw $t1, 13164($t0)
	sw $t1, 13168($t0)
	li $t1, 0xffffff
	sw $t1, 13172($t0)
	li $t1, 0xec407a
	sw $t1, 13200($t0)
	syscall
	li $t1, 0xff80ab
	sw $t1, 13204($t0)
	sw $t1, 13208($t0)
	li $t1, 0xec407a
	sw $t1, 13212($t0)
	li $t1, 0x304ffe
	sw $t1, 13416($t0)
	sw $t1, 13424($t0)
	li $t1, 0xec407a
	sw $t1, 13456($t0)
	sw $t1, 13460($t0)
	sw $t1, 13464($t0)
	sw $t1, 13468($t0)
	sw $t1, 13472($t0)

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
	li $t1, 0xf7b8cb
	sw $t1, 2100($t0)
	li $t1, 0xff93b3
	sw $t1, 2104($t0)
	sw $t1, 2108($t0)
	sw $t1, 2112($t0)
	sw $t1, 2116($t0)
	sw $t1, 2120($t0)
	sw $t1, 2124($t0)
	li $t1, 0xfc95b3
	sw $t1, 2128($t0)
	li $t1, 0xf898b4
	sw $t1, 2144($t0)
	li $t1, 0xff93b3
	sw $t1, 2148($t0)
	sw $t1, 2152($t0)
	sw $t1, 2156($t0)
	sw $t1, 2160($t0)
	sw $t1, 2164($t0)
	sw $t1, 2188($t0)
	sw $t1, 2192($t0)
	sw $t1, 2196($t0)
	li $t1, 0xffe7f2
	sw $t1, 2204($t0)
	li $t1, 0xff93b3
	sw $t1, 2208($t0)
	sw $t1, 2212($t0)
	sw $t1, 2216($t0)
	li $t1, 0xfff7fd
	sw $t1, 2232($t0)
	li $t1, 0xff93b3
	sw $t1, 2236($t0)
	sw $t1, 2240($t0)
	sw $t1, 2244($t0)
	sw $t1, 2248($t0)
	sw $t1, 2252($t0)
	sw $t1, 2256($t0)
	sw $t1, 2260($t0)
	li $t1, 0xf49ab4
	sw $t1, 2348($t0)
	li $t1, 0xfffcfd
	sw $t1, 2352($t0)
	li $t1, 0xff93b3
	sw $t1, 2356($t0)
	sw $t1, 2360($t0)
	sw $t1, 2364($t0)
	li $t1, 0xff94b4
	sw $t1, 2368($t0)
	li $t1, 0xfe95b4
	sw $t1, 2372($t0)
	sw $t1, 2376($t0)
	sw $t1, 2380($t0)
	li $t1, 0xff93b3
	sw $t1, 2392($t0)
	li $t1, 0xffe3ef
	sw $t1, 2396($t0)
	li $t1, 0xff93b3
	sw $t1, 2400($t0)
	syscall
	sw $t1, 2404($t0)
	sw $t1, 2408($t0)
	li $t1, 0xfe95b4
	sw $t1, 2412($t0)
	li $t1, 0xff94b4
	sw $t1, 2416($t0)
	li $t1, 0xff93b3
	sw $t1, 2420($t0)
	sw $t1, 2424($t0)
	li $t1, 0xf996b3
	sw $t1, 2436($t0)
	li $t1, 0xf4acc2
	sw $t1, 2440($t0)
	li $t1, 0xff93b3
	sw $t1, 2444($t0)
	sw $t1, 2448($t0)
	sw $t1, 2452($t0)
	li $t1, 0xfbdae5
	sw $t1, 2460($t0)
	li $t1, 0xff93b3
	sw $t1, 2464($t0)
	sw $t1, 2468($t0)
	sw $t1, 2472($t0)
	li $t1, 0xfffcfd
	sw $t1, 2484($t0)
	li $t1, 0xff93b3
	sw $t1, 2488($t0)
	sw $t1, 2492($t0)
	sw $t1, 2496($t0)
	li $t1, 0xfe95b4
	sw $t1, 2500($t0)
	sw $t1, 2504($t0)
	sw $t1, 2508($t0)
	sw $t1, 2512($t0)
	li $t1, 0xefedee
	sw $t1, 2516($t0)
	li $t1, 0xf49ab4
	sw $t1, 2604($t0)
	li $t1, 0xff93b3
	sw $t1, 2608($t0)
	sw $t1, 2612($t0)
	sw $t1, 2616($t0)
	sw $t1, 2620($t0)
	li $t1, 0xfffbfe
	sw $t1, 2624($t0)
	li $t1, 0xfd94b3
	sw $t1, 2648($t0)
	li $t1, 0xff93b3
	sw $t1, 2652($t0)
	sw $t1, 2656($t0)
	sw $t1, 2660($t0)
	sw $t1, 2664($t0)
	sw $t1, 2676($t0)
	sw $t1, 2680($t0)
	sw $t1, 2692($t0)
	sw $t1, 2696($t0)
	sw $t1, 2700($t0)
	sw $t1, 2704($t0)
	sw $t1, 2708($t0)
	li $t1, 0xfdd9e5
	sw $t1, 2716($t0)
	li $t1, 0xff93b3
	sw $t1, 2720($t0)
	sw $t1, 2724($t0)
	sw $t1, 2728($t0)
	sw $t1, 2740($t0)
	sw $t1, 2744($t0)
	sw $t1, 2748($t0)
	sw $t1, 2752($t0)
	li $t1, 0xf49ab4
	sw $t1, 2860($t0)
	li $t1, 0xff93b3
	sw $t1, 2864($t0)
	sw $t1, 2868($t0)
	sw $t1, 2872($t0)
	sw $t1, 2876($t0)
	li $t1, 0xfffbfe
	sw $t1, 2880($t0)
	li $t1, 0xff93b3
	sw $t1, 2888($t0)
	sw $t1, 2892($t0)
	li $t1, 0xfd94b3
	sw $t1, 2904($t0)
	li $t1, 0xff93b3
	sw $t1, 2908($t0)
	sw $t1, 2912($t0)
	sw $t1, 2916($t0)
	sw $t1, 2920($t0)
	sw $t1, 2924($t0)
	sw $t1, 2928($t0)
	sw $t1, 2932($t0)
	sw $t1, 2936($t0)
	sw $t1, 2948($t0)
	sw $t1, 2952($t0)
	sw $t1, 2956($t0)
	sw $t1, 2960($t0)
	sw $t1, 2964($t0)
	li $t1, 0xf39ab6
	sw $t1, 2968($t0)
	li $t1, 0xff93b3
	sw $t1, 2972($t0)
	sw $t1, 2976($t0)
	sw $t1, 2980($t0)
	sw $t1, 2984($t0)
	sw $t1, 2996($t0)
	sw $t1, 3000($t0)
	syscall
	sw $t1, 3004($t0)
	sw $t1, 3008($t0)
	sw $t1, 3012($t0)
	li $t1, 0xfd94b3
	sw $t1, 3016($t0)
	li $t1, 0xff93b3
	sw $t1, 3020($t0)
	sw $t1, 3024($t0)
	li $t1, 0xf49ab4
	sw $t1, 3116($t0)
	li $t1, 0xff93b3
	sw $t1, 3120($t0)
	sw $t1, 3124($t0)
	sw $t1, 3128($t0)
	sw $t1, 3132($t0)
	li $t1, 0xff94b4
	sw $t1, 3144($t0)
	li $t1, 0xff93b3
	sw $t1, 3148($t0)
	li $t1, 0xfd94b3
	sw $t1, 3152($t0)
	sw $t1, 3160($t0)
	li $t1, 0xff93b3
	sw $t1, 3164($t0)
	sw $t1, 3168($t0)
	sw $t1, 3172($t0)
	sw $t1, 3176($t0)
	sw $t1, 3188($t0)
	sw $t1, 3192($t0)
	sw $t1, 3204($t0)
	sw $t1, 3208($t0)
	sw $t1, 3212($t0)
	sw $t1, 3216($t0)
	sw $t1, 3220($t0)
	sw $t1, 3224($t0)
	sw $t1, 3228($t0)
	sw $t1, 3232($t0)
	sw $t1, 3236($t0)
	sw $t1, 3240($t0)
	sw $t1, 3252($t0)
	sw $t1, 3256($t0)
	sw $t1, 3260($t0)
	sw $t1, 3264($t0)
	li $t1, 0xff94b4
	sw $t1, 3268($t0)
	li $t1, 0xff93b3
	sw $t1, 3272($t0)
	sw $t1, 3276($t0)
	sw $t1, 3280($t0)
	li $t1, 0xf49ab4
	sw $t1, 3372($t0)
	li $t1, 0xff93b3
	sw $t1, 3376($t0)
	sw $t1, 3380($t0)
	sw $t1, 3384($t0)
	sw $t1, 3388($t0)
	li $t1, 0xf1a7be
	sw $t1, 3400($t0)
	syscall
	li $t1, 0xff93b3
	sw $t1, 3404($t0)
	li $t1, 0xfd94b3
	sw $t1, 3408($t0)
	sw $t1, 3416($t0)
	li $t1, 0xff93b3
	sw $t1, 3420($t0)
	sw $t1, 3424($t0)
	sw $t1, 3428($t0)
	sw $t1, 3432($t0)
	sw $t1, 3444($t0)
	sw $t1, 3448($t0)
	sw $t1, 3460($t0)
	sw $t1, 3464($t0)
	sw $t1, 3468($t0)
	sw $t1, 3472($t0)
	sw $t1, 3476($t0)
	sw $t1, 3480($t0)
	sw $t1, 3484($t0)
	sw $t1, 3488($t0)
	sw $t1, 3492($t0)
	sw $t1, 3496($t0)
	sw $t1, 3508($t0)
	sw $t1, 3512($t0)
	sw $t1, 3516($t0)
	sw $t1, 3520($t0)
	li $t1, 0xf49ab4
	sw $t1, 3628($t0)
	li $t1, 0xff93b3
	sw $t1, 3632($t0)
	sw $t1, 3636($t0)
	sw $t1, 3640($t0)
	sw $t1, 3644($t0)
	sw $t1, 3648($t0)
	sw $t1, 3652($t0)
	sw $t1, 3656($t0)
	sw $t1, 3660($t0)
	li $t1, 0xfd94b3
	sw $t1, 3664($t0)
	li $t1, 0xff93b3
	sw $t1, 3672($t0)
	sw $t1, 3676($t0)
	sw $t1, 3680($t0)
	sw $t1, 3684($t0)
	sw $t1, 3688($t0)
	sw $t1, 3700($t0)
	sw $t1, 3704($t0)
	sw $t1, 3716($t0)
	sw $t1, 3720($t0)
	sw $t1, 3724($t0)
	sw $t1, 3728($t0)
	sw $t1, 3732($t0)
	sw $t1, 3736($t0)
	sw $t1, 3740($t0)
	sw $t1, 3744($t0)
	sw $t1, 3748($t0)
	sw $t1, 3752($t0)
	sw $t1, 3764($t0)
	sw $t1, 3768($t0)
	sw $t1, 3772($t0)
	sw $t1, 3776($t0)
	li $t1, 0xf49ab4
	sw $t1, 3884($t0)
	li $t1, 0xff93b3
	sw $t1, 3888($t0)
	sw $t1, 3892($t0)
	sw $t1, 3896($t0)
	sw $t1, 3900($t0)
	sw $t1, 3904($t0)
	sw $t1, 3908($t0)
	sw $t1, 3912($t0)
	sw $t1, 3916($t0)
	li $t1, 0xfd94b3
	sw $t1, 3920($t0)
	li $t1, 0xff93b3
	sw $t1, 3928($t0)
	sw $t1, 3932($t0)
	sw $t1, 3936($t0)
	sw $t1, 3940($t0)
	sw $t1, 3944($t0)
	sw $t1, 3956($t0)
	sw $t1, 3960($t0)
	sw $t1, 3972($t0)
	sw $t1, 3976($t0)
	sw $t1, 3980($t0)
	sw $t1, 3984($t0)
	sw $t1, 3988($t0)
	li $t1, 0xfbdae5
	sw $t1, 3996($t0)
	li $t1, 0xff93b3
	sw $t1, 4000($t0)
	syscall
	sw $t1, 4004($t0)
	sw $t1, 4008($t0)
	sw $t1, 4020($t0)
	sw $t1, 4024($t0)
	sw $t1, 4028($t0)
	sw $t1, 4032($t0)
	sw $t1, 4036($t0)
	sw $t1, 4040($t0)
	sw $t1, 4044($t0)
	sw $t1, 4048($t0)
	li $t1, 0xffdbe7
	sw $t1, 4052($t0)
	li $t1, 0xf5eaee
	sw $t1, 4140($t0)
	li $t1, 0xff93b3
	sw $t1, 4144($t0)
	sw $t1, 4148($t0)
	sw $t1, 4152($t0)
	sw $t1, 4156($t0)
	sw $t1, 4160($t0)
	sw $t1, 4164($t0)
	sw $t1, 4168($t0)
	sw $t1, 4172($t0)
	sw $t1, 4184($t0)
	sw $t1, 4188($t0)
	sw $t1, 4192($t0)
	sw $t1, 4196($t0)
	sw $t1, 4200($t0)
	syscall
	sw $t1, 4212($t0)
	sw $t1, 4216($t0)
	sw $t1, 4228($t0)
	sw $t1, 4232($t0)
	sw $t1, 4236($t0)
	sw $t1, 4240($t0)
	sw $t1, 4244($t0)
	li $t1, 0xffe7f2
	sw $t1, 4252($t0)
	li $t1, 0xff93b3
	sw $t1, 4256($t0)
	sw $t1, 4260($t0)
	li $t1, 0xff94b4
	sw $t1, 4264($t0)
	li $t1, 0xff93b3
	sw $t1, 4276($t0)
	sw $t1, 4280($t0)
	sw $t1, 4284($t0)
	sw $t1, 4288($t0)
	sw $t1, 4292($t0)
	sw $t1, 4296($t0)
	sw $t1, 4300($t0)
	sw $t1, 4304($t0)
	sw $t1, 4308($t0)
	li $t1, 0xfd94b3
	sw $t1, 4404($t0)
	sw $t1, 4408($t0)
	sw $t1, 4412($t0)
	sw $t1, 4416($t0)
	sw $t1, 4420($t0)
	sw $t1, 4424($t0)
	li $t1, 0xfff7fd
	sw $t1, 4428($t0)
	li $t1, 0xfd94b3
	sw $t1, 4444($t0)
	sw $t1, 4448($t0)
	sw $t1, 4452($t0)
	li $t1, 0xfbdae3
	sw $t1, 4456($t0)
	li $t1, 0xf8bbcd
	sw $t1, 4468($t0)
	li $t1, 0xfd94b3
	sw $t1, 4472($t0)
	sw $t1, 4488($t0)
	sw $t1, 4492($t0)
	sw $t1, 4496($t0)
	li $t1, 0xf799b4
	sw $t1, 4512($t0)
	li $t1, 0xff93b3
	sw $t1, 4516($t0)
	li $t1, 0xffe4f0
	sw $t1, 4520($t0)
	li $t1, 0xfc95b3
	sw $t1, 4532($t0)
	li $t1, 0xff93b3
	sw $t1, 4536($t0)
	li $t1, 0xfd94b3
	sw $t1, 4540($t0)
	sw $t1, 4544($t0)
	sw $t1, 4548($t0)
	sw $t1, 4552($t0)
	sw $t1, 4556($t0)
	sw $t1, 4560($t0)
	li $t1, 0xfefefc
	sw $t1, 5680($t0)
	li $t1, 0xff93b3
	sw $t1, 5684($t0)
	sw $t1, 5688($t0)
	sw $t1, 5692($t0)
	sw $t1, 5696($t0)
	sw $t1, 5700($t0)
	sw $t1, 5704($t0)
	li $t1, 0xf5bacc
	sw $t1, 5708($t0)
	li $t1, 0xf09db7
	sw $t1, 5720($t0)
	li $t1, 0xff93b3
	sw $t1, 5724($t0)
	sw $t1, 5728($t0)
	li $t1, 0xfcdce7
	sw $t1, 5732($t0)
	li $t1, 0xfd94b3
	sw $t1, 5744($t0)
	li $t1, 0xff93b3
	sw $t1, 5748($t0)
	li $t1, 0xfff0f8
	sw $t1, 5768($t0)
	li $t1, 0xff93b3
	sw $t1, 5772($t0)
	sw $t1, 5776($t0)
	sw $t1, 5780($t0)
	sw $t1, 5784($t0)
	sw $t1, 5788($t0)
	sw $t1, 5792($t0)
	sw $t1, 5796($t0)
	li $t1, 0xf39bb4
	sw $t1, 5808($t0)
	li $t1, 0xff93b3
	sw $t1, 5816($t0)
	sw $t1, 5820($t0)
	sw $t1, 5824($t0)
	sw $t1, 5828($t0)
	sw $t1, 5832($t0)
	sw $t1, 5836($t0)
	sw $t1, 5840($t0)
	li $t1, 0xfbc2d3
	sw $t1, 5932($t0)
	li $t1, 0xfd94b3
	sw $t1, 5936($t0)
	li $t1, 0xff93b3
	sw $t1, 5940($t0)
	sw $t1, 5944($t0)
	li $t1, 0xfe95b4
	sw $t1, 5948($t0)
	sw $t1, 5952($t0)
	li $t1, 0xff93b3
	sw $t1, 5956($t0)
	sw $t1, 5960($t0)
	sw $t1, 5964($t0)
	sw $t1, 5984($t0)
	sw $t1, 5988($t0)
	li $t1, 0xf8c8d6
	sw $t1, 5996($t0)
	li $t1, 0xff93b3
	sw $t1, 6000($t0)
	syscall
	sw $t1, 6004($t0)
	sw $t1, 6008($t0)
	li $t1, 0xff94b2
	sw $t1, 6024($t0)
	li $t1, 0xff93b3
	sw $t1, 6028($t0)
	sw $t1, 6032($t0)
	li $t1, 0xfe95b4
	sw $t1, 6036($t0)
	sw $t1, 6040($t0)
	sw $t1, 6044($t0)
	sw $t1, 6048($t0)
	li $t1, 0xf49ab4
	sw $t1, 6064($t0)
	li $t1, 0xfefcfd
	sw $t1, 6068($t0)
	li $t1, 0xff93b3
	sw $t1, 6072($t0)
	sw $t1, 6076($t0)
	sw $t1, 6080($t0)
	li $t1, 0xfe95b4
	sw $t1, 6084($t0)
	sw $t1, 6088($t0)
	li $t1, 0xff93b3
	sw $t1, 6092($t0)
	sw $t1, 6096($t0)
	sw $t1, 6100($t0)
	sw $t1, 6188($t0)
	sw $t1, 6192($t0)
	sw $t1, 6196($t0)
	sw $t1, 6200($t0)
	syscall
	li $t1, 0xefa4bb
	sw $t1, 6212($t0)
	li $t1, 0xff93b3
	sw $t1, 6216($t0)
	sw $t1, 6220($t0)
	li $t1, 0xfc97b5
	sw $t1, 6232($t0)
	li $t1, 0xff93b3
	sw $t1, 6236($t0)
	sw $t1, 6240($t0)
	sw $t1, 6244($t0)
	li $t1, 0xf8c8d6
	sw $t1, 6252($t0)
	li $t1, 0xff93b3
	sw $t1, 6256($t0)
	sw $t1, 6260($t0)
	sw $t1, 6264($t0)
	sw $t1, 6276($t0)
	sw $t1, 6280($t0)
	sw $t1, 6284($t0)
	sw $t1, 6288($t0)
	li $t1, 0xf39bb4
	sw $t1, 6320($t0)
	li $t1, 0xff93b3
	sw $t1, 6324($t0)
	sw $t1, 6328($t0)
	sw $t1, 6332($t0)
	sw $t1, 6336($t0)
	sw $t1, 6348($t0)
	sw $t1, 6352($t0)
	li $t1, 0xfd94b3
	sw $t1, 6356($t0)
	li $t1, 0xff93b3
	sw $t1, 6444($t0)
	sw $t1, 6448($t0)
	sw $t1, 6452($t0)
	sw $t1, 6456($t0)
	li $t1, 0xefa4bb
	sw $t1, 6468($t0)
	li $t1, 0xff93b3
	sw $t1, 6472($t0)
	sw $t1, 6476($t0)
	sw $t1, 6488($t0)
	sw $t1, 6492($t0)
	sw $t1, 6496($t0)
	sw $t1, 6500($t0)
	li $t1, 0xf8c8d6
	sw $t1, 6508($t0)
	li $t1, 0xff93b3
	sw $t1, 6512($t0)
	sw $t1, 6516($t0)
	sw $t1, 6520($t0)
	sw $t1, 6532($t0)
	sw $t1, 6536($t0)
	sw $t1, 6540($t0)
	sw $t1, 6544($t0)
	sw $t1, 6548($t0)
	sw $t1, 6552($t0)
	sw $t1, 6556($t0)
	sw $t1, 6560($t0)
	li $t1, 0xf39bb4
	sw $t1, 6576($t0)
	li $t1, 0xff93b3
	sw $t1, 6580($t0)
	sw $t1, 6584($t0)
	sw $t1, 6588($t0)
	sw $t1, 6592($t0)
	sw $t1, 6596($t0)
	li $t1, 0xfd94b3
	sw $t1, 6600($t0)
	syscall
	li $t1, 0xff93b3
	sw $t1, 6604($t0)
	sw $t1, 6608($t0)
	sw $t1, 6612($t0)
	sw $t1, 6700($t0)
	sw $t1, 6704($t0)
	sw $t1, 6708($t0)
	sw $t1, 6712($t0)
	li $t1, 0xf0a5bc
	sw $t1, 6724($t0)
	li $t1, 0xff93b3
	sw $t1, 6728($t0)
	sw $t1, 6732($t0)
	sw $t1, 6744($t0)
	sw $t1, 6748($t0)
	sw $t1, 6752($t0)
	sw $t1, 6756($t0)
	sw $t1, 6764($t0)
	sw $t1, 6768($t0)
	sw $t1, 6772($t0)
	sw $t1, 6776($t0)
	sw $t1, 6788($t0)
	sw $t1, 6792($t0)
	sw $t1, 6796($t0)
	sw $t1, 6800($t0)
	syscall
	sw $t1, 6804($t0)
	sw $t1, 6808($t0)
	sw $t1, 6812($t0)
	sw $t1, 6816($t0)
	li $t1, 0xf39bb4
	sw $t1, 6832($t0)
	li $t1, 0xff93b3
	sw $t1, 6836($t0)
	sw $t1, 6840($t0)
	sw $t1, 6844($t0)
	sw $t1, 6848($t0)
	sw $t1, 6852($t0)
	sw $t1, 6856($t0)
	sw $t1, 6860($t0)
	sw $t1, 6864($t0)
	sw $t1, 6956($t0)
	sw $t1, 6960($t0)
	sw $t1, 6964($t0)
	sw $t1, 6968($t0)
	li $t1, 0xf0a5bc
	sw $t1, 6980($t0)
	li $t1, 0xff93b3
	sw $t1, 6984($t0)
	sw $t1, 6988($t0)
	sw $t1, 7000($t0)
	syscall
	sw $t1, 7004($t0)
	sw $t1, 7008($t0)
	sw $t1, 7012($t0)
	sw $t1, 7016($t0)
	sw $t1, 7020($t0)
	sw $t1, 7024($t0)
	sw $t1, 7028($t0)
	li $t1, 0xffcfdd
	sw $t1, 7032($t0)
	li $t1, 0xff93b3
	sw $t1, 7044($t0)
	sw $t1, 7048($t0)
	sw $t1, 7052($t0)
	sw $t1, 7056($t0)
	li $t1, 0xf39bb4
	sw $t1, 7088($t0)
	li $t1, 0xff93b3
	sw $t1, 7092($t0)
	sw $t1, 7096($t0)
	sw $t1, 7100($t0)
	sw $t1, 7104($t0)
	sw $t1, 7108($t0)
	sw $t1, 7112($t0)
	sw $t1, 7116($t0)
	li $t1, 0xffacc6
	sw $t1, 7120($t0)
	li $t1, 0xff93b3
	sw $t1, 7212($t0)
	sw $t1, 7216($t0)
	sw $t1, 7220($t0)
	sw $t1, 7224($t0)
	li $t1, 0xefa4bb
	sw $t1, 7236($t0)
	li $t1, 0xff93b3
	sw $t1, 7240($t0)
	sw $t1, 7244($t0)
	sw $t1, 7256($t0)
	sw $t1, 7260($t0)
	sw $t1, 7264($t0)
	sw $t1, 7268($t0)
	sw $t1, 7272($t0)
	sw $t1, 7276($t0)
	sw $t1, 7280($t0)
	li $t1, 0xf19bb6
	sw $t1, 7284($t0)
	li $t1, 0xff93b3
	sw $t1, 7300($t0)
	sw $t1, 7304($t0)
	sw $t1, 7308($t0)
	sw $t1, 7312($t0)
	li $t1, 0xf49ab4
	sw $t1, 7344($t0)
	li $t1, 0xff93b3
	sw $t1, 7348($t0)
	sw $t1, 7352($t0)
	sw $t1, 7356($t0)
	sw $t1, 7360($t0)
	sw $t1, 7364($t0)
	sw $t1, 7368($t0)
	sw $t1, 7372($t0)
	sw $t1, 7376($t0)
	li $t1, 0xfd94b3
	sw $t1, 7380($t0)
	li $t1, 0xff93b3
	sw $t1, 7468($t0)
	sw $t1, 7472($t0)
	sw $t1, 7476($t0)
	sw $t1, 7480($t0)
	sw $t1, 7484($t0)
	sw $t1, 7488($t0)
	sw $t1, 7492($t0)
	sw $t1, 7496($t0)
	sw $t1, 7500($t0)
	sw $t1, 7512($t0)
	sw $t1, 7516($t0)
	sw $t1, 7520($t0)
	sw $t1, 7524($t0)
	sw $t1, 7528($t0)
	sw $t1, 7532($t0)
	li $t1, 0xf0a5bc
	sw $t1, 7536($t0)
	li $t1, 0xff93b3
	sw $t1, 7556($t0)
	sw $t1, 7560($t0)
	sw $t1, 7564($t0)
	sw $t1, 7568($t0)
	sw $t1, 7572($t0)
	sw $t1, 7576($t0)
	sw $t1, 7580($t0)
	sw $t1, 7584($t0)
	li $t1, 0xfcdce7
	sw $t1, 7588($t0)
	li $t1, 0xf39bb4
	sw $t1, 7600($t0)
	syscall
	li $t1, 0xff93b3
	sw $t1, 7604($t0)
	sw $t1, 7608($t0)
	sw $t1, 7612($t0)
	li $t1, 0xfd94b3
	sw $t1, 7616($t0)
	li $t1, 0xf7d1dc
	sw $t1, 7620($t0)
	li $t1, 0xfd94b3
	sw $t1, 7624($t0)
	li $t1, 0xff93b3
	sw $t1, 7628($t0)
	sw $t1, 7632($t0)
	li $t1, 0xfd94b3
	sw $t1, 7636($t0)
	li $t1, 0xff93b3
	sw $t1, 7728($t0)
	sw $t1, 7732($t0)
	sw $t1, 7736($t0)
	sw $t1, 7740($t0)
	sw $t1, 7744($t0)
	sw $t1, 7748($t0)
	sw $t1, 7752($t0)
	li $t1, 0xf8b9cc
	sw $t1, 7756($t0)
	li $t1, 0xefedee
	sw $t1, 7764($t0)
	li $t1, 0xf29cb5
	sw $t1, 7768($t0)
	li $t1, 0xff93b3
	sw $t1, 7772($t0)
	sw $t1, 7776($t0)
	sw $t1, 7780($t0)
	sw $t1, 7784($t0)
	li $t1, 0xfdbed1
	sw $t1, 7788($t0)
	li $t1, 0xff93b3
	sw $t1, 7812($t0)
	sw $t1, 7816($t0)
	sw $t1, 7820($t0)
	sw $t1, 7824($t0)
	sw $t1, 7828($t0)
	sw $t1, 7832($t0)
	sw $t1, 7836($t0)
	sw $t1, 7840($t0)
	sw $t1, 7844($t0)
	li $t1, 0xf39bb4
	sw $t1, 7856($t0)
	li $t1, 0xff93b3
	sw $t1, 7860($t0)
	sw $t1, 7864($t0)
	sw $t1, 7868($t0)
	sw $t1, 7872($t0)
	li $t1, 0xf5eaee
	sw $t1, 7880($t0)
	li $t1, 0xff93b3
	sw $t1, 7884($t0)
	sw $t1, 7888($t0)
	sw $t1, 7892($t0)
	li $t1, 0xfd94b3
	sw $t1, 7984($t0)
	sw $t1, 7988($t0)
	sw $t1, 7992($t0)
	sw $t1, 7996($t0)
	sw $t1, 8000($t0)
	syscall
	sw $t1, 8004($t0)
	sw $t1, 8008($t0)
	sw $t1, 8028($t0)
	sw $t1, 8032($t0)
	sw $t1, 8036($t0)
	sw $t1, 8040($t0)
	sw $t1, 8068($t0)
	sw $t1, 8072($t0)
	sw $t1, 8076($t0)
	sw $t1, 8080($t0)
	sw $t1, 8084($t0)
	sw $t1, 8088($t0)
	sw $t1, 8092($t0)
	sw $t1, 8096($t0)
	sw $t1, 8116($t0)
	sw $t1, 8120($t0)
	li $t1, 0xff93b3
	sw $t1, 8124($t0)
	li $t1, 0xfff3fc
	sw $t1, 8140($t0)
	li $t1, 0xfe95b4
	sw $t1, 8144($t0)
	li $t1, 0x000000
	sw $t1, 10296($t0)
	li $t1, 0x71360b
	sw $t1, 10300($t0)
	sw $t1, 10304($t0)
	li $t1, 0x000000
	sw $t1, 10312($t0)
	sw $t1, 10424($t0)
	li $t1, 0x71360b
	sw $t1, 10432($t0)
	sw $t1, 10436($t0)
	li $t1, 0x000000
	sw $t1, 10440($t0)
	li $t1, 0x71360b
	sw $t1, 10552($t0)
	li $t1, 0x000000
	sw $t1, 10556($t0)
	li $t1, 0x71360b
	sw $t1, 10560($t0)
	li $t1, 0x000000
	sw $t1, 10564($t0)
	sw $t1, 10684($t0)
	li $t1, 0x71360b
	sw $t1, 10688($t0)
	li $t1, 0x000000
	sw $t1, 10692($t0)
	li $t1, 0x71360b
	sw $t1, 10696($t0)
	sw $t1, 10804($t0)
	sw $t1, 10808($t0)
	li $t1, 0xffffff
	sw $t1, 10812($t0)
	li $t1, 0x71360b
	sw $t1, 10816($t0)
	li $t1, 0xffffff
	sw $t1, 10820($t0)
	li $t1, 0x71360b
	sw $t1, 10824($t0)
	sw $t1, 10936($t0)
	li $t1, 0xffffff
	sw $t1, 10940($t0)
	li $t1, 0x71360b
	sw $t1, 10944($t0)
	li $t1, 0xffffff
	sw $t1, 10948($t0)
	li $t1, 0x71360b
	sw $t1, 10952($t0)
	sw $t1, 10956($t0)
	sw $t1, 11060($t0)
	sw $t1, 11064($t0)
	sw $t1, 11068($t0)
	sw $t1, 11072($t0)
	sw $t1, 11076($t0)
	sw $t1, 11080($t0)
	sw $t1, 11192($t0)
	sw $t1, 11196($t0)
	sw $t1, 11200($t0)
	syscall
	sw $t1, 11204($t0)
	sw $t1, 11208($t0)
	sw $t1, 11212($t0)
	li $t1, 0xc88b5f
	sw $t1, 11324($t0)
	sw $t1, 11328($t0)
	sw $t1, 11456($t0)
	sw $t1, 11460($t0)
	li $t1, 0x000000
	sw $t1, 11580($t0)
	li $t1, 0xc88b5f
	sw $t1, 11584($t0)
	li $t1, 0x000000
	sw $t1, 11588($t0)
	li $t1, 0xffcc80
	sw $t1, 11616($t0)
	li $t1, 0xf44336
	sw $t1, 11624($t0)
	li $t1, 0xffffff
	sw $t1, 11628($t0)
	li $t1, 0xf3cd0e
	sw $t1, 11664($t0)
	li $t1, 0xff80ab
	sw $t1, 11672($t0)
	li $t1, 0xffffff
	sw $t1, 11676($t0)
	li $t1, 0xec407a
	sw $t1, 11680($t0)
	sw $t1, 11684($t0)
	li $t1, 0x000000
	sw $t1, 11708($t0)
	li $t1, 0xc88b5f
	sw $t1, 11712($t0)
	li $t1, 0x000000
	sw $t1, 11716($t0)
	li $t1, 0xf44336
	sw $t1, 11868($t0)
	li $t1, 0xffcc80
	sw $t1, 11872($t0)
	sw $t1, 11876($t0)
	li $t1, 0xf44336
	sw $t1, 11880($t0)
	li $t1, 0x304ffe
	sw $t1, 11884($t0)
	sw $t1, 11888($t0)
	li $t1, 0xe4a449
	sw $t1, 11912($t0)
	li $t1, 0xf3cd0e
	sw $t1, 11916($t0)
	li $t1, 0xf85050
	sw $t1, 11920($t0)
	li $t1, 0xffebb4
	sw $t1, 11924($t0)
	li $t1, 0xff80ab
	sw $t1, 11928($t0)
	li $t1, 0xec407a
	sw $t1, 11932($t0)
	li $t1, 0xff80ab
	sw $t1, 11936($t0)
	li $t1, 0xec407a
	sw $t1, 11940($t0)
	li $t1, 0xf44336
	sw $t1, 12124($t0)
	li $t1, 0xffcc80
	sw $t1, 12128($t0)
	sw $t1, 12132($t0)
	li $t1, 0x304ffe
	sw $t1, 12136($t0)
	sw $t1, 12140($t0)
	li $t1, 0xe4a449
	sw $t1, 12168($t0)
	li $t1, 0xf3cd0e
	sw $t1, 12172($t0)
	li $t1, 0xffebb4
	sw $t1, 12176($t0)
	sw $t1, 12180($t0)
	li $t1, 0xff80ab
	sw $t1, 12184($t0)
	li $t1, 0xec407a
	sw $t1, 12188($t0)
	li $t1, 0xff80ab
	sw $t1, 12192($t0)
	li $t1, 0xec407a
	sw $t1, 12196($t0)
	li $t1, 0xf44336
	sw $t1, 12380($t0)
	li $t1, 0x795548
	sw $t1, 12384($t0)
	li $t1, 0xffcc80
	sw $t1, 12388($t0)
	li $t1, 0xf44336
	sw $t1, 12392($t0)
	li $t1, 0x304ffe
	sw $t1, 12396($t0)
	sw $t1, 12400($t0)
	syscall
	li $t1, 0xf3cd0e
	sw $t1, 12428($t0)
	sw $t1, 12432($t0)
	sw $t1, 12436($t0)
	li $t1, 0xff80ab
	sw $t1, 12440($t0)
	li $t1, 0xffffff
	sw $t1, 12444($t0)
	li $t1, 0xec407a
	sw $t1, 12448($t0)
	sw $t1, 12452($t0)
	li $t1, 0xf44336
	sw $t1, 12636($t0)
	li $t1, 0xffcc80
	sw $t1, 12640($t0)
	li $t1, 0xf44336
	sw $t1, 12648($t0)
	li $t1, 0xffffff
	sw $t1, 12652($t0)
	li $t1, 0xf85050
	sw $t1, 12680($t0)
	li $t1, 0xc0c0c0
	sw $t1, 12684($t0)
	li $t1, 0xf3cd0e
	sw $t1, 12688($t0)
	li $t1, 0xf85050
	sw $t1, 12692($t0)
	li $t1, 0xf3cd0e
	sw $t1, 12696($t0)
	li $t1, 0xec407a
	sw $t1, 12708($t0)
	li $t1, 0xf85050
	sw $t1, 12928($t0)
	sw $t1, 12936($t0)
	sw $t1, 12940($t0)
	sw $t1, 12944($t0)
	sw $t1, 12948($t0)
	sw $t1, 13180($t0)
	sw $t1, 13184($t0)
	sw $t1, 13188($t0)
	sw $t1, 13192($t0)
	sw $t1, 13196($t0)
	sw $t1, 13200($t0)
	syscall
	sw $t1, 13440($t0)
	sw $t1, 13444($t0)
	sw $t1, 13448($t0)
	sw $t1, 13452($t0)
	sw $t1, 13456($t0)
	sw $t1, 13460($t0)
	sw $t1, 13688($t0)
	sw $t1, 13692($t0)
	sw $t1, 13696($t0)
	sw $t1, 13700($t0)
	sw $t1, 13704($t0)
	sw $t1, 13708($t0)
	sw $t1, 13712($t0)
	sw $t1, 13716($t0)
	sw $t1, 13720($t0)
	sw $t1, 13724($t0)
	sw $t1, 13728($t0)
	sw $t1, 13940($t0)
	sw $t1, 13944($t0)
	sw $t1, 13948($t0)
	sw $t1, 13952($t0)
	sw $t1, 13956($t0)
	sw $t1, 13960($t0)
	sw $t1, 13964($t0)
	sw $t1, 13968($t0)
	sw $t1, 13972($t0)
	sw $t1, 13976($t0)
	sw $t1, 14196($t0)
	sw $t1, 14200($t0)
	syscall
	sw $t1, 14204($t0)
	sw $t1, 14208($t0)
	sw $t1, 14212($t0)
	sw $t1, 14216($t0)
	sw $t1, 14220($t0)
	sw $t1, 14224($t0)
	sw $t1, 14228($t0)
	sw $t1, 14232($t0)
	sw $t1, 14456($t0)
	sw $t1, 14460($t0)
	sw $t1, 14464($t0)
	sw $t1, 14468($t0)
	sw $t1, 14472($t0)
	sw $t1, 14476($t0)
	sw $t1, 14480($t0)
	sw $t1, 14484($t0)
	sw $t1, 14488($t0)
	sw $t1, 14492($t0)
	sw $t1, 14716($t0)
	sw $t1, 14724($t0)
	sw $t1, 14728($t0)
	sw $t1, 14732($t0)
	sw $t1, 14740($t0)
	sw $t1, 14980($t0)
	sw $t1, 14984($t0)
	sw $t1, 14988($t0)
	sw $t1, 15232($t0)
	sw $t1, 15236($t0)

	jr $ra


#### DRAW BOWSER ####
# function draw_bowser():
# this function draws bowser onto the screen	
draw_bowser:
	la $s3, 8820($t0)
    li $t1, 0x780f0f
    sw $t1, 32($s3)
    sw $t1, 284($s3)
    li $t1, 0xb71c1c
    sw $t1, 288($s3)
    li $t1, 0x780f0f
    sw $t1, 292($s3)
    sw $t1, 296($s3)
    li $t1, 0xe6e3e6
    sw $t1, 312($s3)
    li $t1, 0xffffff
    sw $t1, 324($s3)
    li $t1, 0xb71c1c
    sw $t1, 540($s3)
    sw $t1, 544($s3)
    sw $t1, 548($s3)
    li $t1, 0x780f0f
    sw $t1, 552($s3)
    li $t1, 0xbdbdbd
    sw $t1, 564($s3)
    sw $t1, 568($s3)
    sw $t1, 576($s3)
    li $t1, 0xffffff
    sw $t1, 580($s3)
    li $t1, 0x757575
    sw $t1, 784($s3)
    li $t1, 0x3d2700
    sw $t1, 788($s3)
    li $t1, 0x780f0f
    sw $t1, 792($s3)
    sw $t1, 796($s3)
    li $t1, 0x3d2700
    sw $t1, 800($s3)
    li $t1, 0x780f0f
    sw $t1, 804($s3)
    sw $t1, 808($s3)
    li $t1, 0xe6e3e6
    sw $t1, 812($s3)
    li $t1, 0x1b5e20
    sw $t1, 820($s3)
    li $t1, 0x558b2f
    sw $t1, 824($s3)
    sw $t1, 828($s3)
    li $t1, 0xffab00
    sw $t1, 832($s3)
    li $t1, 0xffffff
    sw $t1, 844($s3)
    li $t1, 0xbdbdbd
    sw $t1, 848($s3)
    li $t1, 0x1b5e20
    sw $t1, 1044($s3)
    li $t1, 0x780f0f
    sw $t1, 1048($s3)
    li $t1, 0x558b2f
    sw $t1, 1052($s3)
    li $t1, 0x780f0f
    sw $t1, 1056($s3)
    sw $t1, 1060($s3)
    li $t1, 0xe6e3e6
    sw $t1, 1064($s3)
    li $t1, 0x999999
    sw $t1, 1068($s3)
    li $t1, 0x5c5c5c
    sw $t1, 1072($s3)
    li $t1, 0x33691e
    sw $t1, 1076($s3)
    sw $t1, 1080($s3)
    sw $t1, 1084($s3)
    sw $t1, 1088($s3)
    li $t1, 0x558b2f
    sw $t1, 1092($s3)
    li $t1, 0xbdbdbd
    sw $t1, 1096($s3)
    sw $t1, 1100($s3)
    li $t1, 0x999999
    sw $t1, 1104($s3)
    li $t1, 0x558b2f
    sw $t1, 1300($s3)
    li $t1, 0x64dd17
    sw $t1, 1304($s3)
    li $t1, 0x780f0f
    sw $t1, 1308($s3)
    li $t1, 0xb71c1c
    sw $t1, 1312($s3)
    li $t1, 0x780f0f
    sw $t1, 1316($s3)
    li $t1, 0x33691e
    sw $t1, 1320($s3)
    li $t1, 0x5c5c5c
    sw $t1, 1324($s3)
    li $t1, 0x202020
    sw $t1, 1328($s3)
    li $t1, 0xbdbdbd
    sw $t1, 1332($s3)
    sw $t1, 1336($s3)
    li $t1, 0x33691e
    sw $t1, 1340($s3)
    sw $t1, 1344($s3)
    li $t1, 0x64dd17
    sw $t1, 1348($s3)
    li $t1, 0x558b2f
    sw $t1, 1352($s3)
    li $t1, 0xffab00
    sw $t1, 1356($s3)
    li $t1, 0xff6f00
    sw $t1, 1360($s3)
    li $t1, 0xa66c07
    sw $t1, 1552($s3)
    sw $t1, 1556($s3)
    li $t1, 0x33691e
    sw $t1, 1560($s3)
    li $t1, 0x780f0f
    sw $t1, 1564($s3)
    li $t1, 0xffffff
    sw $t1, 1568($s3)
    li $t1, 0x558b2f
    sw $t1, 1572($s3)
    li $t1, 0x33691e
    sw $t1, 1576($s3)
    li $t1, 0xd6ae69
    sw $t1, 1580($s3)
    sw $t1, 1584($s3)
    li $t1, 0xbdbdbd
    sw $t1, 1588($s3)
    sw $t1, 1592($s3)
    li $t1, 0xe6e3e6
    sw $t1, 1596($s3)
    li $t1, 0xffffff
    sw $t1, 1600($s3)
    li $t1, 0xe6e3e6
    sw $t1, 1604($s3)
    li $t1, 0x558b2f
    sw $t1, 1608($s3)
    li $t1, 0x33691e
    sw $t1, 1612($s3)
    li $t1, 0x1b5e20
    sw $t1, 1616($s3)
    li $t1, 0xa66c07
    sw $t1, 1800($s3)
    li $t1, 0xffd180
    sw $t1, 1804($s3)
    li $t1, 0xa66c07
    sw $t1, 1808($s3)
    li $t1, 0xffd180
    sw $t1, 1812($s3)
    sw $t1, 1816($s3)
    li $t1, 0xa66c07
    sw $t1, 1820($s3)
    li $t1, 0xd6ae69
    sw $t1, 1824($s3)
    li $t1, 0xffd180
    sw $t1, 1828($s3)
    sw $t1, 1832($s3)
    li $t1, 0xd6ae69
    sw $t1, 1836($s3)
    sw $t1, 1840($s3)
    sw $t1, 1844($s3)
    li $t1, 0x000000
    sw $t1, 1848($s3)
    li $t1, 0x6b3900
    sw $t1, 1852($s3)
    sw $t1, 1856($s3)
    li $t1, 0xbdbdbd
    sw $t1, 1860($s3)
    li $t1, 0xffffff
    sw $t1, 1864($s3)
    li $t1, 0x33691e
    sw $t1, 1868($s3)
    sw $t1, 1872($s3)
    li $t1, 0xbdbdbd
    sw $t1, 1876($s3)
    li $t1, 0x999999
    sw $t1, 1880($s3)
    li $t1, 0xa66c07
    sw $t1, 2056($s3)
    li $t1, 0xffd180
    sw $t1, 2060($s3)
    sw $t1, 2064($s3)
    sw $t1, 2068($s3)
    sw $t1, 2072($s3)
    sw $t1, 2076($s3)
    sw $t1, 2080($s3)
    sw $t1, 2084($s3)
    sw $t1, 2088($s3)
    li $t1, 0xd6ae69
    sw $t1, 2092($s3)
    sw $t1, 2096($s3)
    sw $t1, 2100($s3)
    li $t1, 0x000000
    sw $t1, 2104($s3)
    li $t1, 0x6b3900
    sw $t1, 2108($s3)
    li $t1, 0x000000
    sw $t1, 2112($s3)
    sw $t1, 2116($s3)
    li $t1, 0x757575
    sw $t1, 2120($s3)
    li $t1, 0xffffff
    sw $t1, 2124($s3)
    li $t1, 0x558b2f
    sw $t1, 2128($s3)
    li $t1, 0xff6f00
    sw $t1, 2132($s3)
    li $t1, 0xbdbdbd
    sw $t1, 2136($s3)
    li $t1, 0xa66c07
    sw $t1, 2316($s3)
    li $t1, 0xffd180
    sw $t1, 2320($s3)
    sw $t1, 2324($s3)
    sw $t1, 2328($s3)
    sw $t1, 2332($s3)
    sw $t1, 2336($s3)
    sw $t1, 2340($s3)
    sw $t1, 2344($s3)
    li $t1, 0xd6ae69
    sw $t1, 2348($s3)
    sw $t1, 2352($s3)
    li $t1, 0x000000
    sw $t1, 2356($s3)
    li $t1, 0x6b3900
    sw $t1, 2360($s3)
    li $t1, 0x402200
    sw $t1, 2364($s3)
    li $t1, 0x000000
    sw $t1, 2368($s3)
    li $t1, 0xffb300
    sw $t1, 2372($s3)
    sw $t1, 2376($s3)
    li $t1, 0x202020
    sw $t1, 2380($s3)
    li $t1, 0xffffff
    sw $t1, 2384($s3)
    li $t1, 0x1b5e20
    sw $t1, 2388($s3)
    li $t1, 0x999999
    sw $t1, 2392($s3)
    li $t1, 0xffffff
    sw $t1, 2396($s3)
    li $t1, 0x999999
    sw $t1, 2572($s3)
    li $t1, 0x3d2700
    sw $t1, 2576($s3)
    li $t1, 0xd6ae69
    sw $t1, 2580($s3)
    sw $t1, 2584($s3)
    li $t1, 0xa66c07
    sw $t1, 2588($s3)
    li $t1, 0x3d2700
    sw $t1, 2592($s3)
    sw $t1, 2596($s3)
    li $t1, 0xffd180
    sw $t1, 2600($s3)
    li $t1, 0xd6ae69
    sw $t1, 2604($s3)
    sw $t1, 2608($s3)
    li $t1, 0x000000
    sw $t1, 2612($s3)
    li $t1, 0x6b3900
    sw $t1, 2616($s3)
    li $t1, 0x000000
    sw $t1, 2620($s3)
    sw $t1, 2624($s3)
    li $t1, 0xffb300
    sw $t1, 2628($s3)
    sw $t1, 2632($s3)
    li $t1, 0xff8c00
    sw $t1, 2636($s3)
    li $t1, 0x000000
    sw $t1, 2640($s3)
    li $t1, 0x33691e
    sw $t1, 2644($s3)
    li $t1, 0x999999
    sw $t1, 2836($s3)
    sw $t1, 2840($s3)
    li $t1, 0xd32f2f
    sw $t1, 2844($s3)
    sw $t1, 2848($s3)
    li $t1, 0x999999
    sw $t1, 2852($s3)
    li $t1, 0xd6ae69
    sw $t1, 2856($s3)
    li $t1, 0x3d2700
    sw $t1, 2860($s3)
    li $t1, 0x000000
    sw $t1, 2864($s3)
    sw $t1, 2868($s3)
    li $t1, 0xffb300
    sw $t1, 2872($s3)
    li $t1, 0x999999
    sw $t1, 2876($s3)
    li $t1, 0xff8c00
    sw $t1, 2880($s3)
    sw $t1, 2884($s3)
    li $t1, 0xffb300
    sw $t1, 2888($s3)
    sw $t1, 2892($s3)
    sw $t1, 2896($s3)
    li $t1, 0x000000
    sw $t1, 2900($s3)
    li $t1, 0xffab00
    sw $t1, 2904($s3)
    li $t1, 0xffffff
    sw $t1, 2908($s3)
    li $t1, 0xffb300
    sw $t1, 3076($s3)
    li $t1, 0x6b3900
    sw $t1, 3080($s3)
    sw $t1, 3084($s3)
    li $t1, 0xffb300
    sw $t1, 3088($s3)
    li $t1, 0xd6ae69
    sw $t1, 3092($s3)
    li $t1, 0xffd180
    sw $t1, 3096($s3)
    li $t1, 0x5c5c5c
    sw $t1, 3100($s3)
    li $t1, 0x999999
    sw $t1, 3104($s3)
    li $t1, 0xffd180
    sw $t1, 3108($s3)
    li $t1, 0xd6ae69
    sw $t1, 3112($s3)
    li $t1, 0x000000
    sw $t1, 3116($s3)
    sw $t1, 3120($s3)
    li $t1, 0xffb300
    sw $t1, 3124($s3)
    sw $t1, 3128($s3)
    li $t1, 0x000000
    sw $t1, 3132($s3)
    li $t1, 0x995400
    sw $t1, 3136($s3)
    li $t1, 0xffb300
    sw $t1, 3140($s3)
    sw $t1, 3144($s3)
    sw $t1, 3148($s3)
    sw $t1, 3152($s3)
    li $t1, 0x000000
    sw $t1, 3156($s3)
    li $t1, 0xff6f00
    sw $t1, 3160($s3)
    li $t1, 0x6b3900
    sw $t1, 3328($s3)
    li $t1, 0xffb300
    sw $t1, 3332($s3)
    sw $t1, 3336($s3)
    li $t1, 0x402200
    sw $t1, 3340($s3)
    li $t1, 0xffb300
    sw $t1, 3344($s3)
    li $t1, 0xf2ad35
    sw $t1, 3348($s3)
    li $t1, 0xd6ae69
    sw $t1, 3352($s3)
    sw $t1, 3356($s3)
    li $t1, 0xffd180
    sw $t1, 3360($s3)
    sw $t1, 3364($s3)
    li $t1, 0xd6ae69
    sw $t1, 3368($s3)
    li $t1, 0x000000
    sw $t1, 3372($s3)
    li $t1, 0xffd180
    sw $t1, 3376($s3)
    li $t1, 0x3b2602
    sw $t1, 3380($s3)
    li $t1, 0x996b00
    sw $t1, 3384($s3)
    li $t1, 0xffb300
    sw $t1, 3388($s3)
    li $t1, 0x000000
    sw $t1, 3392($s3)
    li $t1, 0xff8c00
    sw $t1, 3396($s3)
    li $t1, 0xffb300
    sw $t1, 3400($s3)
    sw $t1, 3404($s3)
    sw $t1, 3408($s3)
    li $t1, 0x000000
    sw $t1, 3412($s3)
    li $t1, 0xffb300
    sw $t1, 3584($s3)
    li $t1, 0x996b00
    sw $t1, 3588($s3)
    li $t1, 0x5c4000
    sw $t1, 3592($s3)
    li $t1, 0x402200
    sw $t1, 3596($s3)
    li $t1, 0x5c4000
    sw $t1, 3600($s3)
    li $t1, 0x000000
    sw $t1, 3604($s3)
    sw $t1, 3608($s3)
    li $t1, 0x80683f
    sw $t1, 3612($s3)
    li $t1, 0x000000
    sw $t1, 3616($s3)
    sw $t1, 3620($s3)
    sw $t1, 3624($s3)
    li $t1, 0x997d4d
    sw $t1, 3628($s3)
    li $t1, 0xffd180
    sw $t1, 3632($s3)
    li $t1, 0xa66c07
    sw $t1, 3636($s3)
    li $t1, 0x231601
    sw $t1, 3640($s3)
    li $t1, 0x000000
    sw $t1, 3644($s3)
    li $t1, 0xffffff
    sw $t1, 3648($s3)
    li $t1, 0x000000
    sw $t1, 3652($s3)
    sw $t1, 3656($s3)
    li $t1, 0xffb300
    sw $t1, 3660($s3)
    sw $t1, 3664($s3)
    li $t1, 0x000000
    sw $t1, 3668($s3)
    li $t1, 0x996b00
    sw $t1, 3840($s3)
    li $t1, 0xffb300
    sw $t1, 3844($s3)
    li $t1, 0x996b00
    sw $t1, 3848($s3)
    li $t1, 0x261400
    sw $t1, 3852($s3)
    li $t1, 0x5c5c5c
    sw $t1, 3856($s3)
    li $t1, 0x000000
    sw $t1, 3860($s3)
    sw $t1, 3864($s3)
    li $t1, 0x3d2700
    sw $t1, 3868($s3)
    li $t1, 0xd6ae69
    sw $t1, 3872($s3)
    sw $t1, 3876($s3)
    sw $t1, 3880($s3)
    li $t1, 0xa66c07
    sw $t1, 3884($s3)
    li $t1, 0xffd180
    sw $t1, 3888($s3)
    li $t1, 0x000000
    sw $t1, 3892($s3)
    li $t1, 0x6b3900
    sw $t1, 3896($s3)
    li $t1, 0xffb300
    sw $t1, 3900($s3)
    sw $t1, 3904($s3)
    li $t1, 0xff8c00
    sw $t1, 3908($s3)
    li $t1, 0x000000
    sw $t1, 3912($s3)
    sw $t1, 3916($s3)
    li $t1, 0xffb300
    sw $t1, 3920($s3)
    li $t1, 0x999999
    sw $t1, 3924($s3)
    li $t1, 0x6b3900
    sw $t1, 4096($s3)
    li $t1, 0x996b00
    sw $t1, 4100($s3)
    sw $t1, 4104($s3)
    li $t1, 0x402200
    sw $t1, 4108($s3)
    li $t1, 0x261400
    sw $t1, 4112($s3)
    li $t1, 0xa66c07
    sw $t1, 4128($s3)
    li $t1, 0xffd180
    sw $t1, 4132($s3)
    sw $t1, 4136($s3)
    sw $t1, 4140($s3)
    sw $t1, 4144($s3)
    li $t1, 0xff8c00
    sw $t1, 4148($s3)
    sw $t1, 4152($s3)
    li $t1, 0xffb300
    sw $t1, 4156($s3)
    sw $t1, 4160($s3)
    sw $t1, 4164($s3)
    sw $t1, 4168($s3)
    li $t1, 0x000000
    sw $t1, 4172($s3)
    sw $t1, 4176($s3)
    li $t1, 0xffb300
    sw $t1, 4356($s3)
    sw $t1, 4360($s3)
    li $t1, 0x402200
    sw $t1, 4364($s3)
    li $t1, 0x995400
    sw $t1, 4384($s3)
    li $t1, 0xa66c07
    sw $t1, 4388($s3)
    li $t1, 0xd6ae69
    sw $t1, 4392($s3)
    sw $t1, 4396($s3)
    li $t1, 0xa66c07
    sw $t1, 4400($s3)
    li $t1, 0xffb300
    sw $t1, 4404($s3)
    sw $t1, 4408($s3)
    li $t1, 0x6b3900
    sw $t1, 4412($s3)
    li $t1, 0xffb300
    sw $t1, 4416($s3)
    sw $t1, 4420($s3)
    sw $t1, 4424($s3)
    li $t1, 0xff8c00
    sw $t1, 4428($s3)
    li $t1, 0x000000
    sw $t1, 4432($s3)
    sw $t1, 4436($s3)
    li $t1, 0xffb300
    sw $t1, 4440($s3)
    li $t1, 0x6b3900
    sw $t1, 4636($s3)
    li $t1, 0xff8c00
    sw $t1, 4640($s3)
    li $t1, 0x995400
    sw $t1, 4644($s3)
    li $t1, 0xa66c07
    sw $t1, 4648($s3)
    li $t1, 0xffd180
    sw $t1, 4652($s3)
    sw $t1, 4656($s3)
    li $t1, 0x999999
    sw $t1, 4660($s3)
    li $t1, 0x402200
    sw $t1, 4664($s3)
    li $t1, 0xff8c00
    sw $t1, 4668($s3)
    li $t1, 0xffb300
    sw $t1, 4672($s3)
    sw $t1, 4676($s3)
    sw $t1, 4680($s3)
    li $t1, 0x995400
    sw $t1, 4684($s3)
    li $t1, 0x000000
    sw $t1, 4688($s3)
    li $t1, 0xffb300
    sw $t1, 4692($s3)
    li $t1, 0xff8c00
    sw $t1, 4696($s3)
    sw $t1, 4700($s3)
    li $t1, 0x995400
    sw $t1, 4892($s3)
    li $t1, 0xff8c00
    sw $t1, 4896($s3)
    sw $t1, 4900($s3)
    li $t1, 0x995400
    sw $t1, 4904($s3)
    li $t1, 0x3d2700
    sw $t1, 4908($s3)
    li $t1, 0xa66c07
    sw $t1, 4912($s3)
    sw $t1, 4916($s3)
    li $t1, 0x000000
    sw $t1, 4920($s3)
    sw $t1, 4924($s3)
    li $t1, 0x6b3900
    sw $t1, 4928($s3)
    li $t1, 0x402200
    sw $t1, 4932($s3)
    li $t1, 0x996b00
    sw $t1, 4936($s3)
    li $t1, 0xff8c00
    sw $t1, 4940($s3)
    li $t1, 0x212121
    sw $t1, 4944($s3)
    li $t1, 0x6b3900
    sw $t1, 4948($s3)
    sw $t1, 5152($s3)
    li $t1, 0xff8c00
    sw $t1, 5156($s3)
    sw $t1, 5160($s3)
    sw $t1, 5164($s3)
    li $t1, 0x995400
    sw $t1, 5168($s3)
    li $t1, 0xffb300
    sw $t1, 5180($s3)
    li $t1, 0x995400
    sw $t1, 5184($s3)
    li $t1, 0xffb300
    sw $t1, 5188($s3)
    sw $t1, 5192($s3)
    li $t1, 0xff8c00
    sw $t1, 5196($s3)
    li $t1, 0x6b3900
    sw $t1, 5404($s3)
    li $t1, 0xffb300
    sw $t1, 5408($s3)
    li $t1, 0x5c4000
    sw $t1, 5412($s3)
    li $t1, 0x995400
    sw $t1, 5416($s3)
    li $t1, 0xff8c00
    sw $t1, 5420($s3)
    sw $t1, 5424($s3)
    sw $t1, 5436($s3)
    li $t1, 0xffb300
    sw $t1, 5440($s3)
    sw $t1, 5444($s3)
    sw $t1, 5448($s3)
    sw $t1, 5452($s3)
    li $t1, 0xff8c00
    sw $t1, 5456($s3)
    li $t1, 0x373737
    sw $t1, 5660($s3)
    li $t1, 0xff8c00
    sw $t1, 5664($s3)
    li $t1, 0xffb300
    sw $t1, 5668($s3)
    sw $t1, 5672($s3)
    sw $t1, 5676($s3)
    li $t1, 0x995400
    sw $t1, 5680($s3)
    li $t1, 0xffb300
    sw $t1, 5692($s3)
    sw $t1, 5696($s3)
    sw $t1, 5700($s3)
    sw $t1, 5704($s3)
    sw $t1, 5708($s3)
    li $t1, 0xff8c00
    sw $t1, 5712($s3)
    li $t1, 0x999999
    sw $t1, 5920($s3)
    li $t1, 0xff8c00
    sw $t1, 5924($s3)
    sw $t1, 5928($s3)
    li $t1, 0x999999
    sw $t1, 5948($s3)
    li $t1, 0x5c5c5c
    sw $t1, 5952($s3)
    li $t1, 0xffffff
    sw $t1, 5956($s3)
    li $t1, 0xff8c00
    sw $t1, 5960($s3)
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

###### DRAW_SIGN ######
# function draw_sign(int a):
# a is the starting offset of the sign
# this function draws a sign at a given offset
draw_sign_a:

	lw $s4, 0($sp)		# pop a
	add $s3, $t0, $s4	# la $s3, a($t0)
	li $t1, SIGN1
	sw $t1, -516($s3)
	sw $t1, -260($s3)
	sw $t1, -256($s3)
	sw $t1, -4($s3)
	sw $t1, 0($s3)
	sw $t1, 252($s3)
	li $t1, SIGN2
	sw $t1, 4($s3)
	sw $t1, 256($s3)
	sw $t1, 508($s3)
	
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
	sw $t1, -4($t3)
	sw $t1, -8($t3)
	sw $t1, -260($t3)
	sw $t1, -252($t3)
	sw $t1, -264($t3)
	sw $t1, -268($t3)
	li $t1, MARIO1
	sw $t1, -520($t3)
	sw $t1, -512($t3)
	sw $t1, -516($t3)
	sw $t1, -508($t3)
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
	li $t1, MARIO5
	sw $t1, -1024($t3)
	sw $t1, -1536($t3)
	sw $t1, -1792($t3)
	
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
	#li $t1, WHITE
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
 	lw $s6, 0($sp)	# pop b
 	lw $s4, 4($sp)	# pop a
 	
	add $s4, $t0, $s4
	addi $s3, $zero, 0
	
create_loop1:
	bgt $s3, $s6, create_end
	addi $s4, $s4, 4
	sw $t1, 0($s4)
	sw $t1, 256($s4)
	addi $s3, $s3, 1
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
	
	# check bowser colors (could also use loop instead)
	beq $s2, BOWSER6, u_bowser
	beq $s2, BOWSER8, u_bowser
	beq $s2, BOWSER3, u_bowser
	beq $s2, BOWSER9, u_bowser
	beq $s2, BOWSER7, u_bowser
	beq $s2, BOWSER10, u_bowser
	beq $s2, BOWSER5, u_bowser
	beq $s2, BOWSER4, u_bowser
	beq $s2, BOWSER2, u_bowser
	beq $s2, BOWSER1, u_bowser
	beq $s2, BOWSER11, u_bowser

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
	
	# increment num_enemy_killed
	la $t1, num_enemy_killed
	lw $t4, 0($t1)
	addi $t4, $t4, 1
	sw $t4, 0($t1)

	# removes it from screen
	li $t1, BLUE_SKY
	lw $t4, 0($t3)		# load address of bullet
	sw $t1, 0($t4)
	
	# deletes goomba
u_delete_goom:
	la $s5, enemy_array
	la $s6, total_num_enemy
	lw $s6, 0($s6)
	la $s7, current_level
	lw $s7, 0($s7)

	lw $t4, 0($t3)		# load address of bullet
	# calculate offset of bullet
	sub $t1, $t4, $t0	# $t1 is the offset
	
	li $s0, 0
u_delete_l:
	bge $s0, $s6, u_delete_l_end

	lw $s3, 8($s5)		# load level of enemy to $s3

	bne $s3, $s7, u_delete_else		# skip if current_level != enemy level
	
	lw $s3, 0($s5)		# load offset of enemy to $s3
	

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
	addi $s5, $s5, 12
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

u_bowser:
	# deletes bullet
	li $t1, 1
	sw $t1, 8($t3)		# change value of deleted in bullet to be 1
	
	# removes it from screen
	li $t1, BLUE_SKY
	lw $t4, 0($t3)		# load address of bullet
	sw $t1, 0($t4)

	# decrement bowser health
	la $t1, bowser_health
	lw $t4, 0($t1)
	addi $t4, $t4, -1
	sw $t4, 0($t1)

	# increment loop variables
	addi $t3, $t3, 12
	addi $t8, $t8, 1
	j u_l1

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

##### UPDATE ENEMY BULLETS #####
# function update_enemy_bullets()
# moves the enemy bullets
# if bullet collides with an object, perform action depending on the object
update_enemy_bullets:
	la $t3, enemy_bullet_array
	la $s1, num_enemy_bullets
	lw $s1, 0($s1)
	
	add $t8, $zero, $zero
ue_l1:	bge $t8, $s1, ue_el1
	
	lw $t4, 0($t3)		# load address of bullet
	
	lw $s2, -4($t4)		# load color into $s2 at the address - 4 in $t4 (checks the left pixel)

	# branch depending on the color
ue_else1:	
	
	# check peach colors (could also use loop instead)
	beq $s2, PEACH2, ue_peach
	beq $s2, PEACH5, ue_peach
	beq $s2, PEACH4, ue_peach
	beq $s2, PEACH3, ue_peach
	beq $s2, PEACH1, ue_peach

	# check if bullet hits edges
	lw $s2, 0($t3)		# load address of bullet
	sub $s2, $s2, $t0	# gets index of bullet
	li $s4, 4
	div $s2, $s2, $s4
	li $s4, 64
	div $s2, $s4
	mfhi $s2		# $s2 = $s2 mod 64
	
	beqz $s2, ue_wall	# far left wall
	beq $s2, 63, ue_wall	# far right wall
	
	j ue_cont
	
ue_wall:	
	# deletes bullet
	li $t1, 1
	sw $t1, 4($t3)		# change value of deleted in bullet to be 1
	
	# removes it from screen
	li $t1, BLUE_SKY
	lw $t4, 0($t3)		# load address of bullet
	sw $t1, 0($t4)
	
	# increment loop variables
	addi $t3, $t3, 8
	addi $t8, $t8, 1
	j ue_l1
	
ue_peach:
	# deletes bullet
	li $t1, 1
	sw $t1, 4($t3)		# change value of deleted in bullet to be 1
	
	# removes it from screen
	li $t1, BLUE_SKY
	lw $t4, 0($t3)		# load address of bullet
	sw $t1, 0($t4)

	# decrement peach health
	la $t1, num_hearts
	lw $t4, 0($t1)
	addi $t4, $t4, -1
	sw $t4, 0($t1)

	# increment loop variables
	addi $t3, $t3, 8
	addi $t8, $t8, 1
	j ue_l1

ue_cont:	
	li $t1, BLUE_SKY
	sw $t1, 0($t4)
	addi $t4, $t4, -4
	
ue_else:
	sw $t4, 0($t3)		# store address of bullet
	
	li $t1, BOWSER_BULLET
	sw $t1, 0($t4)
	
	addi $t3, $t3, 8
	addi $t8, $t8, 1
	j ue_l1
	
ue_el1:	jr $ra

##### DELETE ENEMY BULLETS #####
# function delete_enemy_bullets()
# deletes the enemy bullets that were deleted when update_enemy_bullets() was called.
delete_enemy_bullets:
	la $t3, enemy_bullet_array
	la $s3, enemy_bullet_array	# $s3 is the address we put the non-deleted bullets into (it replaces the bullets)
	la $s1, num_enemy_bullets
	lw $s1, 0($s1)
	
	li $s0, 0		# $s0 counts the number of non-deleted bullets
	
	li $t8, 0
deb_l1:	bge $t8, $s1, deb_end	# loops through the bullets in enemy_bullet_array
	
	lw $t4, 4($t3)		# load deleted value of bullet
	
	bnez $t4, deb_if1_cont 
deb_if1_z:	
	lw $s4, 0($t3)		# load address of bullet
	lw $s5, 4($t3)		# load deleted value of bullet
	
	sw $s4, 0($s3)		# store address of bullet
	sw $s5, 4($s3)		# store deleted value of bullet
	
	addi $s3, $s3, 8
	addi $s0, $s0, 1	# increment $s0 count

deb_if1_cont:
	addi $t3, $t3, 8
	addi $t8, $t8, 1
	j deb_l1
	
deb_end:
	la $s1, num_enemy_bullets
	sw $s0, 0($s1)
	jr $ra


###### PAINT SKY BLUE #####
# function paint_sky()
# this function paints the sky
paint_sky:
   	li $t1, BLUE_SKY   	# $t1 stores the blue colour code 
	li $t3, 3712
	add $s6, $zero, $zero
	la, $s7, ($t0)
	
paint_sky_l: 	bge $s6, $t3, paint_sky_end
	sw $t1, 0($s7)
	addi $s7, $s7, 4
	addi $s6, $s6, 1
	j paint_sky_l
paint_sky_end:

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
   	jal paint_sky

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
	
##### Draw goombas according to the enemy_array and their level #####
draw_goombas:
	la $t3, enemy_array
	la $s1, total_num_enemy
	lw $s1, 0($s1)
	la $s0, current_level
	lw $s0, 0($s0)
	
	add $t8, $zero, $zero
draw_goom_l:	
	bge $t8, $s1, draw_goom_l_end
	lw $s3, 8($t3)		# load level of enemy

	bne $s3, $s0, draw_goom_cont		# if enemy level != current_level, dont draw goomba
	
	lw $t4, 0($t3)		# load offset of enemy
	lw $s4, 4($t3)		# load deleted of enemy
	
	beq $s4, 1, draw_goom_cont # doesn't draw the goomba if deleted == 1
	# paint goomba
	addi $sp, $sp, -4
	sw $t4, 0($sp)
	jal draw_goomba_a
	
draw_goom_cont:	
	addi $t3, $t3, 12
	addi $t8, $t8, 1
	
	j draw_goom_l
draw_goom_l_end:

##### draw mario #####

	la $t3, current_level
	lw $t3, 0($t3)

	bne $t3, 4, draw_mario_else		# skips if current_level != 4

	##### does the following if current_level == 4

	# paint mario
	addi $t8, $zero, 14056
	addi $sp, $sp, -4
	sw $t8, 0($sp)
	jal draw_mario_a

##### draw Bowser #####
	la $t3, bowser_health
	lw $t3, 0($t3)
	beq $t3, 0, bowser_clear		# clear bowser if bowser health <= 0
	j possibly_draw_bowser
bowser_clear:
	jal paint_sky
	la $t1, bowser_health
	li $t3, -1
	sw $t3, 0($t1)
	j draw_mario_else

possibly_draw_bowser:
	ble $t3, 0, draw_mario_else		# skips if bowser health <= 0
	jal draw_bowser

draw_mario_else:
	
##### draw player #####
	# paint player
	jal draw_player
	
##### DRAW HEARTS #####

	li $t4, 1460
	li $s3, 3
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

	li $t4, 1460
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

##### Draw platforms according to the platform_array and their level #####

draw_platforms:
	la $t3, platform_array
	la $s1, total_platforms
	lw $s1, 0($s1)
	la $s0, current_level
	lw $s0, 0($s0)
	
	add $t8, $zero, $zero
draw_platform_l:	
	bge $t8, $s1, draw_platform_l_end
	lw $s3, 8($t3)		# load level of platform

	bne $s3, $s0, draw_platform_cont		# if platform level != current_level, dont draw platform
	
	lw $t4, 0($t3)		# load offset of platform
	lw $s4, 4($t3)		# load length of platform
	
	addi $sp, $sp, -4
	sw $t4, 0($sp)
	addi $sp, $sp, -4
	sw $s4, 0($sp)
	jal create_platform_a_b	
draw_platform_cont:	
	addi $t3, $t3, 12
	addi $t8, $t8, 1
	
	j draw_platform_l
draw_platform_l_end:

##### Draw sign if all enemies die in the current level #####

	la $t8, num_enemy_killed
	la $t3, current_level
	lw $t3, 0($t3)
	lw $t8, 0($t8)
	add $t8, $t8, $t3

draw_sign_if:
	beq $t8, 4, draw_sign		# draws the sign if 3 enemies are killed so far (first level finished) && current_level == 1
	beq $t8, 9, draw_sign
	beq $t8, 13, draw_sign
	j draw_sign_else

draw_sign:
	addi $t8, $zero, 13796
	addi $sp, $sp, -4
	sw $t8, 0($sp)
	jal draw_sign_a

draw_sign_else:

##### update player bullets #####
	
	jal update_player_bullets
	jal delete_player_bullets

##### shoot bowser bullets #####

	li $v0, 42			# generate psuedo random int with syscall 42 
	li $a0, 0 
	li $a1, 20 			# int is between 0<= $a0 <= 15
	syscall 

	move $t1, $a0

	bne $t1, 3, ueb_else			# timing loop, the higher the value we compare $t1 to, the longer it takes to shoot

	la $t4, current_level
	lw $t4, 0($t4)
	bne $t4, 4, ueb_else			# only shoot bullets when current_level == 4

	la $t4, bowser_health
	lw $t4, 0($t4)
	ble $t4, 0, ueb_else			# doesn't shoot if bowser_health <= 0

	la $t4, num_enemy_bullets
	lw $t4, 0($t4)
	bgt $t4, 10, ueb_else			# doesn't shoot if num_enemy_bullets > 10

	li $v0, 42			# generate psuedo random int with syscall 42 
	li $a0, 0 
	li $a1, 15 			# int is between 0<= $a0 <= 15
	syscall 

	move $t3, $a0
	sll $t3, $t3, 8		# multiply value by 2^8 = 256

	la $t4, 10092($t0)
	add $t4, $t4, $t3

	li $t1, BOWSER_BULLET
	sw $t1, 0($t4)

store_to_enemy_array:
	la $t3, enemy_bullet_array
	la $t1, num_enemy_bullets
	lw $t1, 0($t1)
	
	add $t8, $zero, $zero
ueb_l1:	bge $t8, $t1, ueb_el1
	addi $t3, $t3, 8
	addi $t8, $t8, 1
	j ueb_l1
	
ueb_el1:
	sw $t4, 0($t3)		# store address of bullet
	sw $zero, 4($t3)	# store value of deleted to 0 of current bullet
	
	la $t1, num_enemy_bullets
	lw $t4, 0($t1)
	addi $t4, $t4, 1	# add 1 to total num_enemy_bullets
	sw $t4, 0($t1)

ueb_else:

##### update enemy bullets #####
	
	jal update_enemy_bullets
	jal delete_enemy_bullets

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
	la $t4, num_enemy_bullets
	sw $zero, 0($t4)
	la $t4, jump_count
	sw $zero, 0($t4)
	li $t3, 1
	la $t4, current_level
	sw $t3, 0($t4)
	la $t4, num_hearts
	li $t3, 3
	sw $t3, 0($t4)
	la $t4, num_enemy_killed
	sw $zero, 0($t4)
	la $t4, bowser_health
	li $t3, 10
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
	
	addi $s5, $s5, 12
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
	
	# check if goomba
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

	# check if mario
	li $t1, MARIO1	# checks if moving left will collide with mario
	
	lw $t3, -16($t4)
	beq $t1, $t3, a_mario_hit
	lw $t3, -20($t4)
	beq $t1, $t3, a_mario_hit
	lw $t3, -528($t4)
	beq $t1, $t3, a_mario_hit
	lw $t3, -532($t4)
	beq $t1, $t3, a_mario_hit
	lw $t3, 496($t4)
	beq $t1, $t3, a_mario_hit
	lw $t3, 492($t4)
	beq $t1, $t3, a_mario_hit
	lw $t3, 1008($t4)
	beq $t1, $t3, a_mario_hit
	lw $t3, 1004($t4)
	bne $t1, $t3, a_if2
	
a_mario_hit:
	j limbo	

a_if2:	

	li $t1, SIGN1	# checks if moving left will collide with sign
	
	lw $t3, 16($t4)
	beq $t1, $t3, a_sign_hit
	lw $t3, 20($t4)
	beq $t1, $t3, a_sign_hit
	lw $t3, 528($t4)
	beq $t1, $t3, a_sign_hit
	lw $t3, 532($t4)
	beq $t1, $t3, a_sign_hit
	lw $t3, -496($t4)
	beq $t1, $t3, a_sign_hit
	lw $t3, -492($t4)
	beq $t1, $t3, a_sign_hit
	lw $t3, 1040($t4)
	beq $t1, $t3, a_sign_hit
	lw $t3, 1044($t4)
	bne $t1, $t3, a_if3

a_sign_hit:
	# increment to current_level
	la $t3, current_level
	lw $t1, 0($t3)
	addi $t1, $t1, 1
	sw $t1, 0($t3)

	# move player back to original beginning position
	la $t2, player
 	la $t3, 13840($t0)	# Player beginning position
	sw $t3, 0($t2)		# stores position address into player struct
	addi $t3, $zero, 3460
	sw $t3, 4($t2)

	jal clear_player
	jal draw_player
	jal paint_sky
	j key_no_clicked

a_if3:

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

	li $t1, MARIO1	# checks if moving right will collide with mario
	
	lw $t3, 16($t4)
	beq $t1, $t3, d_mario_hit
	lw $t3, 20($t4)
	beq $t1, $t3, d_mario_hit
	lw $t3, 528($t4)
	beq $t1, $t3, d_mario_hit
	lw $t3, 532($t4)
	beq $t1, $t3, d_mario_hit
	lw $t3, -496($t4)
	beq $t1, $t3, d_mario_hit
	lw $t3, -492($t4)
	beq $t1, $t3, d_mario_hit
	lw $t3, 1040($t4)
	beq $t1, $t3, d_mario_hit
	lw $t3, 1044($t4)
	bne $t1, $t3, d_if2
d_mario_hit:
	j limbo
	# j key_no_clicked (should say this, but since we j limbo, we dont need this line)

d_if2:	
	
	li $t1, SIGN1	# checks if moving right will collide with sign
	
	lw $t3, 16($t4)
	beq $t1, $t3, d_sign_hit
	lw $t3, 20($t4)
	beq $t1, $t3, d_sign_hit
	lw $t3, 528($t4)
	beq $t1, $t3, d_sign_hit
	lw $t3, 532($t4)
	beq $t1, $t3, d_sign_hit
	lw $t3, -496($t4)
	beq $t1, $t3, d_sign_hit
	lw $t3, -492($t4)
	beq $t1, $t3, d_sign_hit
	lw $t3, 1040($t4)
	beq $t1, $t3, d_sign_hit
	lw $t3, 1044($t4)
	bne $t1, $t3, d_if3

d_sign_hit:
	# increment to current_level
	la $t3, current_level
	lw $t1, 0($t3)
	addi $t1, $t1, 1
	sw $t1, 0($t3)

	# move player back to original beginning position
	la $t2, player
 	la $t3, 13840($t0)	# Player beginning position
	sw $t3, 0($t2)		# stores position address into player struct
	addi $t3, $zero, 3460
	sw $t3, 4($t2)

	jal clear_player
	jal draw_player
	jal paint_sky
	j key_no_clicked

d_if3:

	la $s4, bowser_colors
	li $t8, 1

d_bowser_l:
	bge $t8, 11, d_if4

	lw $t1, 0($s4)				# checks if moving right will collide with bowser
	
	lw $t3, 16($t4)
	beq $t1, $t3, d_bowser_hit
	lw $t3, 20($t4)
	beq $t1, $t3, d_bowser_hit
	lw $t3, 528($t4)
	beq $t1, $t3, d_bowser_hit
	lw $t3, 532($t4)
	beq $t1, $t3, d_bowser_hit
	lw $t3, -496($t4)
	beq $t1, $t3, d_bowser_hit
	lw $t3, -492($t4)
	beq $t1, $t3, d_bowser_hit
	lw $t3, 1040($t4)
	beq $t1, $t3, d_bowser_hit
	lw $t3, 1044($t4)
	addi $s4, $s4, 4			# move to next word
	addi $t8, $t8, 1
	bne $t1, $t3, d_bowser_l
	
d_bowser_hit:
	la $t1, num_hearts
	lw $s4, 0($t1)
	addi $s4, $s4, -2
	sw $s4, 0($t1)
	j key_no_clicked
	
d_if4:	


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

	blt $t5, 15, key_no_clicked			# timing loop, the higher the value we compare $t5 to, the longer it takes to shoot
	li $t5, 1

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
	#beq $t1, $t3, grounded
	#lw $t3, 1276($t4)
	#beq $t1, $t3, grounded
	#lw $t3, 1284($t4)
	#beq $t1, $t3, grounded
	#lw $t3, 1292($t4)
	bne $t1, $t3, no_key_if1	

no_key_if1:	
	
	li $t1, SIGN1	# checks if moving up will collide with sign
	
	lw $t3, 1020($t4)
	beq $t1, $t3, no_key_sign_hit
	lw $t3, 1028($t4)
	beq $t1, $t3, no_key_sign_hit
	lw $t3, 1036($t4)
	beq $t1, $t3, no_key_sign_hit
	lw $t3, 1012($t4)
	beq $t1, $t3, no_key_sign_hit
	lw $t3, 1268($t4)
	#beq $t1, $t3, no_key_sign_hit
	#lw $t3, 1276($t4)
	#beq $t1, $t3, no_key_sign_hit
	#lw $t3, 1284($t4)
	#beq $t1, $t3, no_key_sign_hit
	#lw $t3, 1292($t4)
	bne $t1, $t3, no_key_if2	

no_key_sign_hit:
	# increment to current_level
	la $t3, current_level
	lw $t1, 0($t3)
	addi $t1, $t1, 1
	sw $t1, 0($t3)

	# move player back to original beginning position
	la $t2, player
 	la $t3, 13840($t0)	# Player beginning position
	sw $t3, 0($t2)		# stores position address into player struct
	addi $t3, $zero, 3460
	sw $t3, 4($t2)

	jal clear_player
	jal draw_player
	jal paint_sky
	j grounded

no_key_if2:	
	
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
	
do_grav:

	lw $t4, 4($t2) 	# retrives index of player
	addi $t4, $t4, 64
	sw $t4, 4($t2)

	jal clear_player
	lw $t4, 0($t2) 	# retrives position address of player
	addi $t4, $t4, 256
	sw $t4, 0($t2)
	jal draw_player
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

	# if num_hearts <0 , game is over
	la $s3, num_hearts
	lw $s3, 0($s3)
	bgt $s3, 0, limbo_yw
	jal draw_game_over
	j limbo_l

limbo_yw:
	jal draw_you_win

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

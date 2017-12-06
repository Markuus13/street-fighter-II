## SRAM Mapping ##
.eqv SRAM_INI_ADDR 		0x10012000
.eqv INIT_SCREEN_SRAM		0x10012000
.eqv INSERT_COIN_SRAM		0x10025000
.eqv CURRENT_BKG_SRAM		0x10012000

.eqv FGHT1_ADDR_SRAM		0x1003FFF4
.eqv FGHT1_POSX_SRAM		0x1003FFF8
.eqv FGHT1_POSY_SRAM		0x1003FFFC
.eqv FGHT1_SPR_SRAM		0x10040000

.eqv FGHT2_ADDR_SRAM		0x1007FFF4
.eqv FGHT2_POS_X_SRAM		0x1007FFF8
.eqv FGHT2_POS_Y_SRAM		0x1007FFFC
.eqv FGHT2_SPR_SRAM		0x10080000

## SD ##
# Backgrounds # # (512 * 137) = 0x00011200
.eqv INIT_SCREEN_SD	0x00813200
.eqv INSERT_COIN_SD	0x00826200
.eqv BKG_RYU_SD		0x000A0200
.eqv
.eqv KEN_1_SD		0x000B8200
.eqv RYU_1_SD		0x000D8200

## VGA ##
.eqv VGA_INI_ADDR 	0xFF000000	# VGA initial address
.eqv VGA_QTD_BYTE	76800		# Size of Background
.eqv VGA_WIDTH 		320		# Width of VGA Matrix in pixels

## Data ##
.eqv INS_COIN_BYTE_QTD	1700		# Bytes

################
### Keyboard ###
################
## Player 1 ##
.eqv 	ESQ_1	0x1C000000       #A -> Andar Esquerda
.eqv 	DIR_1	0x23000000       #D -> Andar Direita
.eqv 	CIMA_1	0x1D000000       #W -> Pular
.eqv 	BAIXO_1	0x1B000000       #S -> Abaixar
.eqv 	SOCO_1	0x31000000       #N -> Soco
.eqv	CHUTE_1	0x32000000	 #B -> Chute
.eqv	HADUKEN 0xF023F02A	 #HADUKEN

.eqv 	A2	0x10000000       #A2 -> Andar Esquerda mapeado memoria
.eqv 	S2	0x08000000       #S2 -> Abaixar mapeado memoria
.eqv	D2	0x00000008	 #D2 -> Andar Direita mapeado memoria
.eqv 	W2	0x20000000       #W -> Pular mapeado memoria
.eqv	N2	0x00020000	 #N2 -> Soco mapeado memoria
.eqv	B2	0x00040000	 #B2-> Chute mapeado memoria

.data
.text
main:
	# Keyboard Mapping
	la $s0,0xFF100100  		# BUFFER1
	la $s1,0xFF100104		# BUFFER2
	la $s2,0xFF100520		# KEY0
	la $s3,0xFF100524		# KEY1
	la $s4,0xFF100528		# KEY2
	la $s5,0xFF10052C		# KEY3

	# Print inital screen
	#nop
	#jal initialScreen

	# Print select screen
	#nop
	#jal selectScreen

	# Set initial position of Fighter 1
	li $a0, FGHT1_ADDR_SRAM
	li $a1, 135
	li $a2, 20
	jal setFighterPositions
	nop

	# Set initial position of Fighter 2
	li $a0, FGHT2_ADDR_SRAM
	li $a1, 135
	li $a2, 120
	jal setFighterPositions
	nop

	jal startFight
	nop

loopGame:
	lw $t0,0($s0)
	lw $t1,0($s1)
	sll $t2,$t0,24	#descolando buffer em 24 bits para esquerda
	sll $t3,$t0,16

	lw $s6,0($s2)
	lw $s7,0($s3)
	lw $t6,0($s4)
	lw $t8,0($s5)

	beq $t2, DIR_1, DIR_1_PRESS
	beq $t2, ESQ_1, ESQ_1_PRESS
	nop
	j loopGame

DIR_1_PRESS:
	andi $s7, $s7, D2
      	beq $s7, D2, ANDAR_DIR_1
    	nop
    	j loopGame

ANDAR_DIR_1:

	# get pos atual
	li $a0, FGHT1_ADDR_SRAM
	nop
	jal getFighterPositions

	# update bkg
	nop
	nop
	li $a0, FGHT1_SPR_SRAM
	jal updateBkg
	nop
	nop

	# set new pos
	nop
	li $a0, FGHT1_ADDR_SRAM
	move $a1, $v0
	addi $a2, $v1, 5
	nop
	jal setFighterPositions
	nop

	# print sprite
	li $a0, FGHT1_SPR_SRAM
	li $a3, 0
	jal printSprite
	nop

	nop
	j loopGame

ESQ_1_PRESS:
	andi $s6,$s6,A2
    	beq $s6,A2,ANDAR_ESQ_1

    	nop
    	j loopGame

ANDAR_ESQ_1:
	# get pos atual
	li $a0, FGHT1_ADDR_SRAM
	nop
	jal getFighterPositions

	# update bkg
	nop
	li $a0, FGHT1_SPR_SRAM
	jal updateBkg
	nop

	# update bkg
	li $a0, FGHT1_ADDR_SRAM
	move $a1, $v0
	addi $a2, $v1, -5
	nop
	jal setFighterPositions

	# print sprite
	nop
	li $a0, FGHT1_SPR_SRAM
	li $a3, 0
	jal printSprite
	nop

	nop
	j loopGame

	nop
END: 	j END

###############################
###	    Fighters	   ####
###############################
setFighterPositions: #($a0 = FIGHTER_ADDR, $a1 = x, $a2 = y)
	# Set pos X
	addi $a0, $a0, 4
	sw $a1, 0($a0)

	# Set pos Y
	addi $a0, $a0, 4
	sw $a2, 0($a0)

	nop
	jr $ra


getFighterPositions: #($a0 = FIGHTER_ADDR) -> $v0 = x, $v1 = y
	# Get pos X
	addi $a0, $a0, 4
	lw $v0, 0($a0)

	# Get pos Y
	addi $a0, $a0, 4
	lw $v1, 0($a0)

	nop
	jr $ra


################################
######       Fight       #######
################################
startFight:
	addi $sp $sp, -4
	sw $ra, 0($sp)

	# Load Background to SRAM
	li $a0, BKG_RYU_SD
    	li $a1, CURRENT_BKG_SRAM
    	li $a2, VGA_QTD_BYTE
    	li $v0, 49
    	syscall
    	nop

	# Print background
	li $a0, CURRENT_BKG_SRAM
	nop
	jal printBKG
	nop

	# Move Fighter 1 from SD to SRAM
	li $a0, KEN_1_SD
    	li $a1, FGHT1_SPR_SRAM
    	li $a2, 5200
    	li $v0, 49
    	syscall
    	nop

    	# Move Fighter 2 from SD to SRAM
    	li $a0, RYU_1_SD
    	li $a1, FGHT2_SPR_SRAM
    	li $a2, 5200
    	li $v0, 49
    	syscall
    	nop

	# Print Fighter 1
	li $a0, FGHT1_SPR_SRAM
	li $a1, 135
	li $a2, 20
	li $a3, 0
	nop
	jal printSprite
	nop

	# Print Fighter 2
	li $a0, FGHT2_SPR_SRAM
	li $a1, 135
	li $a2, 120
	li $a3, 0
	nop
	jal printSprite
	nop

	lw $ra, 0($sp)
	addi $sp, $sp, 4

	nop
	jr $ra

####################################
##	Initial Screen code       ##
####################################
initialScreen:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	# Reads Initial Screen from SD to VGA directly
	li $a0, INIT_SCREEN_SD
    	li $a1, VGA_INI_ADDR
    	li $a2, VGA_QTD_BYTE
    	li $v0, 49
    	syscall
    	nop

    	# Load Insert coin from SD
    	li $a0, INSERT_COIN_SD
    	li $a1, INSERT_COIN_SRAM
    	li $a2, INS_COIN_BYTE_QTD
    	li $v0, 49
    	syscall
    	nop

    	# Reads Select Screen from SD to SRAM
    	#li $a0, SLCT_SCREEN_SD
    	#li $a1, SLCT_SCREEN_SRAM
    	#li $a2, VGA_QTD_BYTE
    	#li $v0, 49
    	#syscall
    	nop

	# Clean keyboard buffer
	move $s6, $zero
	move $s7, $zero

insert_coin:
	# Prints the 'insert coin' on the screen
    	li $a0, INSERT_COIN_SRAM
    	li $a1, 175
    	li $a2, 110
    	li $a3, 0
    	nop
    	jal printSprite

    	# Prints a black box where 'insert coin' was
    	move $a0, $zero
    	li $a1, 175
    	li $a2, 110
	nop
	jal printColor

	# Keyboard reading
	lw $s6, 0($s0)
	lw $s7, 0($s1)

	bne $s6, $zero, initialScreenEnd

	nop
	j insert_coin

initialScreenEnd:
	addi $sp, $sp, 4
	lw $ra, 0($sp)
	nop
	jr $ra

###############################
####     SELECT MENU      #####
###############################
selectScreen:
	#li $a0, SLCT_SCREEN_SD
	li $a1, VGA_INI_ADDR
	li $a2, VGA_QTD_BYTE
	li $v0, 49
	syscall
	nop

	nop
	jr $ra

# Reads background from SD to SRAM
printBKG: #($a0 = SRAM_Address)
    	# Load VGA and SRAM Addresses and BKG_SIZE
   	li $t0, VGA_INI_ADDR		# $t0 = VGA_INI_ADDR
   	move $t1, $a0			# $t1 = SRAM_ADDR
    	li $t3, VGA_QTD_BYTE		# $t3 = VGA_QTD_BYTE

writeVGA: # Read from SRAM and write to VGA - $a1 = SRAM_ADDR, $t0 = VGA_INI_ADDR
	lw $t2, 0($t1)			# $t2 = SRAM[0]
    	sw $t2, 0($t0)			# VGA[0] = $t2 = SRAM[0]

    	addi $t0, $t0, 4		# VGA++
    	addi $t1, $t1, 4		# SRAM++
    	addi $t3, $t3, -4		# QTD_BYTES--

    	slti $t4, $t3, 1		# QTD_BYTES == 1 ? $t1 = 1 : $t1 = 0
    	beq $t4, $zero, writeVGA	# if $t1 == 0 then writeVGA

    	# When finished:
    	nop
    	jr $ra


printSprite: #($a0 = Sprite Address, $a3 = Invert?[1 or 0])
	li $t0, 93			# $t0 = fixed height
	li $t1, 55			# $t1 = fixed width

	# resolve bug das sprites (?)
	addi $t0, $t0, 1
	addi $t1, $t1, 1

	# Get positions x and y from sprite
	addi $t2, $a0, -8		# Address of sprite's position x
	lw $a1, 0($t2)			# Loads pos x to $a1
	lw $a2, 4($t2)			# Loads pos y to $a2

	move $t2, $a0			# $t2 = SPRITE ADDRESS
	move $t3, $zero			# $t3 = 0 (External loop index)
	move $t4, $zero			# $t4 = 0 (Internal loop index)

	li $t6, VGA_WIDTH		# $t6 = 320 (width in pixels)
	mult $a1, $t6			# $t5 = 320 * x (position x in display)
	mflo $t5
	add $t5, $t5, $a2		# $t5 = $t5 + $a3 (offset de memoria do inicio de onde é pra ser desenhada a sprite)

	la $t7, VGA_INI_ADDR		# $t7 = VGA_INI_ADDR
	add $t7, $t7, $t5		# $t7 = Initial VGA address to print sprite
	move $t9, $t7			# $t9 = $t7 ($t7 é usado como auxiliar do início da linha)

outer_loop: 	beq $t3, $t0, end_outer_loop	# $t3 == $t0 ? end_outer_loop : proxima Instrução;
inner_loop: 	beq $t4, $t1, end_inner_loop	# $t4 == $t1 ? end_inner_loop : proxima Instrução;
		lb $t8, 0($t2)			# $t8 = SPRITE_ADDRESS[0]
		sb $t8, 0($t7)			# VGA[0] = $t8 = SPRITE_ADDRESS[0]
		addi $t2, $t2, 1		# $t2++ (SPRITE_ADDRESS++)
		addi $t7, $t7, 1		# $t7++ (VGA++)
		addi $t4, $t4, 1		# $t4++ (Internal loop index ++)
		j inner_loop
end_inner_loop:	addi $t7, $t9, VGA_WIDTH	# Move a posição inicial $t7 do display pra próxima linha
		move $t9, $t7			# $t9 = $t7 ($t7 -> aux)
		addi $t3, $t3, 1		# $t3++ (INDICE DO OUTER_LOOP++)
		move $t4, $zero			# $t4 = 0 (zera o índice do inner loop)
		j outer_loop
end_outer_loop:	nop
		jr $ra				# Fim do procedimento

printColor: #($a0 = Hex Color, $a1 = posX, $a2 = posY)
	li $t0, 55			# $t0 = fixed height
	li $t1, 93			# $t1 = fixed width

	# resolve bug das sprites (?)
	addi $t0, $t0, 1
	addi $t1, $t1, 1

	move $t2, $a0			# $t2 = SPRITE ADDRESS
	move $t3, $zero			# $t3 = 0 (External loop index)
	move $t4, $zero			# $t4 = 0 (Internal loop index)

	li $t6, VGA_WIDTH		# $t6 = 320 (width in pixels)
	mult $a1, $t6			# $t5 = 320 * x (position x in display)
	mflo $t5
	add $t5, $t5, $a2		# $t5 = $t5 + $a3 (offset de memoria do inicio de onde é pra ser desenhada a sprite)

	la $t7, VGA_INI_ADDR		# $t7 = VGA_INI_ADDR
	add $t7, $t7, $t5		# $t7 = Initial VGA address to print sprite
	move $t9, $t7			# $t9 = $t7 ($t7 é usado como auxiliar do início da linha)

outer_loop2: 	beq $t3, $t0, end_outer_loop2	# $t3 == $t0 ? end_outer_loop : proxima Instrução;
inner_loop2: 	beq $t4, $t1, end_inner_loop2	# $t4 == $t1 ? end_inner_loop : proxima Instrução;
		sb $t2, 0($t7)			# VGA[0] = $t8 = SPRITE_ADDRESS[0]
		addi $t7, $t7, 1		# $t7++ (VGA++)
		addi $t4, $t4, 1		# $t4++ (Internal loop index ++)
		j inner_loop2
end_inner_loop2:addi $t7, $t9, VGA_WIDTH	# Move a posição inicial $t7 do display pra próxima linha
		move $t9, $t7			# $t9 = $t7 ($t7 -> aux)
		addi $t3, $t3, 1		# $t3++ (INDICE DO OUTER_LOOP++)
		move $t4, $zero			# $t4 = 0 (zera o índice do inner loop)
		j outer_loop2
end_outer_loop2:nop
		jr $ra				# Fim do procedimento

updateBkg: #($a0 = Sprite Address, $a3 = Invert?[1 or 0])
	li $t0, 93			# $t0 = fixed height
	li $t1, 55			# $t1 = fixed width

	# resolve bug das sprites (?)
	addi $t0, $t0, 1
	addi $t1, $t1, 1

	# Get positions x and y from sprite
	addi $t2, $a0, -8		# Address of sprite's position x
	lw $a1, 0($t2)			# Loads pos x to $a1
	lw $a2, 4($t2)			# Loads pos y to $a2

	li $t2, CURRENT_BKG_SRAM	# $t2 = SPRITE ADDRESS
	move $t3, $zero			# $t3 = 0 (External loop index)
	move $t4, $zero			# $t4 = 0 (Internal loop index)

	li $t6, VGA_WIDTH		# $t6 = 320 (width in pixels)
	mult $a1, $t6			# $t5 = 320 * x (position x in display)
	mflo $t5
	add $t5, $t5, $a2		# $t5 = $t5 + $a3 (offset de memoria do inicio de onde é pra ser desenhada a sprite)

	la $t7, VGA_INI_ADDR		# $t7 = VGA_INI_ADDR
	add $t7, $t7, $t5		# $t7 = Initial VGA address to print sprite
	move $t9, $t7			# $t9 = $t7 ($t7 é usado como auxiliar do início da linha)

	add $t2, $t2, $t5
	move $t6, $t2

uBouter_loop: 	beq $t3, $t0, uBend_outer_loop	# $t3 == $t0 ? end_outer_loop : proxima Instrução;
uBinner_loop: 	beq $t4, $t1, uBend_inner_loop	# $t4 == $t1 ? end_inner_loop : proxima Instrução;
		lb $t8, 0($t2)			# $t8 = SPRITE_ADDRESS[0]
		sb $t8, 0($t7)			# VGA[0] = $t8 = SPRITE_ADDRESS[0]
		addi $t2, $t2, 1		# $t2++ (SPRITE_ADDRESS++)
		addi $t7, $t7, 1		# $t7++ (VGA++)
		addi $t4, $t4, 1		# $t4++ (Internal loop index ++)
		j uBinner_loop
uBend_inner_loop:	addi $t7, $t9, VGA_WIDTH	# Move a posição inicial $t7 do display pra próxima linha
		move $t9, $t7			# $t9 = $t7 ($t7 -> aux)
		addi $t3, $t3, 1		# $t3++ (INDICE DO OUTER_LOOP++)
		addi $t2, $t6, VGA_WIDTH
		move $t6, $t2
		move $t4, $zero			# $t4 = 0 (zera o índice do inner loop)
		j uBouter_loop
uBend_outer_loop:	nop
		jr $ra				# Fim do procedimento

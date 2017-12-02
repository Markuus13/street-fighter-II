## Adresses ##
.eqv SRAM_ADDR 		0x10012000

## SD ##
# Backgrounds #
.eqv SD_RYU_BKG_ADDR 	0x00813200
# Standing 
.eqv SPR1_STD_1		0x0081F000
.eqv SPR1_STD_2		0x00821000
.eqv SPR1_STD_3		0x00823800
.eqv SPR1_STD_4		0x00825000

## VGA ##
.eqv VGA_INI_ADDR 	0xFF000000	# VGA initial address
.eqv VGA_QTD_BYTE	76800		# Size of Background 
.eqv VGA_WIDTH 		320		# Width of VGA Matrix in pixels

.data
.text	
main:	
	# Print background
	nop
	jal printBKG
	
	# Print Fighter 1
	li $a0, SPR1_STD_1
    	li $a1, SRAM_ADDR
    	li $a2, 8192
    	li $v0, 49
    	syscall
	
	li $a0, SPR1_STD_1
	li $a1, 135
	li $a2, 20
	li $a3, 0
	nop
	jal printSprite
	
	nop
END: 	j END

printBKG: # Read background from SD to SRAM
    	la $a0, SD_RYU_BKG_ADDR
    	la $a1, SRAM_ADDR
    	la $a2, VGA_QTD_BYTE
    	li $v0, 49
    	syscall
    	
    	# Load VGA and SRAM Addresses and BKG_SIZE
   	la $t0, VGA_INI_ADDR		# $t0 = VGA_INI_ADDR
    	la $t1, SRAM_ADDR		# $t1 = SRAM_ADDR
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
    	jr $ra


printSprite: #($a0 = Sprite Address, $a1 = posX, $a2 = posY, $a3 = Invert?[1 or 0])
	# Saves current $ra in $sp
	# addi $sp, $sp, -4
	# sw $ra, 0($sp)
	
	li $t0, 95			# $t0 = height
	li $t1, 65			# $t1 = width
	
	move $t2, $a1		# $t2 = ENDERECO DO BUFFER
	#li $t2, 0xFFFFFFFF
	move $t3, $zero		# $t3 = 0 (Índice do loop externo)
	move $t4, $zero		# $t4 = 0 (Índice do loop interno)

	li $t6, VGA_WIDTH	# $t6 = 320 (width in pixels)
	mult $a1, $t6		# $t5 = 320 * x (pos eixo x no display)
	mflo $t5
	add $t5, $t5, $a2	# $t5 = $t5 + $a3 (offset de memoria do inicio de onde é pra ser desenhada a sprite)
	
	la $t7, VGA_INI_ADDR	# Carrega endereço inicial da VGA em $t7
	add $t7, $t7, $t5	# endereço inicial de impressão do sprite
	move $t9, $t7		# $t9 = $t7 ($t7 é usado como auxiliar do início da linha)

outer_loop: 	beq $t3, $t0, end_outer_loop	# $t3 == $t0 ? end_outer_loop : proxima Instrução;
inner_loop: 	beq $t4, $t1, end_inner_loop	# $t4 == $t1 ? end_inner_loop : proxima Instrução;
		lb $t8, 0($t2)			# $t8 = BUFFER[0]
		sb $t8, 0($t7)			# IMG_DISPLAY[0] = $t8
		addi $t2, $t2, 1		# $t2++ (BUFFER++)
		addi $t7, $t7, 1		# $t7++ (IMG_DISPLAY++)
		addi $t4, $t4, 1		# $t4++ (ÍNDICE DO INNER_LOOP++)
		j inner_loop
end_inner_loop:	addi $t7, $t9, VGA_WIDTH	# Move a posição inicial $t7 do display pra próxima linha
		move $t9, $t7			# $t9 = $t7 ($t7 -> aux)
		addi $t3, $t3, 1		# $t3++ (INDICE DO OUTER_LOOP++)
		move $t4, $zero			# $t4 = 0 (zera o índice do inner loop)
		j outer_loop		
end_outer_loop:	jr $ra				# Fim do procedimento

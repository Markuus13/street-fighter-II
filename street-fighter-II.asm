#################################################
#  Organização e Arquitetura de Computadores 	#
#  Professor: Marcus Vinicius Lamar	      	#
#  2/2017				      	#
#################################################
.eqv	VGA 0xFF000000
.eqv	VGA_WIDTH 320

.data
# BUFFERS
BUFFER_SPRITE1:		.space 5300
BUFFER_SPRITE2:		.space 5300
BKG_BUFFER:		.space 76800

# FILENAMES
SPRITE1_FILENAME: 	.asciiz "ryu1.bin"
SPRITE2_FILENAME: 	.asciiz "ryu2.bin"
BKG_FILENAME:		.asciiz "bkg_short_ryu.bin"

# [SPRITE]            	[HEIGHT]	[WIDTH]	[HB1      ]  	[HB2      ] 	[HB3       ] 	[HB ATK	  ]	[HB DEF]
SPRITE1_DATA: 	.byte 	85, 		62,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0, 	0, 0, 0, 0
SPRITE2_DATA:	.byte 	85,		62,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0

# KEYBOARD MOVES
QUIT:			.asciiz "q"
MOVE_RIGHT:		.asciiz "d"
MOVE_LEFT:		.asciiz "a"

.text
Main:
	# Carrega os possiveis caracteres que movimentam a sprite $t0 = 'q', $t1 = 'd', $t2 = 'a'
	la $t0, QUIT
	la $t1, MOVE_RIGHT
	la $t2, MOVE_LEFT
	lb $s0, 0($t0)
	lb $s1, 0($t1)
	lb $s2, 0($t2)
	
	# Lê o background para o bkg_buffer
	la $a0, BKG_FILENAME
	la $a1, BKG_BUFFER
	la $a2, 76800
	jal ReadFileToBuffer
	
	# Lê o sprite 1 para o buffer 1
	la $a0, SPRITE1_FILENAME
	la $a1, BUFFER_SPRITE1
	la $a2, 5300
	jal ReadFileToBuffer
	
	# Lê o sprite 2 para o buffer 2
	la $a0, SPRITE2_FILENAME
	la $a1, BUFFER_SPRITE2
	la $a2, 5300
	jal ReadFileToBuffer
	
	# Printa o background no display
	la $a0, BKG_BUFFER
	jal PrintBackground
	
	# Printa o sprite 1 no display
	la $a0, SPRITE1_DATA
	la $a1, BUFFER_SPRITE1
	li $a2, 135
	li $a3, 20
	jal PrintSprite

	# Printa o sprite 2 no display
	la $a0, SPRITE2_DATA
	la $a1, BUFFER_SPRITE2
	li $a2, 135
	li $a3, 200
	jal PrintSprite
	
	# Loop da luta
	jal FightLoop
	
	# Fim do programa [MARS]
	li $v0, 10 
	syscall
	
	# Fim do programa [FPGA]
	# Fim: j Fim

FightLoop:
	# Salva o endereço de retorno na pilha
	addi $sp, $sp, -4
	sw  $ra, 0($sp)
	
	# Le um caracter do teclado, armazena em $v0[MARS]
	li $v0, 12
	syscall
	
	# Compara os valores e pula para o procedimento que move a sprite
	beq $v0, $s0, end_fight_loop
	beq $v0, $s1, Move_sprite1_right
	beq $v0, $s2, Move_sprite1_left

after_move: 
	# Pega o endereço de retorno da pilha
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	# Caso seja uma entrada não mapeada, não faz nada
	j FightLoop
	
end_fight_loop: # Finaliza o loop 
	addi $sp, $sp, 4
	jr $ra
	
Move_sprite1_right:
	addi $a3, $a3, 5 	# Move a sprite 5 posicoes para a direita
	jal PrintSprite
	j after_move
			
Move_sprite1_left:		
	addi $a3, $a3, -5	# Move a sprite 5 posicoes para a esquerda
	jal PrintSprite
	j after_move
	
ReadFileToBuffer: #($a0 = ENDERECO NOME DO ARQUIVO, $a1 = ENDERECO BUFFER DA SPRITE, $a2 = TAMANHO DA SPRITE BYTES)
	move $t0, $a1 # $t0 = ENDERECO BUFFER
	move $t1, $a2 # $t1 = TAMANHO DA SPRITE (BYTES)
	
	# Abre o arquivo da sprite sprite - $a0 = ENDERECO NOME DO ARQUIVO
	li $a1, 0
	li $a2, 0
	li $v0, 13
	syscall
	
	# Le o sprite para a memoria BUFFER
	move $a0, $v0
	move $a1, $t0
	move $a2, $t1
	li $v0, 14
	syscall
	
	# Fecha o arquivo
	li $v0, 16
	syscall
	
	# Retorna para o procedimento anterior
	jr $ra

PrintBackground: #$(a0 = ENDEREÇO BUFFER BACKGROUND)
	la $t0, 0xFF000000	# $t0 = Endereco inicial display
	la $t1, 0xFF012C00	# $t1 = Endereco final display
	move $t2, $a0		# $t2 = Endereco Buffer do BKG
		
loop: 	beq $t0, $t1, fora	# Enquanto não chegar no fim do display
	lw $t3, 0($t2)		# $t3 = Endereco do Buffer[0]
	sw $t3, 0($t0)		# Endereco do Display[0] = $t3
	addi $t0, $t0, 4	# $t0 ++
	addi $t2, $t2, 4	# $t2 ++
	j loop
fora:	jr $ra			# retorna pro caller

	
PrintSprite: #($a0 = ENDERECO SPRITE, $a1 = ENDERECO DO BUFFER, $a2 = pos_x, $a3 = pos_y) 
	
	lb $t0, 0($a0)		# $t0 = TamX SPRITE
	lb $t1, 1($a0)		# $t1 = TamY SPRITE
	
	move $t2, $a1		# $t2 = ENDERECO DO BUFFER
	move $t3, $zero		# $t3 = 0 (Índice do loop externo)
	move $t4, $zero		# $t4 = 0 (Índice do loop interno)

	li $t6, VGA_WIDTH	# $t6 = 320 (width in pixels)
	mul $t5, $a2, $t6	# $t5 = 320 * x (pos eixo x no display)
	add $t5, $t5, $a3	# $t5 = $t5 + $a3 (offset de memoria do inicio de onde é pra ser desenhada a sprite)
	
	la $t7, VGA		# Carrega endereço inicial da VGA em $t7
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

#################################################
#  Organização e Arquitetura de Computadores 	#
#  Professor: Marcus Vinicius Lamar	      	#
#  2/2017				      	#
#################################################
.eqv	VGA 0xFF000000
.eqv	VGA_WIDTH 320

.data
# BUFFERS
LAST_POS_SPRITE1:	.half 135, 20
BUFFER_SPRITE1:		.space 5300
LAST_POS_SPRITE2:	.half 135, 20
BUFFER_SPRITE2:		.space 5300
BKG_BUFFER:		.space 76800

# FILENAMES
SPRITE1_FILENAME: 	.asciiz "forward1.bin"
SPRITE2_FILENAME: 	.asciiz "ryu2.bin"
BKG_FILENAME:		.asciiz "bkg_short_ryu.bin"

BACK1_FILENAME:		.asciiz "back1.bin"
BACK2_FILENAME:		.asciiz "back2.bin"
BACK3_FILENAME:		.asciiz "back3.bin"
BACK4_FILENAME:		.asciiz "back4.bin"
BACK5_FILENAME:		.asciiz "back5.bin"
BACK6_FILENAME:		.asciiz "back6.bin"

FRONT1_FILENAME:	.asciiz "forward1.bin"
FRONT2_FILENAME:	.asciiz "forward2.bin"
FRONT3_FILENAME:	.asciiz "forward3.bin"
FRONT4_FILENAME:	.asciiz "forward4.bin"
FRONT5_FILENAME:	.asciiz "forward5.bin"
FRONT6_FILENAME:	.asciiz "forward6.bin"

# [SPRITE]            	[HEIGHT]	[WIDTH]	[HB1      ]  	[HB2      ] 	[HB3       ] 	[HB ATK	  ]	[HB DEF]
SPRITE1_DATA: 	.byte 	83, 		53,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0, 	0, 0, 0, 0
SPRITE2_DATA:	.byte 	85,		62,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0

FRONT1_DATA: 	.byte 	83, 		53,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0, 	0, 0, 0, 0
FRONT2_DATA: 	.byte 	88, 		60,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0, 	0, 0, 0, 0
FRONT3_DATA: 	.byte 	92, 		64,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0, 	0, 0, 0, 0
FRONT4_DATA: 	.byte 	90, 		63,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0, 	0, 0, 0, 0
FRONT5_DATA: 	.byte 	91, 		54,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0, 	0, 0, 0, 0
FRONT6_DATA: 	.byte 	89, 		50,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0, 	0, 0, 0, 0

BACK1_DATA: 	.byte 	89, 		57,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0, 	0, 0, 0, 0
BACK2_DATA: 	.byte 	87, 		61,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0, 	0, 0, 0, 0
BACK3_DATA: 	.byte 	90, 		59,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0, 	0, 0, 0, 0
BACK4_DATA: 	.byte 	90, 		57,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0, 	0, 0, 0, 0
BACK5_DATA: 	.byte 	90, 		58,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0, 	0, 0, 0, 0
BACK6_DATA: 	.byte 	91, 		58,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0,	0, 0, 0, 0, 	0, 0, 0, 0

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
	jal GameLoop
	
	# Fim do programa [MARS]
	li $v0, 10 
	syscall
	
	# Fim do programa [FPGA]
	# Fim: j Fim

GameLoop:
	# Salva o endereço de retorno na pilha
	addi $sp, $sp, -4
	sw  $ra, 0($sp)
	
	# Le um caracter do teclado, armazena em $v0[MARS]
	li $v0, 12
	syscall
	
	# Compara os valores e pula para o procedimento que move a sprite
	beq $v0, $s0, end_fight_loop
	beq $v0, $s1, move_sprite1_right
	beq $v0, $s2, move_sprite1_left

after_move: 
	# Pega o endereço de retorno da pilha
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	# Caso seja uma entrada não mapeada, não faz nada
	j GameLoop
	
end_fight_loop: # Finaliza o loop 
	addi $sp, $sp, 4
	jr $ra
	
move_sprite1_right:
	jal right_animation
	# salvar aposicao (x,y) da sprite
	j after_move

right_animation:
	addi $sp, $sp, -4
	sw  $ra, 0($sp)
	
	la $a0, FRONT1_FILENAME
	la $a1, BUFFER_SPRITE1
	la $a2, 5300
	jal ReadFileToBuffer
	la $a0, FRONT1_DATA
	la $a1, BUFFER_SPRITE1
	li $a2, 135
	li $a3, 20
	jal PrintSprite
	
	la $a0, FRONT2_FILENAME
	la $a1, BUFFER_SPRITE1
	la $a2, 5300
	jal ReadFileToBuffer
	la $a0, FRONT2_DATA
	la $a1, BUFFER_SPRITE1
	li $a2, 135
	li $a3, 20
	addi $a3, $a3, 1
	jal PrintSprite
	
	la $a0, FRONT3_FILENAME
	la $a1, BUFFER_SPRITE1
	la $a2, 5300
	jal ReadFileToBuffer
	la $a0, FRONT3_DATA
	la $a1, BUFFER_SPRITE1
	li $a2, 135
	li $a3, 20
	addi $a3, $a3, 2
	jal PrintSprite
	
	la $a0, FRONT4_FILENAME
	la $a1, BUFFER_SPRITE1
	la $a2, 5300
	jal ReadFileToBuffer
	la $a0, FRONT4_DATA
	la $a1, BUFFER_SPRITE1
	li $a2, 135
	li $a3, 20
	addi $a3, $a3, 3
	jal PrintSprite
	
	la $a0, FRONT5_FILENAME
	la $a1, BUFFER_SPRITE1
	la $a2, 5300
	jal ReadFileToBuffer
	la $a0, FRONT5_DATA
	la $a1, BUFFER_SPRITE1
	li $a2, 135
	li $a3, 20
	addi $a3, $a3, 4
	jal PrintSprite
	
	la $a0, FRONT6_FILENAME
	la $a1, BUFFER_SPRITE1
	la $a2, 5300
	jal ReadFileToBuffer
	la $a0, FRONT6_DATA
	la $a1, BUFFER_SPRITE1
	li $a2, 135
	li $a3, 20
	addi $a3, $a3, 5
	jal PrintSprite
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

move_sprite1_left:
	jal left_animation	
	# salvar posicao (x,y) da sprite
	j after_move

left_animation:
	addi $sp, $sp, -4
	sw  $ra, 0($sp)
	
	la $a0, BACK1_FILENAME
	la $a1, BUFFER_SPRITE1
	la $a2, 5300
	jal ReadFileToBuffer
	la $a0, BACK1_DATA
	la $a1, BUFFER_SPRITE1
	li $a2, 135
	li $a3, 20
	jal PrintSprite
	
	la $a0, BACK2_FILENAME
	la $a1, BUFFER_SPRITE1
	la $a2, 5300
	jal ReadFileToBuffer
	la $a0, BACK2_DATA
	la $a1, BUFFER_SPRITE1
	li $a2, 135
	li $a3, 20
	addi $a3, $a3, -1
	jal PrintSprite
	
	la $a0, BACK3_FILENAME
	la $a1, BUFFER_SPRITE1
	la $a2, 5300
	jal ReadFileToBuffer
	la $a0, BACK3_DATA
	la $a1, BUFFER_SPRITE1
	li $a2, 135
	li $a3, 20
	addi $a3, $a3, -2
	jal PrintSprite
	
	la $a0, BACK4_FILENAME
	la $a1, BUFFER_SPRITE1
	la $a2, 5300
	jal ReadFileToBuffer
	la $a0, BACK4_DATA
	la $a1, BUFFER_SPRITE1
	li $a2, 135
	li $a3, 20
	addi $a3, $a3, -3
	jal PrintSprite
	
	la $a0, BACK5_FILENAME
	la $a1, BUFFER_SPRITE1
	la $a2, 5300
	jal ReadFileToBuffer
	la $a0, BACK5_DATA
	la $a1, BUFFER_SPRITE1
	li $a2, 135
	li $a3, 20
	addi $a3, $a3, -4
	jal PrintSprite
	
	la $a0, BACK6_FILENAME
	la $a1, BUFFER_SPRITE1
	la $a2, 5300
	jal ReadFileToBuffer
	la $a0, BACK6_DATA
	la $a1, BUFFER_SPRITE1
	li $a2, 135
	li $a3, 20
	addi $a3, $a3, -5
	jal PrintSprite
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra


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


LastPosition: #($a1 = ENDERECO DO BUFFER DA SPRITE)
	addi $t0, $a1, -4	# $t0 = ENDERECO que contém última posição da sprite
	
	lh $v0, 0($t0)		# $v0 = pos x
	lh $v1, 2($t0)		# $v1 = pos y
	
	jr $ra			# retorna ao procedimento caller
	

EraseOldSprite: #($a0 = ENDERECO SPRITE, $a1 = ENDERECO ULTIMA POSICAO SPRITE)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal LastPosition
	
	li $t0, 92		# $t0 = TamX SPRITE
	li $t1, 64		# $t1 = TamY SPRITE
	
	la $t2, BKG_BUFFER	# $t2 = ENDERECO DO BKG BUFFER
	move $t3, $zero		# $t3 = 0 (Índice do loop externo)
	move $t4, $zero		# $t4 = 0 (Índice do loop interno)
	
	li $t6, VGA_WIDTH	# $t6 = 320 (width in pixels)
	mul $t5, $v0, $t6	# $t5 = 320 * x (pos eixo x no display)
	add $t5, $t5, $v1	# $t5 = $t5 + $v1 (offset de memoria do inicio de onde é pra ser apagada a sprite)
	
	la $t7, VGA		# Carrega endereço inicial da VGA em $t7
	add $t7, $t7, $t5	# endereço inicial para apagar sprite
	move $t9, $t7		# $t9 = $t7 ($t7 é usado como auxiliar do início da linha)
	
	add $t2, $t2, $t5	# ENDERECO BKG_BUFFER com offset do inicio da posição da sprite
	move $t5, $t2		# $t5 = $t2 ($t2 é usado como auxiliar do ínicio da linha)
	
o_loop: beq $t3, $t0, end_o		# $t3 == $t0 ? end_outer_loop : proxima Instrução;
i_loop: beq $t4, $t1, end_i		# $t4 == $t1 ? end_inner_loop : proxima Instrução;
	lb $t8, 0($t2)			# $t8 = BKG_BUFFER[0]
	sb $t8, 0($t7)			# IMG_DISPLAY[0] = $t8
	addi $t2, $t2, 1		# $t2++ (BKG_BUFFER++)
	addi $t7, $t7, 1		# $t7++ (IMG_DISPLAY++)
	addi $t4, $t4, 1		# $t4++ (ÍNDICE DO INNER_LOOP++)
	j i_loop
end_i:	addi $t7, $t9, VGA_WIDTH	# Move a posição inicial $t7 do display pra próxima linha
	addi $t2, $t5, VGA_WIDTH
	move $t9, $t7			# $t9 = $t7 ($t7 -> aux)
	move $t5, $t2			# $t5 = $t2 ($t2 -> BKG_BUFFER aux)
	addi $t3, $t3, 1		# $t3++ (INDICE DO OUTER_LOOP++)
	move $t4, $zero			# $t4 = 0 (zera o índice do inner loop)
	j o_loop		
end_o:	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra				# Fim do procedimento

PrintSprite: #($a0 = ENDERECO SPRITE, $a1 = ENDERECO DO BUFFER, $a2 = pos_x, $a3 = pos_y) 
	addi $sp, $sp, -4	# Aloca uma word na stack
	sw $ra, 0($sp)		# Salva o $ra em 0($sp)
	
	jal EraseOldSprite	# Chama procedimento pra remover sprite anterior
	
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
end_outer_loop:	lw $ra, 0($sp)			# Carrega o valor anterior de $ra que estava na stack
		addi $sp, $sp, 4		# Desaloca a word da stack
		jr $ra				# Fim do procedimento

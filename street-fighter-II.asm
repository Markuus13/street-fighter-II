#################################################
#  Organização e Arquitetura de Computadores 	#
#  Professor: Marcus Vinicius Lamar	      	#
#  2/2017				      	#
#################################################
.eqv	VGA 0xFF000000
.eqv	VGA_WIDTH 320

.data 
# [HEIGHT] [WIDTH] [HB1] [HB2] [HB3]
SPRITE: 	.byte 85,62
BUFFER: 	.space 5300
FILE1: 		.asciiz "ryu2.bin"	
QUIT:		.asciiz "q"
MOVE_RIGHT:	.asciiz "d"
MOVE_LEFT:	.asciiz "a"


.text
Main:
	# Abre o arquivo sprite
	la $a0,FILE1
	li $a1,0
	li $a2,0
	li $v0,13
	syscall

	# Le o sprite para a memoria BUFFER
	move $a0,$v0
	la $a1,BUFFER
	li $a2,5270
	li $v0,14
	syscall
	
	# Fecha o arquivo
	li $v0,16
	syscall
	
	# Carrega os argumentos e chama o procedimento PrintSprite
	la $a0,SPRITE
	li $a1,100
	li $a2,0
	jal PrintSprite
	
UpdateGame:
	# Le um caracter do teclado, armazena em $v0[MARS]
	li $v0, 12
	syscall
	
	# Carrega os possiveis caracteres que movimentam a sprite $t0 = 'q', $t1 = 'd', $t2 = 'a'
	la $t0, QUIT
	la $t1, MOVE_RIGHT
	la $t2, MOVE_LEFT
	lb $t0, 0($t0)
	lb $t1, 0($t1)
	lb $t2, 0($t2)
	
	# Compara os valores e pula para o procedimento que move a sprite
	beq $v0, $t0, Fim
	beq $v0, $t1, move_sprite_right
	beq $v0, $t2, move_sprite_left
	
move_sprite_right:
	addi $a2, $a2, 5 	# Move a sprite 5 posicoes para a direita
	jal PrintSprite
	j UpdateGame
	
move_sprite_left:
	addi $a2, $a2, -5	# Move a sprite 5 posicoes para a esquerda
	jal PrintSprite
	j UpdateGame
	
	# Fim do programa [MARS]
Fim:	li $v0,10 
	syscall
	
	# Fim do programa [FPGA]
	# Fim: j Fim 

InitialAnimation:
GameMenu:
MatchScreen:
FightLoop:
DefeatedOponentScreen:

PrintSprite: #($a0 = ENDERECO SPRITE, $a1 = pos_x, $a2 = pos_y) 
	lb $t0,0($a0)		# $t0 = TamX SPRITE
	lb $t1,1($a0)		# $t1 = TamY SPRITE
	
	la $t2, BUFFER		# $t2 = ENDERECO DO BUFFER
	move $t3,$zero		# $t3 = 0 (Índice do loop externo)
	move $t4,$zero		# $t4 = 0 (Índice do loop interno)

	li $t6,VGA_WIDTH	# $t6 = 320 (width in pixels)
	mul $t5,$a1,$t6		# $t5 = 320 * x (pos eixo x no display)
	add $t5,$t5,$a2		# $t5 = $t5 + $a2 (offset de memoria do inicio de onde é pra ser desenhada a sprite)
	
	la $t7,VGA		# Carrega endereço inicial da VGA em $t7
	add $t7,$t7,$t5		# endereço inicial de impressão do sprite
	move $t9,$t7		# $t9 = $t7 ($t7 é usado como auxiliar do início da linha)

outer_loop: 	beq $t3,$t0,end_outer_loop	# $t3 == $t0 ? end_outer_loop : proxima Instrução;
inner_loop: 	beq $t4,$t1,end_inner_loop	# $t4 == $t1 ? end_inner_loop : proxima Instrução;
		lb $t8,0($t2)		# $t8 = BUFFER[0]
		sb $t8,0($t7)		# IMG_DISPLAY[0] = $t8
		addi $t2,$t2,1		# $t2++ (BUFFER++)
		addi $t7,$t7,1		# $t7++ (IMG_DISPLAY++)
		addi $t4,$t4,1		# $t4++ (ÍNDICE DO INNER_LOOP++)
		j inner_loop
end_inner_loop:	addi $t7,$t9,VGA_WIDTH	# Move a posição inicial $t7 do display pra próxima linha
		move $t9,$t7		# $t9 = $t7 ($t7 -> aux)
		addi $t3,$t3,1		# $t3++ (INDICE DO OUTER_LOOP++)
		move $t4,$zero		# $t4 = 0 (zera o índice do inner loop)
		j outer_loop		
end_outer_loop:	jr $ra			# Fim do procedimento

	

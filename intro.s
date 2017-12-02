#################################################
#  Organização e Arquitetura de Computadores 	#
#  Professor: Marcus Vinicius Lamar	      	#
#  2/2017				      	#
#################################################
.eqv	VGAi 0xFF000000
.eqv	VGAf 0xFF012C00		# Fim da MMIO VGA
.eqv	MAX_SIZE 99999		# Tamanho do maior arquivo .bin (bytes)
.eqv	SRAMi 0x10012000	# Endereco SRAM
.eqv	KSIM 0xFF100000		# Keyboard simulator

########### REGISTRADORES PERMANENTES ########### 
# $s7 - endereco livre SRAM			#
# $s6 - endereco do teclado			#
#################################################

.data

# FILENAMES
  # Opening
  OPN_BKG:	.asciiz "opening.bin"
  COINS: 	.asciiz "insert_coin.bin"

  # Select Screen
  SELECT_BKG:	.asciiz "select.bin"
  P1SQUARE:	.asciiz "P1square.bin"

    # RYU
    RYUPIC:	.asciiz "ryu_pic.bin"
    RYUNAME:	.asciiz "ryu_name.bin"

#[BKG]------------------[SRAM ADDR]------------------------------#
OPN_DATA:	.word	0
SELECT_DATA:	.word	0

#[SPRITE]---------------[SRAM ADDR]------------------------------#
COINS_DATA: 	.word	0
#			[HEIGHT]	[WIDTH]		[MORE...]
		.byte 	17,		99,
#			[MORE...]	[MORE...]
#.......................[SRAM ADDR]..............................#
P1SQUARE_DATA: 	.word	0
#			[HEIGHT]	[WIDTH]		[MORE...]
		.byte 	47,		44,
#			[MORE...]	[MORE...]
#.......................[SRAM ADDR]..............................#
RYUPIC_DATA: 	.word	0
#			[HEIGHT]	[WIDTH]		[MORE...]
		.byte 	102,		106,
#			[MORE...]	[MORE...]
#.......................[SRAM ADDR]..............................#
RYUNAME_DATA: 	.word	0
#			[HEIGHT]	[WIDTH]		[MORE...]
		.byte 	24,		84,
#			[MORE...]	[MORE...]
#----------------------------------------------------------------#

.text
Main:
	li $s6,KSIM # Endereco teclado
	la $s7,SRAMi # Endereco livre SRAM

# SRAM - OPENING
	# Salva os arquivos na SRAM ($s7 = ENDERECO FINAL ALINHADO)
	la $a0,OPN_BKG
	la $a3,OPN_DATA
	jal ReadFileToSRAM
	jal ADDRalign # Ajusta padding da memoria p/ words
	
	la $a0,COINS
	la $a3,COINS_DATA
	jal ReadFileToSRAM
	jal ADDRalign

# SRAM - SELECT SCREEN
	la $a0,SELECT_BKG
	la $a3,SELECT_DATA
	jal ReadFileToSRAM
	jal ADDRalign
	la $a0,P1SQUARE
	la $a3,P1SQUARE_DATA
	jal ReadFileToSRAM
	jal ADDRalign
	
	#RYU
	la $a0,RYUPIC
	la $a3,RYUPIC_DATA
	jal ReadFileToSRAM
	jal ADDRalign
	la $a0,RYUNAME
	la $a3,RYUNAME_DATA
	jal ReadFileToSRAM
	jal ADDRalign

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
Opening:
	# Imprime o bkg
	lw $a1,OPN_DATA
	jal PrintBkg
	
	# Pisca o "INSERT COIN"
	li $a0,170
	li $a1,105
	la $a2,COINS_DATA
	li $a3,0
	jal PrintSprite
	# Checa teclado
	li $s1,60000 # counter
	jal wait_key

	li $a0,170
	li $a1,105
	la $a2,COINS_DATA
	la $a3,OPN_DATA
	jal BkgUpdate
	# Checa teclado
	li $s1,20000 # Contador Delay
	jal wait_key
	j Opening
	
	wait_key:  
	subi $s1,$s1,1 # Contador Delay
	bgtz $s1,wait_key_act # $s1 > 0 ?
	jr $ra
	
	wait_key_act:
	lw $t1,0($s6)
	andi $t1,$t1,0x01
	beq $t1,$zero,wait_key
	j Select_Screen
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
Select_Screen:
	
	# Imprime bkg e sprites
	lw $a1,SELECT_DATA
	jal PrintBkg
	
	li $a0,155
	li $a1,98
	la $a2,P1SQUARE_DATA
	li $a3,0
	jal PrintSprite
	
	# Imprime o Ryu para P1
	li $a0,138
	li $a1,0
	la $a2,RYUPIC_DATA
	li $a3,0
	jal PrintSprite
	
	li $a0,114
	li $a1,15
	la $a2,RYUNAME_DATA
	li $a3,0
	jal PrintSprite
	
	# Imprime o Ryu para P2
	li $a0,138
	li $a1,214
	la $a2,RYUPIC_DATA
	li $a3,1
	jal PrintSprite
	
	li $a0,114
	li $a1,222
	la $a2,RYUNAME_DATA
	li $a3,0
	jal PrintSprite
	
exit:	
	li $v0,10
	syscall





#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~FUNCOES AUXILIARES~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

ADDRalign: #($s7 = ENDERECO FINAL ALINHADO)						#ALTERA: $a0,$a1,$a2,$s7 

	move $a0,$s7
	andi $a0,$a0,0x0F # Ultimo byte do endereço deve ser 0x00, 0x04, 0x08, 0x0C
	li $a1,0x04
	div $a0,$a1
	mfhi $a2
	beq $a2,$zero,ADDRalign_out
	sub $a0,$a1,$a2 # ($v0)mod(4) multiplo? (4-resto)
	add $s7,$s7,$a0 # Soma quanto?
	
	ADDRalign_out:
	jr $ra


ReadFileToSRAM: #($a0 = NOME DO ARQUIVO .bin, $a3 = ENDERECO DE DADOS, $s7 = ENDERECO SRAM LIVRE)	#ALTERA: $a0,$a1,$a2,$v0,$s7

	# Abre o arquivo $a0
	li $a1,0
	li $a2,0
	li $v0,13
	syscall

	# Le o arquivo para a memoria SRAM
	move $a0,$v0
	move $a1,$s7
	li $a2,MAX_SIZE
	li $v0,14
	syscall
	sw $a1,0($a3) # Salva o endereco SRAM do arquivo
	add $s7,$a1,$v0 # $s7 = Posicao da SRAM livre
	
	#Fecha o arquivo
	li $v0,16
	syscall
	
	jr $ra

PrintBkg: # Memoria SRAM para VGA ($a1 = SRAM DO BKG PRA IMPRIMIR)		#ALTERA: $a0,$a1,
	
	la $a0,VGAi
	
	VGA_bkg:
 	beq $a0,VGAf,VGA_out	# Fim do display
	lw $a2,0($a1)
	sw $a2,0($a0)
	addi $a0,$a0,4
	addi $a1,$a1,4
	j VGA_bkg
	
	VGA_out:
	jr $ra

BkgUpdate:	#($a0 = pos_x, $a1 = pos_y, $a2 = tamanho, $a3 = endereco SRAM do bkg)	#ALTERA: $a0,$a1,$a2,$a3,$v0,$s7
											#	 $t0,$t1,$t2,$t3,$t4,
											#	 $t5,$t6,$t7,$t8,$t9
	lb $t0,4($a2)		# $t0 = TamY SPRITE
	lb $t1,5($a2)		# $t1 = TamX SPRITE
	lw $t2,0($a3)		# $t2 = ENDERECO NA SRAM
	
	move $t3,$zero		# $t3 = 0 (Índice do loop externo)
	move $t4,$zero		# $t4 = 0 (Índice do loop interno)

	li $t6,320		# $t6 = 320 (width in pixels)
	mul $t5,$a0,$t6		# $t5 = 320 * x (pos eixo x no display)
	add $t5,$t5,$a1		# $t5 = $t5 + $a3 (offset de memoria do inicio de onde é pra ser desenhada a sprite)
	
	la $t7,VGAi		# Carrega endereço inicial da VGA em $t7
	add $t7,$t7,$t5		# endereço inicial de impressão do sprite
	move $t9,$t7		# $t9 = $t7 ($t7 é usado como auxiliar do início da linha)

	BUouter_loop: 
	BUinner_loop: 
	beq $t3,$t0,BUend_outer_loop	# $t3 == $t0 ? end_outer_loop : proxima Instrução;
	beq $t4,$t1,BUend_inner_loop	# $t4 == $t1 ? end_inner_loop : proxima Instrução;
	lb $t8,0($t2)		# $t8 = BUFFER[0]
	sb $t8,0($t7)		# IMG_DISPLAY[0] = $t8
	addi $t2,$t2,1		# $t2++ (BUFFER++)
	addi $t7,$t7,1		# $t7++ (IMG_DISPLAY++)
	addi $t4,$t4,1		# $t4++ (ÍNDICE DO INNER_LOOP++)
	j BUinner_loop
	
	BUend_inner_loop:	
	addi $t7,$t9,320	# Move a posição inicial $t7 do display pra próxima linha
	move $t9,$t7		# $t9 = $t7 ($t7 -> aux)
	addi $t3,$t3,1		# $t3++ (INDICE DO OUTER_LOOP++)
	move $t4,$zero		# $t4 = 0 (zera o índice do inner loop)
	j BUouter_loop		
	
	BUend_outer_loop:
	jr $ra			# Fim do procedimento


PrintSprite:	#($a0 = pos_x, $a1 = pos_y, $a2 = label da estrutura .data, $a3 = inverte?)	#ALTERA: $a0,$a1,$a2,$v0,$s7
												#	 $t0,$t1,$t2,$t3,$t4,
												#	 $t5,$t6,$t7,$t8,$t9
	lb $t0,4($a2)		# $t0 = TamY SPRITE
	lb $t1,5($a2)		# $t1 = TamX SPRITE
	lw $t2,0($a2)		# $t2 = ENDERECO NA SRAM
	
	move $t3,$zero		# $t3 = 0 (Índice do loop externo)
	move $t4,$zero		# $t4 = 0 (Índice do loop interno)

	li $t6,320		# $t6 = 320 (width in pixels)
	mul $t5,$a0,$t6		# $t5 = 320 * x (pos eixo x no display)
	add $t5,$t5,$a1		# $t5 = $t5 + $a3 (offset de memoria do inicio de onde é pra ser desenhada a sprite)
	
	la $t7,VGAi		# Carrega endereço inicial da VGA em $t7
	add $t7,$t7,$t5		# endereço inicial de impressão do sprite
	move $t9,$t7		# $t9 = $t7 ($t7 é usado como auxiliar do início da linha)
	
	mul $t5,$t1,$a3		# $a3 = tamX * (bool inverte?) - leitura invertida da sprite
	add $t2,$t2,$t5		# Endereco atualizado para leitura invertida ou nao

	PSouter_loop: 
	PSinner_loop: 
	beq $t3,$t0,PSend_outer_loop	# $t3 == $t0 ? end_outer_loop : proxima Instrução;
	beq $t4,$t1,PSend_inner_loop	# $t4 == $t1 ? end_inner_loop : proxima Instrução;
	lb $t8,0($t2)		# $t8 = BUFFER[inicio ou fim de linha]
	sb $t8,0($t7)		# IMG_DISPLAY[0] = $t8
	addi $t2,$t2,1		# $t2++ (BUFFER++)
	sub $t2,$t2,$a3		# INVERTE? - subtrai 2x
	sub $t2,$t2,$a3		# INVERTE? - para $t2--
	addi $t7,$t7,1		# $t7++ (IMG_DISPLAY++)
	addi $t4,$t4,1		# $t4++ (ÍNDICE DO INNER_LOOP++)
	j PSinner_loop
	
	PSend_inner_loop:	
	addi $t7,$t9,320	# Move a posição inicial $t7 do display pra próxima linha
	move $t9,$t7		# $t9 = $t7 ($t7 -> aux)
	addi $t3,$t3,1		# $t3++ (INDICE DO OUTER_LOOP++)
	move $t4,$zero		# $t4 = 0 (zera o índice do inner loop)
	add $t2,$t2,$t5		# INVERTE? - Novo fim de linha
	add $t2,$t2,$t5		# INVERTE? - 2x para fim da proxima linha
	j PSouter_loop		
	
	PSend_outer_loop:
	jr $ra			# Fim do procedimento

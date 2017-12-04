#################################################
#  Organização e Arquitetura de Computadores 	#
#  Professor: Marcus Vinicius Lamar	      	#
#  2/2017				      	#
#################################################
.eqv	VGAi 0xFF000000		# Inicio da MMIO VGA
.eqv	VGAf 0xFF012C00		# Fim da MMIO VGA
.eqv	MAX_SIZE 99999		# Tamanho do maior arquivo .bin (bytes)
.eqv	SRAMi 0x10012000	# Endereco SRAM
.eqv	KSIM 0xFF100000		# Keyboard simulator

########### REGISTRADORES PERMANENTES ########### 
# $s4 - posicao atual de P1SQUARE posX(cat)posY #
# $s5 - posicao atual de P2SQUARE posX(cat)posY #
# $s6 - endereco do teclado			#
# $s7 - endereco livre SRAM			#
#################################################

.data

# FILENAMES
  # Opening
  OPN_BKG:	.asciiz "opening.bin"
  COINS: 	.asciiz "insert_coin.bin"

  # Select Screen
  SELECT_BKG:	.asciiz "select.bin"
  P1SQUARE:	.asciiz "P1square.bin"
  P2SQUARE:	.asciiz "P2square.bin"

    # RYU
    RYUPIC:	.asciiz "ryu_pic.bin"
    RYUNAME:	.asciiz "ryu_name.bin"
    # HONDA
    HONPIC:	.asciiz "hon_pic.bin"
    HONNAME:	.asciiz "hon_name.bin"
    # BLANKA
    BLAPIC:	.asciiz "bla_pic.bin"
    BLANAME:	.asciiz "bla_name.bin"
    # GUILE
    GUIPIC:	.asciiz "gui_pic.bin"
    GUINAME:	.asciiz "gui_name.bin"
    # KEN
    KENPIC:	.asciiz "ken_pic.bin"
    KENNAME:	.asciiz "ken_name.bin"
    # CHUNLI
    CHUPIC:	.asciiz "chu_pic.bin"
    CHUNAME:	.asciiz "chu_name.bin"
    # ZANGIEF
    ZANPIC:	.asciiz "zan_pic.bin"
    ZANNAME:	.asciiz "zan_name.bin"
    # DHALSIM
    DHAPIC:	.asciiz "dha_pic.bin"
    DHANAME:	.asciiz "dha_name.bin"
    
#----------------------------------------------------------------#
#[BKG]------------------[SRAM ADDR]------------------------------#
OPN_ADDR:	.word	0
SELECT_ADDR:	.word	0
#----------------------------------------------------------------#
#[SPRITES]-------------------------------------------------------#

#			[HEIGHT]	[WIDTH]		[MORE...]
COINS_SIZE:	.byte 	17,		99,
#			[SRAM ADDR]
COINS_ADDR: 	.word	0

#................................................................#

#			[HEIGHT]	[WIDTH]		[MORE...]
SQUARE_SIZE:	.byte 	38,		34,
#			[X]		[Y] # alterar inicio .text
P1SQUARE_POS:	.byte 	160,		103,
P2SQUARE_POS:	.byte 	193,		103,
#			[SRAM ADDR]
P1SQUARE_ADDR: 	.word	0
P2SQUARE_ADDR: 	.word	0

#................................................................#

#			[HEIGHT]	[WIDTH]		[MORE...]
PIC_SIZE:	.byte 	116,		106,
#			[SRAM ADDR]
RYUPIC_ADDR: 	.word	0
HONPIC_ADDR: 	.word	0
BLAPIC_ADDR: 	.word	0
GUIPIC_ADDR: 	.word	0
KENPIC_ADDR: 	.word	0
CHUPIC_ADDR: 	.word	0
ZANPIC_ADDR: 	.word	0
DHAPIC_ADDR: 	.word	0
#................................................................#

#			[HEIGHT]	[WIDTH]		[MORE...]
NAME_SIZE:	.byte 	24,		84,
#			[SRAM ADDR]
RYUNAME_ADDR: 	.word	0
HONNAME_ADDR: 	.word	0
BLANAME_ADDR: 	.word	0
GUINAME_ADDR: 	.word	0
KENNAME_ADDR: 	.word	0
CHUNAME_ADDR: 	.word	0
ZANNAME_ADDR: 	.word	0
DHANAME_ADDR: 	.word	0
#----------------------------------------------------------------#

.text
Main:
# REGISTRADORES PERMANENTES
	lui $s4,160 # posicao atual de P1SQUARE
	addi $s4,$s4,103 # posX(cat)posY 
	lui $s5,193 # posicao atual de P2SQUARE
	addi $s5,$s5,103 # posX(cat)posY 
	li $s6,KSIM # Endereco teclado
	la $s7,SRAMi # Endereco livre SRAM

# SRAM - OPENING
	# Salva os arquivos na SRAM ($s7 = ENDERECO FINAL ALINHADO)
	la $a0,OPN_BKG
	la $a3,OPN_ADDR
	jal ReadFileToSRAM
	jal ADDRalign # Ajusta padding da memoria p/ words
	
	la $a0,COINS
	la $a3,COINS_ADDR
	jal ReadFileToSRAM
	jal ADDRalign

# SRAM - SELECT SCREEN
	la $a0,SELECT_BKG
	la $a3,SELECT_ADDR
	jal ReadFileToSRAM
	jal ADDRalign
	la $a0,P1SQUARE
	la $a3,P1SQUARE_ADDR
	jal ReadFileToSRAM
	jal ADDRalign
	la $a0,P2SQUARE
	la $a3,P2SQUARE_ADDR
	jal ReadFileToSRAM
	jal ADDRalign
	
	# RYU
	la $a0,RYUPIC
	la $a3,RYUPIC_ADDR
	jal ReadFileToSRAM
	jal ADDRalign
	la $a0,RYUNAME
	la $a3,RYUNAME_ADDR
	jal ReadFileToSRAM
	jal ADDRalign

	# HONDA
	la $a0,HONPIC
	la $a3,HONPIC_ADDR
	jal ReadFileToSRAM
	jal ADDRalign
	la $a0,HONNAME
	la $a3,HONNAME_ADDR
	jal ReadFileToSRAM
	jal ADDRalign
	
	# BLANKA
	la $a0,BLAPIC
	la $a3,BLAPIC_ADDR
	jal ReadFileToSRAM
	jal ADDRalign
	la $a0,BLANAME
	la $a3,BLANAME_ADDR
	jal ReadFileToSRAM
	jal ADDRalign
	
	# GUILE
	la $a0,GUIPIC
	la $a3,GUIPIC_ADDR
	jal ReadFileToSRAM
	jal ADDRalign
	la $a0,GUINAME
	la $a3,GUINAME_ADDR
	jal ReadFileToSRAM
	jal ADDRalign
	
	# KEN
	la $a0,KENPIC
	la $a3,KENPIC_ADDR
	jal ReadFileToSRAM
	jal ADDRalign
	la $a0,KENNAME
	la $a3,KENNAME_ADDR
	jal ReadFileToSRAM
	jal ADDRalign
	
	# CHUNLI
	la $a0,CHUPIC
	la $a3,CHUPIC_ADDR
	jal ReadFileToSRAM
	jal ADDRalign
	la $a0,CHUNAME
	la $a3,CHUNAME_ADDR
	jal ReadFileToSRAM
	jal ADDRalign
	
	# ZANGIEF
	la $a0,ZANPIC
	la $a3,ZANPIC_ADDR
	jal ReadFileToSRAM
	jal ADDRalign
	la $a0,ZANNAME
	la $a3,ZANNAME_ADDR
	jal ReadFileToSRAM
	jal ADDRalign
	
	# DHALSIM
	la $a0,DHAPIC
	la $a3,DHAPIC_ADDR
	jal ReadFileToSRAM
	jal ADDRalign
	la $a0,DHANAME
	la $a3,DHANAME_ADDR
	jal ReadFileToSRAM
	jal ADDRalign
	
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	# Imprime o bkg
	lw $a1,OPN_ADDR
	jal PrintBkg
Opening:
	# Pisca o "INSERT COIN"
	lui $a0,170
	addi $a0,$a0,105 
	la $a1,COINS_SIZE
	la $a2,COINS_ADDR
	li $a3,0
	jal PrintSprite
	# Checa teclado
	li $s1,30000 # counter
	jal wait_key

	lui $a0,170
	addi $a0,$a0,105
	la $a1,COINS_SIZE
	la $a2,OPN_ADDR
	jal BkgUpdate
	# Checa teclado
	li $s1,10000 # Contador Delay
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
	sb $zero,0($s6)
	j Select_Screen

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
Select_Screen:

# BEGINNING SET UP
	# Imprime bkg e sprites
	lw $a1,SELECT_ADDR
	jal PrintBkg
	
	move $a0,$s4 # posicao P1SQUARE
	la $a1,SQUARE_SIZE
	la $a2,P1SQUARE_ADDR
	li $a3,0
	jal PrintSprite
	
	move $a0,$s5 # posicao P2SQUARE
	la $a1,SQUARE_SIZE
	la $a2,P2SQUARE_ADDR
	li $a3,0
	jal PrintSprite
	
	# Imprime o Ryu para P1
	lui $a0,124
	addi $a0,$a0,0
	la $a1,PIC_SIZE
	la $a2,RYUPIC_ADDR
	li $a3,0
	jal PrintSprite
	
	lui $a0,110
	addi $a0,$a0,15
	la $a1,NAME_SIZE
	la $a2,RYUNAME_ADDR
	li $a3,0
	jal PrintSprite
	
	# Imprime o Ken para P2
	lui $a0,124
	addi $a0,$a0,214
	la $a1,PIC_SIZE
	la $a2,KENPIC_ADDR
	li $a3,1
	jal PrintSprite
	
	lui $a0,110
	addi $a0,$a0,225
	la $a1,NAME_SIZE
	la $a2,KENNAME_ADDR
	li $a3,0
	jal PrintSprite
	
# KEYBOARD LOOP
Select_Loop:
	# Pisca os SQUARE
	move $a0,$s4 # posicao P1SQUARE
	la $a1,SQUARE_SIZE
	la $a2,SELECT_ADDR
	jal BkgUpdate
	move $a0,$s5 # posicao P2SQUARE
	la $a1,SQUARE_SIZE
	la $a2,SELECT_ADDR
	jal BkgUpdate
	# Checa teclado
	li $s1,10000 # Contador Delay
	jal SLwait_key
	
	move $a0,$s4 # posicao P1SQUARE
	la $a1,SQUARE_SIZE
	la $a2,P1SQUARE_ADDR
	li $a3,0
	jal PrintSprite
	move $a0,$s5 # posicao P2SQUARE
	la $a1,SQUARE_SIZE
	la $a2,P2SQUARE_ADDR
	li $a3,0
	jal PrintSprite
	# Checa teclado
	li $s1,14000 # counter
	jal SLwait_key
	j Select_Loop
	
	SLwait_key:  
	subi $s1,$s1,1 # Contador Delay
	bgtz $s1,SLwait_key_act # $s1 > 0 ?
	jr $ra
	
	SLwait_key_act:
	lw $a0,0($s6)
	andi $a0,$a0,0x01
	beq $a0,$zero,SLwait_key
	
	move $a0,$s4 # posicao P1SQUARE
	la $a1,SQUARE_SIZE
	la $a2,SELECT_ADDR
	jal BkgUpdate
	move $a0,$s5 # posicao P2SQUARE
	la $a1,SQUARE_SIZE
	la $a2,SELECT_ADDR
	jal BkgUpdate
	
	lw $a0,4($s6) # caracter pressionado
	andi $a0,$a0,0xFF # 1 byte do buffer
	jal SelectUpdate
	j Select_Loop
	
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

BkgUpdate:	#($a0 = posX(cat)posY, $a1 = tamanho, $a2 = endereco SRAM do bkg)	#ALTERA: $a0,$a1,$a2,$v0,$s7
											#	 $t0,$t1,$t2,$t3,$t4,
											#	 $t5,$t6,$t7,$t8,$t9
	lb $t0,0($a1)		# $t0 = TamY SPRITE
	lb $t1,1($a1)		# $t1 = TamX SPRITE
	lw $t2,0($a2)		# $t2 = ENDERECO NA SRAM
	
	move $t3,$zero		# $t3 = 0 (Índice do loop externo)
	move $t4,$zero		# $t4 = 0 (Índice do loop interno)

	li $t6,320		# $t6 = 320 (width in pixels)
	srl $t5,$a0,16		# $t5 = pos-x
	mul $t5,$t5,$t6		# $t5 = 320 * x (pos eixo x no display)
	andi $a0,$a0,0xFFFF	# $a0 = pos-y
	add $t5,$t5,$a0		# $t5 = $t5 + $a3 (offset de memoria do inicio de onde é pra ser desenhada a sprite)
	
	add $t2,$t2,$t5		# endereço inicial de impressão do bkg
	move $t6,$t2		# $t6 = $t7 ($t6 é usado como auxiliar do início da linha)
	
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
	addi $t2,$t6,320	# Move a posição inicial $t2 do bkg pra próxima linha
	move $t6,$t2		# $t6 = $t2 ($t2 -> aux)
	addi $t3,$t3,1		# $t3++ (INDICE DO OUTER_LOOP++)
	move $t4,$zero		# $t4 = 0 (zera o índice do inner loop)
	j BUouter_loop		
	
	BUend_outer_loop:
	jr $ra			# Fim do procedimento


PrintSprite:	#($a0 = posX(cat)posY, $a1 = tamanho, $a2 = label da estrutura .data, $a3 = inverte?)	#ALTERA: $a0,$a1,$a2,$a3,$v0,$s7
													#	 $t0,$t1,$t2,$t3,$t4,
													#	 $t5,$t6,$t7,$t8,$t9
	lb $t0,0($a1)		# $t0 = TamY SPRITE
	lb $t1,1($a1)		# $t1 = TamX SPRITE
	lw $t2,0($a2)		# $t2 = ENDERECO NA SRAM
	
	move $t3,$zero		# $t3 = 0 (Índice do loop externo)
	move $t4,$zero		# $t4 = 0 (Índice do loop interno)
	
	li $t6,320		# $t6 = 320 (width in pixels)
	srl $t5,$a0,16		# $t5 = pos-x
	mul $t5,$t5,$t6		# $t5 = 320 * x (pos eixo x no display)
	andi $a0,$a0,0xFFFF	# $a0 = pos-y
	add $t5,$t5,$a0		# $t5 = $t5 + $a3 (offset de memoria do inicio de onde é pra ser desenhada a sprite)
	
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


SelectUpdate:	#($a0 = tecla pressionada - 1 byte)					#ALTERA: $ra,$sp,$s4,$s5,
											# 	 $t0,$t1,$t2,$t3,$t4,$t5
											# 	 $t6,$t7,$a0,$a1,$a2,$a3
	
	addi $sp, $sp, -4 # salva $ra
	sw  $ra, 0($sp)
	
	# Player 1
	add $t0,$zero,0x0061 # caracter "a"
	beq $a0,$t0,SU_P1esquerda
	add $t1,$zero,0x0077 # caracter "w"
	beq $a0,$t1,SU_P1cima
	add $t2,$zero,0x0064 # caracter "d"
	beq $a0,$t2,SU_P1direita
	add $t3,$zero,0x0073 # caracter "s"
	beq $a0,$t3,SU_P1baixo
	
	# Player 2
	add $t4,$zero,0x006A # caracter "j"
	beq $a0,$t4,SU_P2esquerda
	add $t5,$zero,0x0069 # caracter "i"
	beq $a0,$t5,SU_P2cima
	add $t6,$zero,0x006C # caracter "l"
	beq $a0,$t6,SU_P2direita
	add $t7,$zero,0x006B # caracter "k"
	beq $a0,$t7,SU_P2baixo
	j SUexit # nenhuma das teclas mapeadas
	
######### Player 1
	SU_P1esquerda:
	andi $t0,$s4,0xFFFF # $t0 = P1square_posX
	beq $t0,103,SUexit # primeira coluna de personagens
	
	lui $a0,124
	addi $a0,$a0,0
	la $a1,PIC_SIZE
	la $a2,SELECT_ADDR
	jal BkgUpdate
	lui $a0,110
	addi $a0,$a0,15
	la $a1,NAME_SIZE
	la $a2,SELECT_ADDR
	jal BkgUpdate
	
	move $t8,$s4
	addi $s4,$s4,-27 # P1square move 27 pixels p/ esquerda
	
	# $t8 = $s4 antigo
	beq $t8,0x00A00082, SU_P1Ryu # P1 esta no Honda
	beq $t8,0x00C10082, SU_P1Ken # P1 esta na Chunli
	beq $t8,0x00A0009D, SU_P1Honda # P1 esta no Blanka
	beq $t8,0x00C1009D, SU_P1Chunli # P1 esta no Zangief
	beq $t8,0x00A000B8, SU_P1Blanka # P1 esta no Guile
	beq $t8,0x00C100B8, SU_P1Zangief # P1 esta no Dhalsim
	
	SU_P1cima:
	srl $t0,$s4,16 # $t0 = P1square_posY
	beq $t0,160,SUexit # primeira linha de personagens
	
	lui $a0,124
	addi $a0,$a0,0
	la $a1,PIC_SIZE
	la $a2,SELECT_ADDR
	jal BkgUpdate
	lui $a0,110
	addi $a0,$a0,15
	la $a1,NAME_SIZE
	la $a2,SELECT_ADDR
	jal BkgUpdate
	
	move $t8,$s4
	srl $t0,$s4,16 # $t0 = P1square_posY
	addi $t0,$zero,-33
	sll $t0,$t0,16
	add $s4,$s4,$t0 # P1square move 33 pixels p/ cima
	
	# $t8 = $s4 antigo
	beq $t8,0x00C10067, SU_P1Ryu # P1 esta no Ken
	beq $t8,0x00C10082, SU_P1Honda # P1 esta no Chunli
	beq $t8,0x00C1009D, SU_P1Blanka # P1 esta no Zangief
	beq $t8,0x00C100B8, SU_P1Guile # P1 esta no Dhalsim
	
	SU_P1direita:
	andi $t0,$s4,0xFFFF # $t0 = P1square_posX
	beq $t0,184,SUexit # ultima coluna de personagens
	
	lui $a0,124
	addi $a0,$a0,0
	la $a1,PIC_SIZE
	la $a2,SELECT_ADDR
	jal BkgUpdate
	lui $a0,110
	addi $a0,$a0,15
	la $a1,NAME_SIZE
	la $a2,SELECT_ADDR
	jal BkgUpdate
	
	move $t8,$s4
	addi $s4,$s4,27 # P1square move 27 pixels p/ direita
	
	# $t8 = $s4 antigo
	beq $t8,0x00A00067, SU_P1Honda # P1 esta no Ryu
	beq $t8,0x00C10067, SU_P1Chunli # P1 esta na Ken
	beq $t8,0x00A00082, SU_P1Blanka # P1 esta no Honda
	beq $t8,0x00C10082, SU_P1Zangief # P1 esta no Chunli
	beq $t8,0x00A0009D, SU_P1Guile # P1 esta no Blanka
	beq $t8,0x00C1009D, SU_P1Dhalsim # P1 esta no Zangief
	
	SU_P1baixo:
	srl $t0,$s4,16 # $t0 = P1square_posY
	beq $t0,193,SUexit # ultima linha de personagens
	
	lui $a0,124
	addi $a0,$a0,0
	la $a1,PIC_SIZE
	la $a2,SELECT_ADDR
	jal BkgUpdate
	lui $a0,110
	addi $a0,$a0,15
	la $a1,NAME_SIZE
	la $a2,SELECT_ADDR
	jal BkgUpdate
	
	move $t8,$s4
	srl $t0,$s4,16 # $t0 = P1square_posY
	addi $t0,$zero,33
	sll $t0,$t0,16
	add $s4,$s4,$t0 # P1square move 33 pixels p/ baixo
	
	# $t8 = $s4 antigo
	beq $t8,0x00A00067, SU_P1Ken # P1 esta no Ryu
	beq $t8,0x00A00082, SU_P1Chunli # P1 esta no Honda
	beq $t8,0x00A0009D, SU_P1Zangief # P1 esta no Blanka
	beq $t8,0x00A000B8, SU_P1Dhalsim # P1 esta no Guile
	
	# Atualiza Ryu em P1
	SU_P1Ryu:	
	lui $a0,124
	addi $a0,$a0,0
	la $a1,PIC_SIZE
	la $a2,RYUPIC_ADDR
	li $a3,0
	jal PrintSprite
	lui $a0,110
	addi $a0,$a0,15
	la $a1,NAME_SIZE
	la $a2,RYUNAME_ADDR
	li $a3,0
	jal PrintSprite
	j SUexit
	
	# Atualiza Honda em P1
	SU_P1Honda:	
	lui $a0,124
	addi $a0,$a0,0
	la $a1,PIC_SIZE
	la $a2,HONPIC_ADDR
	li $a3,0
	jal PrintSprite
	lui $a0,110
	addi $a0,$a0,15
	la $a1,NAME_SIZE
	la $a2,HONNAME_ADDR
	li $a3,0
	jal PrintSprite
	j SUexit
	
	# Atualiza Blanka em P1
	SU_P1Blanka:	
	lui $a0,124
	addi $a0,$a0,0
	la $a1,PIC_SIZE
	la $a2,BLAPIC_ADDR
	li $a3,0
	jal PrintSprite
	lui $a0,110
	addi $a0,$a0,15
	la $a1,NAME_SIZE
	la $a2,BLANAME_ADDR
	li $a3,0
	jal PrintSprite
	j SUexit
	
	# Atualiza Guile em P1
	SU_P1Guile:	
	lui $a0,124
	addi $a0,$a0,0
	la $a1,PIC_SIZE
	la $a2,GUIPIC_ADDR
	li $a3,0
	jal PrintSprite
	lui $a0,110
	addi $a0,$a0,15
	la $a1,NAME_SIZE
	la $a2,GUINAME_ADDR
	li $a3,0
	jal PrintSprite
	j SUexit
	
	# Atualiza Ken em P1
	SU_P1Ken:
	lui $a0,124
	addi $a0,$a0,0
	la $a1,PIC_SIZE
	la $a2,KENPIC_ADDR
	li $a3,0
	jal PrintSprite
	lui $a0,110
	addi $a0,$a0,15
	la $a1,NAME_SIZE
	la $a2,KENNAME_ADDR
	li $a3,0
	jal PrintSprite
	j SUexit
	
	# Atualiza Chunli em P1
	SU_P1Chunli:
	lui $a0,124
	addi $a0,$a0,0
	la $a1,PIC_SIZE
	la $a2,CHUPIC_ADDR
	li $a3,0
	jal PrintSprite
	lui $a0,110
	addi $a0,$a0,15
	la $a1,NAME_SIZE
	la $a2,CHUNAME_ADDR
	li $a3,0
	jal PrintSprite
	j SUexit
	
	# Atualiza Zangief em P1
	SU_P1Zangief:
	lui $a0,124
	addi $a0,$a0,0
	la $a1,PIC_SIZE
	la $a2,ZANPIC_ADDR
	li $a3,0
	jal PrintSprite
	lui $a0,110
	addi $a0,$a0,15
	la $a1,NAME_SIZE
	la $a2,ZANNAME_ADDR
	li $a3,0
	jal PrintSprite
	j SUexit
	
	# Atualiza Dhalsim em P1
	SU_P1Dhalsim:
	lui $a0,124
	addi $a0,$a0,0
	la $a1,PIC_SIZE
	la $a2,DHAPIC_ADDR
	li $a3,0
	jal PrintSprite
	lui $a0,110
	addi $a0,$a0,15
	la $a1,NAME_SIZE
	la $a2,DHANAME_ADDR
	li $a3,0
	jal PrintSprite
	j SUexit
	
######### Player 2
	SU_P2esquerda:
	andi $t0,$s5,0xFFFF # $t0 = P2square_posX
	beq $t0,103,SUexit # primeira coluna de personagens
	
	lui $a0,124
	addi $a0,$a0,214
	la $a1,PIC_SIZE
	la $a2,SELECT_ADDR
	jal BkgUpdate
	lui $a0,110
	addi $a0,$a0,225
	la $a1,NAME_SIZE
	la $a2,SELECT_ADDR
	jal BkgUpdate
	
	move $t8,$s5
	addi $s5,$s5,-27 # P2square move 27 pixels p/ esquerda
	
	# $t8 = $s5 antigo
	beq $t8,0x00A00082, SU_P2Ryu # P2 esta no Honda
	beq $t8,0x00C10082, SU_P2Ken # P2 esta na Chunli
	beq $t8,0x00A0009D, SU_P2Honda # P2 esta no Blanka
	beq $t8,0x00C1009D, SU_P2Chunli # P2 esta no Zangief
	beq $t8,0x00A000B8, SU_P2Blanka # P2 esta no Guile
	beq $t8,0x00C100B8, SU_P2Zangief # P2 esta no Dhalsim
	
	SU_P2cima:
	srl $t0,$s5,16 # $t0 = P2square_posY
	beq $t0,160,SUexit # primeira linha de personagens
	
	lui $a0,124
	addi $a0,$a0,214
	la $a1,PIC_SIZE
	la $a2,SELECT_ADDR
	jal BkgUpdate
	lui $a0,110
	addi $a0,$a0,225
	la $a1,NAME_SIZE
	la $a2,SELECT_ADDR
	jal BkgUpdate
	
	move $t8,$s5
	srl $t0,$s5,16 # $t0 = P2square_posY
	addi $t0,$zero,-33
	sll $t0,$t0,16
	add $s5,$s5,$t0 # P2square move 33 pixels p/ cima
	
	# $t8 = $s5 antigo
	beq $t8,0x00C10067, SU_P2Ryu # P2 esta no Ken
	beq $t8,0x00C10082, SU_P2Honda # P2 esta no Chunli
	beq $t8,0x00C1009D, SU_P2Blanka # P2 esta no Zangief
	beq $t8,0x00C100B8, SU_P2Guile # P2 esta no Dhalsim
	
	SU_P2direita:
	andi $t0,$s5,0xFFFF # $t0 = P2square_posX
	beq $t0,184,SUexit # ultima coluna de personagens
	
	lui $a0,124
	addi $a0,$a0,214
	la $a1,PIC_SIZE
	la $a2,SELECT_ADDR
	jal BkgUpdate
	lui $a0,110
	addi $a0,$a0,225
	la $a1,NAME_SIZE
	la $a2,SELECT_ADDR
	jal BkgUpdate
	
	move $t8,$s5
	addi $s5,$s5,27 # P2square move 27 pixels p/ direita
	
	# $t8 = $s5 antigo
	beq $t8,0x00A00067, SU_P2Honda # P2 esta no Ryu
	beq $t8,0x00C10067, SU_P2Chunli # P2 esta na Ken
	beq $t8,0x00A00082, SU_P2Blanka # P2 esta no Honda
	beq $t8,0x00C10082, SU_P2Zangief # P2 esta no Chunli
	beq $t8,0x00A0009D, SU_P2Guile # P2 esta no Blanka
	beq $t8,0x00C1009D, SU_P2Dhalsim # P2 esta no Zangief
	
	SU_P2baixo:
	srl $t0,$s5,16 # $t0 = P2square_posY
	beq $t0,193,SUexit # ultima linha de personagens
	
	lui $a0,124
	addi $a0,$a0,214
	la $a1,PIC_SIZE
	la $a2,SELECT_ADDR
	jal BkgUpdate
	lui $a0,110
	addi $a0,$a0,225
	la $a1,NAME_SIZE
	la $a2,SELECT_ADDR
	jal BkgUpdate
	
	move $t8,$s5
	srl $t0,$s5,16 # $t0 = P2square_posY
	addi $t0,$zero,33
	sll $t0,$t0,16
	add $s5,$s5,$t0 # P2square move 33 pixels p/ baixo
	
	# $t8 = $s5 antigo
	beq $t8,0x00A00067, SU_P2Ken # P2 esta no Ryu
	beq $t8,0x00A00082, SU_P2Chunli # P2 esta no Honda
	beq $t8,0x00A0009D, SU_P2Zangief # P2 esta no Blanka
	beq $t8,0x00A000B8, SU_P2Dhalsim # P2 esta no Guile
	
	# Atualiza Ryu em P2
	SU_P2Ryu:	
	lui $a0,124
	addi $a0,$a0,214
	la $a1,PIC_SIZE
	la $a2,RYUPIC_ADDR
	li $a3,1
	jal PrintSprite
	lui $a0,110
	addi $a0,$a0,225
	la $a1,NAME_SIZE
	la $a2,RYUNAME_ADDR
	li $a3,0
	jal PrintSprite
	j SUexit
	
	# Atualiza Honda em P2
	SU_P2Honda:	
	lui $a0,124
	addi $a0,$a0,214
	la $a1,PIC_SIZE
	la $a2,HONPIC_ADDR
	li $a3,1
	jal PrintSprite
	lui $a0,110
	addi $a0,$a0,225
	la $a1,NAME_SIZE
	la $a2,HONNAME_ADDR
	li $a3,0
	jal PrintSprite
	j SUexit
	
	# Atualiza Blanka em P2
	SU_P2Blanka:	
	lui $a0,124
	addi $a0,$a0,214
	la $a1,PIC_SIZE
	la $a2,BLAPIC_ADDR
	li $a3,1
	jal PrintSprite
	lui $a0,110
	addi $a0,$a0,225
	la $a1,NAME_SIZE
	la $a2,BLANAME_ADDR
	li $a3,0
	jal PrintSprite
	j SUexit
	
	# Atualiza Guile em P2
	SU_P2Guile:	
	lui $a0,124
	addi $a0,$a0,214
	la $a1,PIC_SIZE
	la $a2,GUIPIC_ADDR
	li $a3,1
	jal PrintSprite
	lui $a0,110
	addi $a0,$a0,225
	la $a1,NAME_SIZE
	la $a2,GUINAME_ADDR
	li $a3,0
	jal PrintSprite
	j SUexit
	
	# Atualiza Ken em P2
	SU_P2Ken:
	lui $a0,124
	addi $a0,$a0,214
	la $a1,PIC_SIZE
	la $a2,KENPIC_ADDR
	li $a3,1
	jal PrintSprite
	lui $a0,110
	addi $a0,$a0,225
	la $a1,NAME_SIZE
	la $a2,KENNAME_ADDR
	li $a3,0
	jal PrintSprite
	j SUexit
	
	# Atualiza Chunli em P2
	SU_P2Chunli:
	lui $a0,124
	addi $a0,$a0,214
	la $a1,PIC_SIZE
	la $a2,CHUPIC_ADDR
	li $a3,1
	jal PrintSprite
	lui $a0,110
	addi $a0,$a0,225
	la $a1,NAME_SIZE
	la $a2,CHUNAME_ADDR
	li $a3,0
	jal PrintSprite
	j SUexit
	
	# Atualiza Zangief em P2
	SU_P2Zangief:
	lui $a0,124
	addi $a0,$a0,214
	la $a1,PIC_SIZE
	la $a2,ZANPIC_ADDR
	li $a3,1
	jal PrintSprite
	lui $a0,110
	addi $a0,$a0,225
	la $a1,NAME_SIZE
	la $a2,ZANNAME_ADDR
	li $a3,0
	jal PrintSprite
	j SUexit
	
	# Atualiza Dhalsim em P2
	SU_P2Dhalsim:
	lui $a0,124
	addi $a0,$a0,214
	la $a1,PIC_SIZE
	la $a2,DHAPIC_ADDR
	li $a3,1
	jal PrintSprite
	lui $a0,110
	addi $a0,$a0,225
	la $a1,NAME_SIZE
	la $a2,DHANAME_ADDR
	li $a3,0
	jal PrintSprite
	j SUexit
	
	SUexit:
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

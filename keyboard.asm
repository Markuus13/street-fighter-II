.text

## Player 1
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

## Player 2
.eqv 	ESQ	0x6B000000       #4 -> Andar Esquerda
.eqv 	DIR	0x74000000       #6 -> Andar Direita
.eqv 	CIMA	0x75000000       #8 -> Pular
.eqv 	BAIXO	0x73000000       #5 -> Abaixar
.eqv 	SOCO	0x70000000       #0 -> Soco
.eqv	CHUTE	0x71000000	 #, -> Chute
.eqv	HADUKEN 0xF023F02A	 #HADUKEN

.eqv 	ESQ2	0x00000800       #esq mapeado memoria
.eqv 	DIR2	0x00100000       #dir mapeado memoria
.eqv	CIMA2	0x00200000	 #cima mapeado memoria
.eqv 	BAIXO2	0x00080000       #baixo mapeaado memoria
.eqv	SOCO2	0x00010000	 #soco mapeado memoria
.eqv	CHUTE2	0x00020000	 #chute mapeado memoria


	la $s0,0xFF100100  	#BUFFER1
	la $s1,0xFF100104	#BUFFER2
	la $s2,0xFF100520	#KEY0
	la $s3,0xFF100524	#KEY1
	la $s4,0xFF100528	#KEY2
	la $s5,0xFF10052C	#KEY3

							
KEYBOARD:
	jal LOOP_KEYBOARD
	
	
LOOP_KEYBOARD:	lw $t0,0($s0)
	lw $t1,0($s1)
	sll $t2,$t0,24	#descolando buffer em 24 bits para esquerda
	sll $t3,$t0,16
	lw $t4,0($s2)
	lw $t5,0($s3)
	lw $t6,0($s4)
	lw $t8,0($s5)
	
	beq $t2, ESQ_1,ESQ_1_PRESS
	beq $t2, DIR_1,DIR_1_PRESS
	beq $t2, CIMA_1,CIMA_1_PRESS
	beq $t2, BAIXO_1,BAIXO_1_PRESS
	beq $t2, SOCO_1,SOCO_1_PRESS
	beq $t2, CHUTE_1,CHUTE_1_PRESS
	
	beq $t2, ESQ,ESQ_P2
	beq $t2, DIR,DIR_P2
	beq $t2, CIMA,CIMA_P2
	beq $t2, BAIXO,BAIXO_P2
	beq $t2, SOCO,SOCO2_PRESS
	beq $t2, CHUTE,CHUTE2_PRESS
	

	j LOOP_KEYBOARD
	
ESQ_1_PRESS:

	andi $t4,$t4,A2
    	beq $t4,A2,ANDAR_ESQ_1
    	add $t7,$zero,$zero
    	j LOOP_KEYBOARD
    	
ANDAR_ESQ_1:

	la $t7,0x0E74835A
	j LOOP_KEYBOARD
	   
DIR_1_PRESS:

	andi $t5,$t5,D2
      	beq $t5,D2,ANDAR_DIR_1
    	add $t7,$zero,$zero
    	j LOOP_KEYBOARD
    
ANDAR_DIR_1:

	la $t7,0x0D18E17A
	j LOOP_KEYBOARD
    
CIMA_1_PRESS:

	andi $t4,$t4,W2
	beq $t4,W2,PULAR_1
    	add $t7,$zero,$zero
    	j LOOP_KEYBOARD
	
PULAR_1:

	la $t7,0x0000C18A
	j LOOP_KEYBOARD
	
BAIXO_1_PRESS:

	andi $t4,$t4,S2	
	beq $t4,S2,ABAIXAR_1
    	add $t7,$zero,$zero
    	j LOOP_KEYBOARD
    	
ABAIXAR_1:

	la $t7,0x000BA170
	j LOOP_KEYBOARD

SOCO_1_PRESS:
	
	andi $t5,$t5,N2
	beq $t5,N2,SOCAR_1
    	add $t7,$zero,$zero
    	j LOOP_KEYBOARD

SOCAR_1:
	
	la $t7,0x000050C0
	beq $t0,HADUKEN,HADUKEN_PRESS
	j LOOP_KEYBOARD

CHUTE_1_PRESS:

	andi $t5,$t5,B2
	beq $t5,B2,CHUTAR_1
    	add $t7,$zero,$zero
    	j LOOP_KEYBOARD

CHUTAR_1:

	la $t7,0x000C837E
	j LOOP_KEYBOARD
	
ESQ_P2:
	la $t9,0x2E74835A
	j LOOP_KEYBOARD
	
DIR_P2:
	la $t9,0x2D18E17A
	j LOOP_KEYBOARD

CIMA_P2:
	la $t9,0x0002C18A
	j LOOP_KEYBOARD

BAIXO_P2:
	la $t9,0x002BA170
	j LOOP_KEYBOARD
	
SOCO2_PRESS:
	
	la $t9,0x000250C0
	j LOOP_KEYBOARD

CHUTE2_PRESS:
	
	la $t9,0x000C787E
	beq $t0,HADUKEN,HADUKEN_PRESS
	j LOOP_KEYBOARD


HADUKEN_PRESS:
	la $t6,0x01A829D0
	la $t7,0x7AD28E19
	j LOOP_KEYBOARD

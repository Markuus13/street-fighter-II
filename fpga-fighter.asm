.eqv SD_RYU_BKG_ADDR 	0x00813200
.eqv VGA_INI_ADDR 	0xFF000000
.eqv SRAM_ADDR 		0x10012000
.eqv VGA_QTD_BYTE	76800

.data
.text
main:
	jal printBKG
END: 	j END   

printBKG: # Read background from SD to SRAM
    	la $a0, SD_RYU_BKG_ADDR
    	la $a1, SRAM_ADDR
    	la $a2, VGA_QTD_BYTE
    	li $v0, 49
    	syscall
writeVGA: # Read from SRAM and write to VGA - $a1 = SRAM_ADDR, $t0 = VGA_INI_ADDR
	la $t0, VGA_INI_ADDR	# $t0 = VGA_INI_ADDR
    	lw $t2, 0($a1)		# $t2 = SRAM[0]
    	sw $t2, 0($t0)		# VGA[0] = $t2 = SRAM[0]
    	
	addi $t0, $t0, 4	# VGA++
    	addi $a1, $a1, 4	# SRAM++
    	addi $a2, $a2, -4	# QTD_BYTES--
    	
    	slti $t1, $a2, 1	# QTD_BYTES == 1 ? $t1 = 1 : $t1 = 0
    	beq  $t1, $zero, writeVGA	# if $t1 == 0 then writeVGA
    	
    	# else return (when finished)
    	jr $ra			 
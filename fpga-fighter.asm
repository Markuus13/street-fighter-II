.eqv SD_DATA_ADDR 	0x00813200
.eqv VGA_INI_ADDR 	0xFF000000
.eqv SRAM_ADDR 		0x10012000
.eqv VGA_QTD_BYTE	76800

.data
.text
main:
    la      $a0, SD_DATA_ADDR
    la      $a1, SRAM_ADDR
    la      $a2, VGA_QTD_BYTE
    li      $v0, 49
    syscall

# Copia pra SRAM
    la      $t0, VGA_INI_ADDR
    la      $t1, SRAM_ADDR
    li      $t3, VGA_QTD_BYTE

writeVGA:
    lw      $t2, 0($t1)
    sw      $t2, 0($t0)
    addi    $t0, $t0, 4
    addi    $t1, $t1, 4
    addi    $t3, $t3, -4
    slti    $t4, $t3, 1
    beq     $t4, $zero, writeVGA

end: j end

; Show small values in three familiar bases.
.include "api.inc"
.cpu "6502"
*=$c000
p=$20
 lda #>t
 sta p+1
 jsr CLEAR
 ldx #<t
 stx p
 ldy #0
l:lda (p),y
 beq d
 jsr PUTCHAR
 iny
 bne l
d:jsr WAITKEY
 jmp d
t:.text "BASE CONVERSION",13,13," BIN   DEC  HEX",13,"0000    0   0",13,"0001    1   1",13,"1010   10   A",13,"1111   15   F",13,0

; Show the first perfect numbers with their proper-divisor sums.
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
t:.text "PERFECT NUMBERS",13,13,"6 = 1+2+3",13,"28 = 1+2+4+7+14",13,"496 = 1+2+4+8+16+31+62+124+248",13,0

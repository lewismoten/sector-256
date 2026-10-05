; Euclid's algorithm for the greatest common divisor of 84 and 30.
.include "api.inc"
.cpu "6502"
*=$c000
p=$20
 lda #>s
 sta p+1
r:jsr CLEAR
 ldx #<s
 stx p
 ldy #0
l:lda (p),y
 beq k
 jsr PUTCHAR
 iny
 bne l
k:jsr WAITKEY
 jmp r
s:.text "EUCLID GCD",13,13
 .text "GCD(84,30)",13
 .text "84 = 2 X 30 + 24",13
 .text "30 = 1 X 24 + 6",13
 .text "24 = 4 X 6 + 0",13,13
 .text "GCD = 6",13,0

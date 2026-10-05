; Display the golden ratio and its defining relationship.
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
t:.text "GOLDEN RATIO",13,13,"PHI = 1.6180339887",13,13,"PHI = 1 + 1/PHI",13,0

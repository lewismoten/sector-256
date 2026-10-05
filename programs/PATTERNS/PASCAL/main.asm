; The first six rows of Pascal's triangle.
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
s:.text "PASCAL TRIANGLE",13,13
 .text "          1",13
 .text "         1 1",13
 .text "        1 2 1",13
 .text "       1 3 3 1",13
 .text "      1 4 6 4 1",13
 .text "     1 5 10 10 5 1",13,0

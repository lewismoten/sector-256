; Show three small Pythagorean triples.
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
t:.text "PYTHAGOREAN TRIPLES",13,13,"  A  B  C",13,"  3  4  5",13,"  5 12 13",13,"  8 15 17",13,13,"A*A + B*B = C*C",13,0

; Show Euler's totient values for the first ten positive integers.
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
t:.text "EULER TOTIENT",13,13,"N:   1 2 3 4 5 6 7 8 9 10",13,"PHI: 1 1 2 2 4 2 6 4 6 4",13,0

; Show coefficients for the first few binomial expansions.
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
t:.text "BINOMIAL COEFFICIENTS",13,13,"(A+B)^1  1 1",13,"(A+B)^2  1 2 1",13,"(A+B)^3  1 3 3 1",13,"(A+B)^4  1 4 6 4 1",13,0

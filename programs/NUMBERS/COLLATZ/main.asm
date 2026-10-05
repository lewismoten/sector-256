; Show the Collatz trajectory from six down to one.
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
t:.text "COLLATZ SEQUENCE",13,13,"EVEN: N/2",13,"ODD: 3N+1",13,13,"6 3 10 5 16 8 4 2 1",13,0

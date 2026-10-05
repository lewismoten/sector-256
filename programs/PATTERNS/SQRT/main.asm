; Display perfect squares paired with their integer roots.
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
t:.text "SQUARE ROOTS",13,13,"SQRT 1 = 1",13,"SQRT 4 = 2",13,"SQRT 9 = 3",13,"SQRT 16 = 4",13,"SQRT 25 = 5",13,0

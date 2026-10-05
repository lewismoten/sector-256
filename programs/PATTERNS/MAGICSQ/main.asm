; The classic Lo Shu three-by-three magic square.
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
t:.text "3X3 MAGIC SQUARE",13,13,"8 1 6",13,"3 5 7",13,"4 9 2",13,13,"EACH LINE SUMS TO 15",13,0

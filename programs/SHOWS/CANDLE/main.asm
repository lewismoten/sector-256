; Choose one of four flame silhouettes for a character-art candle.
.include "api.inc"
.cpu "6502"
*=$c000
p=$20
 lda #>t
 sta p+1
r:jsr CLEAR
 ldx #<t
 jsr z
 jsr RANDOM
 and #3
 tax
 lda q,x
 tax
 jsr z
 jsr WAITKEY
 jmp r
z:stx p
 ldy #0
l:lda (p),y
 beq e
 jsr PUTCHAR
 iny
 bne l
e:rts
t:.text "CANDLE",13,"KEY=FLAME",13,13,0
q:.byte <a,<b,<c,<d
a:.text "      *",13,"      |",13,"     | |",13,"    |   |",13,"    |___|",13,0
b:.text "     *",13,"      |",13,"     | |",13,"    |   |",13,"    |___|",13,0
c:.text "       *",13,"      |",13,"     | |",13,"    |   |",13,"    |___|",13,0
d:.text "      +",13,"      |",13,"     | |",13,"    |   |",13,"    |___|",13,0

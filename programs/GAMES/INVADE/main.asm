.include "api.inc"
.cpu "6502"
*=$c000
gun=$02
alien=$03
ptr=$20
 lda #>title
 sta ptr+1
round:
 jsr RANDOM
 and #7
 clc
 adc #1
 sta alien
 lda #4
 sta gun
draw:
 jsr CLEAR
 lda gun
 clc
 adc #48
 sta g
 ldx #<title
 jsr print
key:jsr WAITKEY
 cmp #65
 bne right
 dec gun
 bne draw
 lda #8
 sta gun
 jmp draw
right:cmp #68
 bne fire
 inc gun
 lda gun
 cmp #9
 bne draw
 lda #1
 sta gun
 jmp draw
fire:cmp #32
 bne key
 lda gun
 cmp alien
 beq hit
 ldx #<miss
 bne result
hit:ldx #<win
result:jsr print
again:jsr WAITKEY
 cmp #13
 bne again
 jmp round
print:stx ptr
 ldy #0
l:lda (ptr),y
 beq d
 jsr PUTCHAR
 iny
 bne l
d:rts
title:.text "INVADE A/D SPACE",13,"CANNON "
g:.byte 52
.byte 13,0
win:.text "ZAP! RETURN=NEW",13,0
miss:.text "MISS! RETURN=NEW",13,0

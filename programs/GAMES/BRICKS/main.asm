.include "api.inc"
.cpu "6502"
*=$c000
aim=$02
pin=$03
curve=$04
ptr=$20
 lda #>title
 sta ptr+1
round:
 jsr RANDOM
 and #7
 clc
 adc #1
 sta pin
 jsr RANDOM
 and #1
 sta curve
 lda #4
 sta aim
draw:
 jsr CLEAR
 lda aim
 clc
 adc #48
 sta a
 lda pin
 clc
 adc #48
 sta p
 lda curve
 clc
 adc #46
 sta c
 ldx #<title
 jsr print
key:
 jsr WAITKEY
 cmp #65
 bne right
 lda aim
 cmp #1
 beq key
 dec aim
 jmp draw
right:
 cmp #68
 bne roll
 lda aim
 cmp #8
 beq key
 inc aim
 jmp draw
roll:
 cmp #32
 bne key
 lda aim
 clc
 adc curve
 cmp pin
 beq hit
 ldx #<miss
 bne result
hit: ldx #<win
result: jsr print
again: jsr WAITKEY
 cmp #13
 bne again
 jmp round
print: stx ptr
 ldy #0
l: lda (ptr),y
 beq d
 jsr PUTCHAR
 iny
 bne l
d:rts
title:.text "BRICKS A/D SPACE",13,"PADDLE "
a:.byte 52
.text " CURVE "
c:.byte 46
.text " PINS "
p:.byte 49
.byte 13,0
win:.text "SMASH! RETURN=NEW",13,0
miss:.text "MISS! RETURN=NEW",13,0

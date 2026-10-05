.include "api.inc"
.cpu "6502"
*=$c000
need=$02
speed=$03
ptr=$20
 lda #>title
 sta ptr+1
round:
 jsr RANDOM
 and #3
 clc
 adc #2
 sta need
 lda #0
 sta speed
draw:
 jsr CLEAR
 lda speed
 clc
 adc #48
 sta s
 ldx #<title
 jsr print
key:jsr WAITKEY
 cmp #65
 bne jump
 inc speed
 jmp draw
jump:cmp #32
 bne key
 lda speed
 cmp need
 beq win
 ldx #<lose
 bne result
win:ldx #<won
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
title:.text "HURDLES A=RUN SPACE",13,"SPEED "
s:.byte 48
.byte 13,0
won:.text "CLEAR! RETURN=NEW",13,0
lose:.text "TRIP! RETURN=NEW",13,0

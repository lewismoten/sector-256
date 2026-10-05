.include "api.inc"
.cpu "6502"
*=$c000
balls=$02
score=$03
ptr=$20
 lda #>title
 sta ptr+1
round:
 lda #3
 sta balls
 lda #0
 sta score
draw:
 jsr CLEAR
 lda balls
 clc
 adc #48
 sta b
 lda score
 clc
 adc #48
 sta s
 ldx #<title
 jsr print
key:
 jsr WAITKEY
 cmp #32
 bne key
 inc score
 jsr RANDOM
 and #3
 bne draw
 dec balls
 bne draw
 ldx #<lose
 jsr print
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
title:.text "JUGGLE SPACE",13,"BALLS "
b:.byte 51
.text " SCORE "
s:.byte 48
.byte 13,0
lose:.text "DROP! RETURN=NEW",13,0

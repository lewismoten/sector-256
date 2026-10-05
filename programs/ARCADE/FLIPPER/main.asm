; Hit the flipper under the ball before it drains.
.include "api.inc"
.cpu "6502"
*=$c000
side=$02
score=$03
p=$20
 lda #>title
 sta p+1
round:
 lda #0
 sta score
next:
 jsr RANDOM
 and #1
 sta side
 jsr CLEAR
 lda score
 clc
 adc #48
 sta sd
 ldx #<title
 jsr print
 lda side
 beq left
 ldx #<right
 bne show
left:ldx #<leftball
show:jsr print
key:
 jsr WAITKEY
 ldx side
 beq wanta
 cmp #68
 beq hit
 bne drain
wanta:cmp #65
 bne drain
hit:inc score
 lda score
 cmp #10
 bne next
 jmp round
drain:
 ldx #<lost
 jsr print
again:jsr WAITKEY
 cmp #13
 bne again
 jmp round
print:stx p
 ldy #0
l:lda (p),y
 beq done
 jsr PUTCHAR
 iny
 bne l
done:rts
title:.text "FLIPPER A/D SCORE "
sd:.byte 48
.byte 13,0
leftball:.text "BALL LEFT: FLIP A",13,0
right:.text "BALL RIGHT: FLIP D",13,0
lost:.text "DRAIN! RETURN=NEW",13,0

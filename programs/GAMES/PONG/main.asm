; Return the ball to the side from which it arrives.
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
left:ldx #<balll
show:jsr print
key:jsr WAITKEY
 cmp #65
 beq a
 cmp #68
 bne key
 lda #1
 bne check
a:lda #0
check:cmp side
 bne miss
 inc score
 lda score
 cmp #8
 bne next
 ldx #<win
 bne over
miss:ldx #<lost
over:jsr print
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
title:.text "PONG SCORE "
sd:.byte 48
.byte 13,0
balll:.text "BALL LEFT: A",13,0
right:.text "BALL RIGHT: D",13,0
win:.text "RALLY! RETURN=NEW",13,0
lost:.text "MISS! RETURN=NEW",13,0

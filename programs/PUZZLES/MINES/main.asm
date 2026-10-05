; Clear numbered tiles while one hidden mine changes each field.
.include "api.inc"
.cpu "6502"
*=$c000
mine=$02
score=$03
p=$20
 lda #>title
 sta p+1
round:
 lda #0
 sta score
next:
 jsr RANDOM
 and #7
 clc
 adc #1
 sta mine
 jsr CLEAR
 lda score
 clc
 adc #48
 sta sd
 ldx #<title
 jsr print
pick:jsr WAITKEY
 sec
 sbc #48
 beq pick
 cmp #9
 bcs pick
 cmp mine
 beq boom
 inc score
 lda score
 cmp #5
 bne next
 ldx #<win
 bne over
boom:ldx #<lost
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
title:.text "MINES PICK 1-8",13,"CLEARED "
sd:.byte 48
.byte 13,0
win:.text "CLEAR! RETURN=NEW",13,0
lost:.text "BOOM! RETURN=NEW",13,0

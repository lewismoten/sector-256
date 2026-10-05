; Three throws of five dice; sixes make the score.
.include "api.inc"
.cpu "6502"
*=$c000
rolls=$02
score=$03
p=$20
 lda #>title
 sta p+1
round:
 lda #0
 sta rolls
 sta score
draw:
 jsr CLEAR
 lda rolls
 clc
 adc #48
 sta rd
 lda score
 clc
 adc #48
 sta sd
 ldx #<title
 jsr print
wait:
 jsr WAITKEY
 cmp #32
 bne wait
 inc rolls
 ldx #0
roll:
 jsr RANDOM
 and #7
 cmp #6
 bcc die
 sbc #6
die:
 clc
 adc #49
 sta dice,x
 cmp #54
 bne next
 inc score
next:
 inx
 cpx #5
 bne roll
 lda rolls
 cmp #3
 bne draw
 jsr CLEAR
 lda score
 clc
 adc #48
 sta sd2
 sta sd
 ldx #<final
 jsr print
again:
 jsr WAITKEY
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
title:.text "FIVE DICE SPACE=ROLL",13,"["
dice:.byte 49,49,49,49,49
.text "] ROLL "
rd:.byte 48
.text "/3 SIXES "
sd:.byte 48
.byte 13,0
final:.text "FINAL SIXES "
sd2:.byte 48
.text " RETURN=NEW",13,0

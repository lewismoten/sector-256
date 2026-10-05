; Two players add 1 or 2; hit 10 exactly.
.include "api.inc"
.cpu "6502"
*=$c000
total=$02
player=$03
p=$20
 lda #>title
 sta p+1
round:
 lda #0
 sta total
 lda #1
 sta player
draw:
 jsr CLEAR
 lda total
 clc
 adc #48
 sta td
 lda player
 clc
 adc #48
 sta pd
 ldx #<title
 jsr print
key:jsr WAITKEY
 sec
 sbc #48
 beq key
 cmp #3
 bcs key
 clc
 adc total
 sta total
 cmp #10
 beq win
 bcs lose
 lda player
 eor #3
 sta player
 jmp draw
win:ldx #<won
 bne over
lose:ldx #<lost
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
title:.text "NUM RACE P"
pd:.byte 49
.text " TOTAL "
td:.byte 48
.text " ADD 1/2",13,0
won:.text "TEN! RETURN=NEW",13,0
lost:.text "OVER! RETURN=NEW",13,0

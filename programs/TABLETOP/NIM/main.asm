; Two players take 1-3 counters; the last counter wins.
.include "api.inc"
.cpu "6502"
*=$c000
pile=$02
player=$03
p=$20
 lda #>title
 sta p+1
round:
 lda #9
 sta pile
 lda #1
 sta player
draw:
 jsr CLEAR
 lda pile
 clc
 adc #48
 sta pd
 lda player
 clc
 adc #48
 sta td
 ldx #<title
 jsr print
key:jsr WAITKEY
 sec
 sbc #48
 beq key
 cmp #4
 bcs key
 cmp pile
 bcs last
 sta take
 lda pile
 sec
 sbc take
 sta pile
 lda player
 eor #3
 sta player
 jmp draw
last:cmp pile
 bne key
 ldx #<win
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
title:.text "NIM TAKE 1-3 P"
td:.byte 49
.text " PILE "
pd:.byte 63
.byte 13,0
take:.byte 0
win:.text "LAST COUNTER! RETURN=NEW",13,0

; A compact two-player sowing pit: last stone captures.
.include "api.inc"
.cpu "6502"
*=$c000
stones=$02
player=$03
p=$20
 lda #>title
 sta p+1
round:
 lda #12
 sta stones
 lda #1
 sta player
draw:
 jsr CLEAR
 lda stones
 clc
 adc #48
 sta sd
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
 cmp #4
 bcs key
 cmp stones
 bcs bad
 sta take
 lda stones
 sec
 sbc take
 sta stones
 beq win
 lda player
 eor #3
 sta player
 jmp draw
bad:cmp stones
 bne key
 lda #0
 sta stones
win:
 ldx #<won
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
title:.text "MANCALA 1-3 STONES",13,"P"
pd:.byte 49
.text " PIT "
sd:.byte 49
.byte 13,0
take:.byte 0
won:.text "LAST STONE! RETURN=NEW",13,0

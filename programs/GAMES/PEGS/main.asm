; Make the three available jumps to leave one peg.
.include "api.inc"
.cpu "6502"
*=$c000
move=$02
p=$20
 lda #>title
 sta p+1
round:
 lda #0
 sta move
draw:
 jsr CLEAR
 lda move
 clc
 adc #48
 sta md
 ldx #<title
 jsr print
key:jsr WAITKEY
 sec
 sbc #48
 cmp move
 beq jump
 ldx #<bad
 jsr print
 jmp key
jump:inc move
 lda move
 cmp #3
 bne draw
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
title:.text "PEGS . O O O",13,"JUMP "
md:.byte 48
.text " THEN 1 2",13,0
bad:.text "BLOCKED",13,0
win:.text "ONE PEG! RETURN=NEW",13,0

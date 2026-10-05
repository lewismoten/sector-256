; A tiny Othello endgame: bracket the white row from the right.
.include "api.inc"
.cpu "6502"
*=$c000
p=$20
 lda #>title
 sta p+1
round:
 jsr CLEAR
 ldx #<title
 jsr print
pick:jsr WAITKEY
 cmp #52
 beq flip
 cmp #49
 bcc pick
 cmp #53
 bcs pick
 ldx #<bad
 jsr print
 jmp pick
flip:
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
title:.text "OTHELLO B W W .",13,"PLAY 4 TO FLIP",13,0
bad:.text "NO FLIP",13,0
win:.text "B B B B! RETURN=NEW",13,0

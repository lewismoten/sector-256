; Draw a tiny five-card poker hand.
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
wait:jsr WAITKEY
 cmp #32
 bne wait
 jsr RANDOM
 and #3
 tax
 lda table,x
 tax
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
title:.text "POKER SPACE=DEAL",13,"[?] [?] [?] [?] [?]",13,0
table:.byte <high,<pair,<two,<straight
high:.text "HIGH CARD RETURN=NEW",13,0
pair:.text "PAIR! RETURN=NEW",13,0
two:.text "TWO PAIR! RETURN=NEW",13,0
straight:.text "STRAIGHT! RETURN=NEW",13,0

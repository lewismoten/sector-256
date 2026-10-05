; Scatter randomized worm segments through a text field.
.include "api.inc"
.cpu "6502"
*=$c000
again:
 jsr CLEAR
 lda #>title
 sta $21
 ldx #<title
 jsr text
 ldx #160
worm:
 jsr RANDOM
 and #3
 tay
 lda marks,y
 jsr PUTCHAR
 dex
 bne worm
 jsr WAITKEY
 jmp again
text:
 stx $20
 ldy #0
n:lda ($20),y
 beq e
 jsr PUTCHAR
 iny
 bne n
e:rts
title:.text "WORMS",13,13,"KEY=NEW CRAWL",13,13,0
marks:.text "o-~*"

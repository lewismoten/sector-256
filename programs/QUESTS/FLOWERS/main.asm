; Scatter a fresh field of flower characters.
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
flower:
 jsr RANDOM
 and #3
 tay
 lda marks,y
 jsr PUTCHAR
 dex
 bne flower
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
title:.text "FLOWERS",13,13,"KEY=NEW BLOOMS",13,13,0
marks:.text "*+ox"

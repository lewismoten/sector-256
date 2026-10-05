; Scatter a fresh field of spark characters.
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
spark:
 jsr RANDOM
 and #3
 tay
 lda marks,y
 jsr PUTCHAR
 dex
 bne spark
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
title:.text "SPARKLER",13,13,"KEY=NEW SPARKS",13,13,0
marks:.text ".+*x"

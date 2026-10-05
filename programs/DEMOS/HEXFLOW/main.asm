; Scatter random hexadecimal digits into a compact field.
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
digit:
 jsr RANDOM
 and #15
 tay
 lda hex,y
 jsr PUTCHAR
 dex
 bne digit
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
title:.text "HEX FLOW",13,13,"KEY=NEW STREAM",13,13,0
hex:.text "0123456789ABCDEF"

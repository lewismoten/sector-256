; Scatter a different bubble field with each key.
.include "api.inc"
.cpu "6502"
*=$c000
again:
 jsr CLEAR
 lda #>title
 sta $21
 ldx #<title
 jsr text
 ldx #120
bubble:
 jsr RANDOM
 and #3
 tay
 lda shapes,y
 jsr PUTCHAR
 dex
 bne bubble
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
title:.text "BUBBLES",13,13,"KEY=NEW BUBBLES",13,13,0
shapes:.text "oO@*"

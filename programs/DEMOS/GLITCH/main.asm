; Scatter randomized PETSCII corruption over a title field.
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
noise:
 jsr RANDOM
 and #31
 clc
 adc #'!'
 jsr PUTCHAR
 dex
 bne noise
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
title:.text "GLITCH",13,13,"KEY=CORRUPT",13,13,0

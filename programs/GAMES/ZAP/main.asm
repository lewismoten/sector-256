; Put a small alien target at a random horizontal position.
.include "api.inc"
.cpu "6502"
*=$c000
again:
 jsr CLEAR
 lda #>title
 sta $21
 ldx #<title
 jsr text
 jsr RANDOM
 and #31
 tax
space:dex
 bmi target
 lda #' '
 jsr PUTCHAR
 jmp space
target:lda #'*'
 jsr PUTCHAR
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
title:.text "ZAP",13,13,"ALIEN TARGET:",13,13,0

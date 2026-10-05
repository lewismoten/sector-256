; Pick a random number from one through six.
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
 and #7
 cmp #6
 bcs again
 clc
 adc #'1'
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
title:.text "RANDOM PICK",13,13,"1 TO 6:",13,13,0

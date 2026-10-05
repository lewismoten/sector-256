; Toss a field of random PETSCII confetti.
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
bits:
 jsr RANDOM
 and #31
 clc
 adc #'!'
 jsr PUTCHAR
 dex
 bne bits
 jsr WAITKEY
 jmp again
text:
 stx $20
 ldy #0
next:lda ($20),y
 beq done
 jsr PUTCHAR
 iny
 bne next
done:rts
title:.text "CONFETTI",13,13,"PRESS A KEY FOR ANOTHER BURST",13,13,0

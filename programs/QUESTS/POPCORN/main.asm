; Scatter a fresh field of popping kernels.
.include "api.inc"
.cpu "6502"
*=$c000
again:
 jsr CLEAR
 lda #>title
 sta $21
 ldx #<title
 jsr text
 ldx #180
kernel:
 jsr RANDOM
 and #3
 tay
 lda marks,y
 jsr PUTCHAR
 dex
 bne kernel
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
title:.text "POPCORN",13,13,"KEY=POP AGAIN",13,13,0
marks:.text ".oO*"

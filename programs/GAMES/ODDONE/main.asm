; Find the one B among the As.
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
 and #15
 tax
 ldy #16
grid:
 cpx #0
 bne normal
 lda #'B'
 bne put
normal:lda #'A'
put:jsr PUTCHAR
 dex
 dey
 bne grid
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
title:.text "ODD ONE",13,13,"FIND THE B",13,13,0

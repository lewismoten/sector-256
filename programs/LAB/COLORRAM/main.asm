; Recolor the text screen using color RAM's low four bits.
.include "api.inc"
.cpu "6502"
*=$c000
again:
 jsr CLEAR
 lda #>title
 sta $21
 ldx #<title
 jsr text
 ldx #0
paint:
 jsr RANDOM
 and #15
 sta $d800,x
 inx
 bne paint
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
title:.text "COLOR RAM",13,13,"RANDOM 4-BIT COLORS",13,13,"KEY=RECOLOR",0

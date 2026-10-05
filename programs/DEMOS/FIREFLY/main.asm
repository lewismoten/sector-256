; Scatter random firefly lights through a dark character field.
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
light:
 jsr RANDOM
 and #7
 bne dark
 lda #'*'
 bne put
dark:lda #'.'
put:jsr PUTCHAR
 dex
 bne light
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
title:.text "FIREFLIES",13,13,"KEY=NEW LIGHTS",13,13,0

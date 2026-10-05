; Fill the screen with random diagonal character tiles.
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
tile:
 jsr RANDOM
 and #1
 beq slash
 lda #'X'
 bne put
slash:lda #'/'
put:jsr PUTCHAR
 dex
 bne tile
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
title:.text "TRUCHET",13,13,"KEY=NEW TILES",13,13,0

; The classic random diagonal character maze.
.include "api.inc"
.cpu "6502"
*=$c000
r:jsr CLEAR
 ldx #25
y:ldy #40
x:jsr RANDOM
 and #1
 beq slash
 lda #92
 bne put
slash:lda #47
put:jsr PUTCHAR
 dey
 bne x
 dex
 bne y
 jsr WAITKEY
 jmp r

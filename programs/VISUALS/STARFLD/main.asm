; Random rays rush outward from the center of the starfield.
.include "api.inc"
.cpu "6502"
*=$c000
loop:
 jsr NEWFRAME
 ldx #6
star:
 lda #128
 sta $06
 lda #100
 sta $07
 jsr RANDOM
 sta $08
 jsr RANDOM
 and #127
 clc
 adc #36
 sta $09
 jsr LINE
 dex
 bne star
 jsr POLLKEY
 jsr FLIP
 jmp loop

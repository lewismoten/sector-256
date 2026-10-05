; A falling streak becomes a wide splash near the ground.
.include "api.inc"
.cpu "6502"
*=$c000
x=$02
y=$03
 jsr HIRES
 jsr RANDOM
 sta x
 lda #0
 sta y
loop:
 jsr NEWFRAME
 lda x
 sta $06
 sta $08
 lda y
 sta $07
 clc
 adc #14
 sta $09
 jsr LINE
 lda y
 cmp #160
 bcc fall
 lda x
 sec
 sbc #12
 sta $06
 clc
 adc #24
 sta $08
 lda y
 clc
 adc #14
 sta $07
 sta $09
 jsr LINE
fall:
 lda y
 clc
 adc #6
 sta y
 cmp #184
 bcc keys
 lda #0
 sta y
 jsr RANDOM
 sta x
keys:
 jsr POLLKEY
 jsr FLIP
 jmp loop

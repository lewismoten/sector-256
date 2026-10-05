; A comet crosses the sky with a long diagonal tail.
.include "api.inc"
.cpu "6502"
*=$c000
x=$02
y=$03
 jsr HIRES
 lda #60
 sta x
 lda #55
 sta y
loop:
 jsr NEWFRAME
 lda x
 sec
 sbc #48
 sta $06
 lda y
 sec
 sbc #24
 sta $07
 lda x
 sta $08
 lda y
 sta $09
 jsr LINE
 lda x
 sta $06
 clc
 adc #6
 sta $08
 lda y
 sta $07
 clc
 adc #3
 sta $09
 jsr LINE
 inc x
 inc x
 inc y
 lda x
 cmp #235
 bcc keys
 lda #60
 sta x
 lda #55
 sta y
keys:
 jsr POLLKEY
 jsr FLIP
 jmp loop

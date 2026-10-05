; Three long cloud strokes drift slowly across the bitmap sky.
.include "api.inc"
.cpu "6502"
*=$c000
x=$02
 jsr HIRES
 lda #0
 sta x
loop:
 jsr NEWFRAME
 lda x
 sta $06
 clc
 adc #44
 sta $08
 lda #42
 sta $07
 sta $09
 jsr LINE
 lda x
 clc
 adc #10
 sta $06
 clc
 adc #24
 sta $08
 lda #34
 sta $07
 sta $09
 jsr LINE
 lda x
 clc
 adc #5
 sta $06
 clc
 adc #34
 sta $08
 lda #50
 sta $07
 sta $09
 jsr LINE
 inc x
 lda x
 cmp #210
 bcc keys
 lda #0
 sta x
keys:
 jsr POLLKEY
 jsr FLIP
 jmp loop

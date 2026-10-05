; A small ball rebounds between the bitmap edges.
.include "api.inc"
.cpu "6502"
*=$c000
x=$02
y=$03
dx=$04
dy=$05
 jsr HIRES
 lda #30
 sta x
 sta y
 lda #2
 sta dx
 lda #1
 sta dy
loop:
 jsr NEWFRAME
 lda x
 sta $06
 sta $08
 lda y
 sta $07
 clc
 adc #8
 sta $09
 jsr LINE
 lda x
 sec
 sbc #4
 sta $06
 clc
 adc #8
 sta $08
 lda y
 clc
 adc #4
 sta $07
 sta $09
 jsr LINE
 lda x
 clc
 adc dx
 sta x
 cmp #245
 bcc lowx
 lda #$fe
 sta dx
lowx:
 cmp #10
 bcs movey
 lda #2
 sta dx
movey:
 lda y
 clc
 adc dy
 sta y
 cmp #185
 bcc lowy
 lda #$ff
 sta dy
lowy:
 cmp #10
 bcs keys
 lda #1
 sta dy
keys:
 jsr POLLKEY
 jsr FLIP
 jmp loop

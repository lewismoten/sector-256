; Classic x XOR y character texture across the text screen.
.include "api.inc"
.cpu "6502"
*=$c000
y=$02
x=$03
r:jsr CLEAR
 lda #0
 sta y
a:lda #0
 sta x
b:lda x
 eor y
 and #31
 clc
 adc #32
 jsr PUTCHAR
 inc x
 lda x
 cmp #40
 bne b
 inc y
 lda y
 cmp #25
 bne a
 jsr WAITKEY
 jmp r

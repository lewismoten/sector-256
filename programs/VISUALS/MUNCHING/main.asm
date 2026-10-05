; Munching squares: x XOR y with a changing phase.
.include "api.inc"
.cpu "6502"
*=$c000
y=$02
x=$03
p=$04
r:jsr CLEAR
 lda #0
 sta y
a:lda #0
 sta x
b:lda x
 eor y
 eor p
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
 inc p
 jmp r

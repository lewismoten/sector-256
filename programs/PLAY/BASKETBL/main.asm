.include "api.inc"
.cpu "6502"
*=$c000
target=$02
power=$03
ptr=$20
 lda #>title
 sta ptr+1
round:
 jsr RANDOM
 and #3
 clc
 adc #2
 sta target
 lda #0
 sta power
draw:
 jsr CLEAR
 lda power
 clc
 adc #48
 sta p
 ldx #<title
 jsr print
key:jsr WAITKEY
 cmp #65
 bne shoot
 inc power
 jmp draw
shoot:cmp #32
 bne key
 lda power
 cmp target
 beq win
 ldx #<miss
 bne result
win:ldx #<made
result:jsr print
again:jsr WAITKEY
 cmp #13
 bne again
 jmp round
print:stx ptr
 ldy #0
l:lda (ptr),y
 beq d
 jsr PUTCHAR
 iny
 bne l
d:rts
title:.text "BASKETBL A=POWER",13,"POWER "
p:.byte 48
.byte 13,0
made:.text "SWISH! RETURN=NEW",13,0
miss:.text "RIM! RETURN=NEW",13,0

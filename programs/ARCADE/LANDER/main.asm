; Fire the engine to keep descent speed safe.
.include "api.inc"
.cpu "6502"
*=$c000
h=$02
v=$03
fuel=$04
p=$20
 lda #>title
 sta p+1
round:
 lda #8
 sta h
 lda #0
 sta v
 lda #9
 sta fuel
draw:
 jsr CLEAR
 lda h
 clc
 adc #48
 sta hd
 lda v
 clc
 adc #48
 sta vd
 lda fuel
 clc
 adc #48
 sta fd
 ldx #<title
 jsr print
key:jsr WAITKEY
 cmp #65
 bne fall
 lda fuel
 beq fall
 dec fuel
 lda v
 beq fall
 dec v
fall:inc v
 dec h
 bne draw
 lda v
 cmp #3
 bcc soft
 ldx #<crash
 bne over
soft:ldx #<win
over:jsr print
again:jsr WAITKEY
 cmp #13
 bne again
 jmp round
print:stx p
 ldy #0
l:lda (p),y
 beq done
 jsr PUTCHAR
 iny
 bne l
done:rts
title:.text "LANDER A=THRUST",13,"H"
hd:.byte 56
.text " V"
vd:.byte 48
.text " F"
fd:.byte 57
.byte 13,0
win:.text "LANDED! RETURN=NEW",13,0
crash:.text "CRASH! RETURN=NEW",13,0

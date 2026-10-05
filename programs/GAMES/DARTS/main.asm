.include "api.inc"
.cpu "6502"
*=$c000
target=$02
cross=$03
ptr=$20
 lda #>title
 sta ptr+1
round:
 jsr RANDOM
 and #7
 clc
 adc #1
 sta target
 lda #4
 sta cross
draw:
 jsr CLEAR
 lda cross
 clc
 adc #48
 sta x
 lda target
 clc
 adc #48
 sta t
 ldx #<title
 jsr print
key:
 jsr WAITKEY
 cmp #65
 bne right
 lda cross
 cmp #1
 beq key
 dec cross
 jmp draw
right:
 cmp #68
 bne throw
 lda cross
 cmp #8
 beq key
 inc cross
 jmp draw
throw:
 cmp #32
 bne key
 lda cross
 cmp target
 beq hit
 ldx #<miss
 bne result
hit:ldx #<win
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
title:.text "DARTS A/D SPACE",13,"CROSS "
x:.byte 52
.text " BULL "
t:.byte 49
.byte 13,0
win:.text "BULLSEYE! RETURN=NEW",13,0
miss:.text "MISS! RETURN=NEW",13,0

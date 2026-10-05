.include "api.inc"
.cpu "6502"
*=$c000
x=$02
t=$03
p=$20
 lda #>s
 sta p+1
r:jsr RANDOM
 and #7
 clc
 adc #1
 sta t
 lda #4
 sta x
d:jsr CLEAR
 lda x
 clc
 adc #48
 sta a
 ldx #<s
 jsr q
k:jsr WAITKEY
 cmp #65
 bne z
 dec x
 bne d
 lda #8
 sta x
 jmp d
z:cmp #68
 bne f
 inc x
 lda x
 cmp #9
 bne d
 lda #1
 sta x
 jmp d
f:cmp #32
 bne k
 lda x
 cmp t
 beq w
 ldx #<m
 bne o
w:ldx #<h
o:jsr q
n:jsr WAITKEY
 cmp #13
 bne n
 jmp r
q:stx p
 ldy #0
l:lda (p),y
 beq e
 jsr PUTCHAR
 iny
 bne l
e:rts
s:.text "ESCAPE A/D SPACE",13,"RUNNER "
a:.byte 52
.byte 13,0
h:.text "ESCAPED! RETURN=NEW",13,0
m:.text "CAUGHT! RETURN=NEW",13,0

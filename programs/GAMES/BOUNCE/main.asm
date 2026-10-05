.include "api.inc"
.cpu "6502"
*=$c000
ball=$02
platform=$03
p=$20
 lda #>s
 sta p+1
r:jsr RANDOM
 and #7
 clc
 adc #1
 sta platform
 lda #4
 sta ball
d:jsr CLEAR
 lda ball
 clc
 adc #48
 sta b
 ldx #<s
 jsr q
k:jsr WAITKEY
 cmp #65
 bne z
 dec ball
 bne d
 lda #8
 sta ball
 jmp d
z:cmp #68
 bne f
 inc ball
 lda ball
 cmp #9
 bne d
 lda #1
 sta ball
 jmp d
f:cmp #32
 bne k
 lda ball
 cmp platform
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
s:.text "BOUNCE A/D SPACE",13,"BALL "
b:.byte 52
.byte 13,0
h:.text "LAND! RETURN=NEW",13,0
m:.text "FALL! RETURN=NEW",13,0

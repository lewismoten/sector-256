.include "api.inc"
.cpu "6502"
*=$c000
v=$02
t=$03
p=$20
 lda #>s
 sta p+1
r:jsr RANDOM
 and #3
 clc
 adc #2
 sta t
 lda #0
 sta v
d:jsr CLEAR
 lda v
 clc
 adc #48
 sta x
 ldx #<s
 jsr q
k:jsr WAITKEY
 cmp #65
 bne z
 inc v
 jmp d
z:cmp #68
 bne f
 dec v
 jmp d
f:cmp #32
 bne k
 lda v
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
s:.text "ELEVATOR A/D SPACE",13,"FLOOR "
x:.byte 48
.byte 13,0
h:.text "DELIVERED! RETURN=NEW",13,0
m:.text "WRONG FLOOR! RETURN=NEW",13,0

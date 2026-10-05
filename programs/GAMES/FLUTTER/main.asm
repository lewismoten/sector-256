.include "api.inc"
.cpu "6502"
*=$c000
alt=$02
gap=$03
p=$20
 lda #>s
 sta p+1
r:jsr RANDOM
 and #7
 clc
 adc #1
 sta gap
 lda #4
 sta alt
d:jsr CLEAR
 lda alt
 clc
 adc #48
 sta a
 ldx #<s
 jsr q
k:jsr WAITKEY
 cmp #32
 bne fall
 inc alt
 lda alt
 cmp #9
 bne d
 lda #1
 sta alt
 jmp d
fall:cmp #13
 beq fly
 dec alt
 bne d
 lda #8
 sta alt
 jmp d
fly:lda alt
 cmp gap
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
s:.text "FLUTTER SPACE=UP",13,"ALT "
a:.byte 52
.byte 13,0
h:.text "FLY! RETURN=NEW",13,0
m:.text "FALL! RETURN=NEW",13,0

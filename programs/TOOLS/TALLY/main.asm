; A one-digit table counter controlled with A and Z.
.include "api.inc"
.cpu "6502"
*=$c000
n=$02
p=$20
 lda #>t
 sta p+1
r:lda n
 clc
 adc #48
 sta d
 jsr CLEAR
 ldx #<t
 stx p
 jsr z
k:jsr WAITKEY
 cmp #65
 bne m
 inc n
 lda n
 cmp #10
 bne r
 lda #0
 sta n
 beq r
m:cmp #90
 bne k
 lda n
 beq r
 dec n
 jmp r
z:ldy #0
l:lda (p),y
 beq e
 jsr PUTCHAR
 iny
 bne l
e:rts
t:.text "TALLY COUNTER",13,13,"A=UP  Z=DOWN",13,13,"COUNT: "
d:.byte 48,13,0

; Random coin toss with one-digit running tallies.
.include "api.inc"
.cpu "6502"
*=$c000
h=$02
t=$03
c=$04
p=$20
 lda #>title
 sta p+1
r:jsr CLEAR
 ldx #<title
 jsr z
k:jsr WAITKEY
 cmp #32
 bne k
 jsr RANDOM
 and #1
 sta c
 tax
 lda q,x
 tax
 jsr z
 lda c
 bne tail
 inc h
 lda h
 cmp #10
 bne d
 lda #0
 sta h
 bne d
tail:inc t
 lda t
 cmp #10
 bne d
 lda #0
 sta t
d:ldx #<score
 jsr z
 lda h
 clc
 adc #48
 jsr PUTCHAR
 lda #32
 jsr PUTCHAR
 lda t
 clc
 adc #48
 jsr PUTCHAR
g:jsr WAITKEY
 cmp #13
 bne g
 jmp r
z:stx p
 ldy #0
l:lda (p),y
 beq e
 jsr PUTCHAR
 iny
 bne l
e:rts
title:.text "COIN TOSS SPACE=FLIP",13,0
q:.byte <heads,<tails
heads:.text "HEADS",13,0
tails:.text "TAILS",13,0
score:.text "H T: ",0

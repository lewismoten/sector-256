; Hit the displayed number key five times without a miss.
.include "api.inc"
.cpu "6502"
*=$c000
s=$02
k0=$03
p=$20
 lda #>t
 sta p+1
r:lda #0
 sta s
a:jsr RANDOM
 and #3
 clc
 adc #49
 sta k0
 lda s
 clc
 adc #48
 sta ss
 lda k0
 sta hit
 jsr CLEAR
 ldx #<t
 stx p
 jsr z
k:jsr WAITKEY
 cmp k0
 bne lose
 inc s
 lda s
 cmp #5
 bne a
 ldx #<win
 bne o
lose:ldx #<no
o:jsr z
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
t:.text "WHACK THE NUMBER",13,"SCORE: "
ss:.byte 48
 .text 13,"HIT "
hit:.byte 49,13,0
win:.text "FIVE HITS! RETURN=NEW",13,0
no:.text "MISSED! RETURN=NEW",13,0

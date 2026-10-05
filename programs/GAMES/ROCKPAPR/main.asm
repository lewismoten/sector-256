; Rock-paper-scissors against a random computer choice.
.include "api.inc"
.cpu "6502"
*=$c000
c=$02
y=$03
p=$20
 lda #>t
 sta p+1
r:jsr RANDOM
 and #3
 cmp #3
 beq r
 sta c
 jsr CLEAR
 ldx #<t
 jsr z
 ldx c
 lda q,x
 tax
 jsr z
k:jsr WAITKEY
 cmp #82
 beq a
 cmp #80
 beq paper
 cmp #83
 bne k
 lda #2
 bne d
a:lda #0
 beq d
paper:lda #1
d:sta y
 lda c
 asl
 clc
 adc c
 clc
 adc y
 tax
 lda v,x
 tax
 jsr z
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
t:.text "ROCK=R PAPER=P SCISSORS=S",13,"CPU PICKS ",0
q:.byte <rock,<paper0,<scissor
rock:.text "ROCK",13,0
paper0:.text "PAPER",13,0
scissor:.text "SCISSORS",13,0
v:.byte <draw,<lose,<win,<win,<draw,<lose,<lose,<win,<draw
draw:.text "DRAW! RETURN=NEW",13,0
win:.text "YOU WIN! RETURN=NEW",13,0
lose:.text "YOU LOSE! RETURN=NEW",13,0

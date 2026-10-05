; A tiny draw-or-stand blackjack round against a dealer total.
.include "api.inc"
.cpu "6502"
*=$c000
a=$02
b=$03
t=$04
p=$20
 lda #>s
 sta p+1
r:jsr RANDOM
 and #7
 clc
 adc #12
 sta a
 jsr RANDOM
 and #7
 clc
 adc #15
 sta b
 jsr v
k:jsr WAITKEY
 cmp #72
 bne stand
 jsr RANDOM
 and #7
 clc
 adc a
 sta a
 cmp #22
 bcc r0
 ldx #<lose
 bne out
r0:jsr v
 jmp k
stand:cmp #83
 bne k
 lda b
 cmp #22
 bcs won
 lda a
 cmp b
 bcc l
 beq d
won:
 ldx #<win
 bne out
l:ldx #<lose
 bne out
d:ldx #<draw
out:jsr z
g:jsr WAITKEY
 cmp #13
 bne g
 jmp r
v:jsr CLEAR
 ldx #<s
 jsr z
 lda a
 jsr n
 ldx #<m
 jsr z
 lda b
n:sta t
 ldx #0
u:cmp #10
 bcc e
 sbc #10
 inx
 bne u
e:pha
 txa
 clc
 adc #48
 jsr PUTCHAR
 pla
 clc
 adc #48
 jsr PUTCHAR
 rts
z:stx p
 ldy #0
q:lda (p),y
 beq e0
 jsr PUTCHAR
 iny
 bne q
e0:rts
s:.text "21 H/S",13,"YOU ",0
m:.text " DEALER ",0
win:.text 13,"YOU WIN! RETURN=NEW",13,0
lose:.text 13,"BUST/LOSE RETURN=NEW",13,0
draw:.text 13,"DRAW! RETURN=NEW",13,0

; Type the two decimal digits of each displayed PETSCII letter code.
.include "api.inc"
.cpu "6502"
*=$c000
s=$02
p=$20
 lda #>t
 sta p+1
r:lda #0
 sta s
a:ldx s
 lda q,x
 tax
 jsr CLEAR
 jsr z
k:jsr WAITKEY
 ldx s
 cmp v,x
 bne bad
 inc s
 lda s
 cmp #8
 bne a
 ldx #<w
 bne o
bad:ldx #<n
o:jsr z
g:jsr WAITKEY
 cmp #13
 bne g
 jmp r
z:stx p
 ldy #0
l:lda (p),y
 beq d
 jsr PUTCHAR
 iny
 bne l
d:rts
t:.text "PETSCII QUIZ",13,"TYPE TWO DIGITS",13,0
q:.byte <a1,<a1,<a2,<a2,<a3,<a3,<a4,<a4
v:.byte 54,53,57,48,54,55,56,56
a1:.text "A CODE?",13,0
a2:.text "Z CODE?",13,0
a3:.text "C CODE?",13,0
a4:.text "X CODE?",13,0
w:.text "GREAT! RETURN=NEW",13,0
n:.text "TRY AGAIN RETURN=NEW",13,0

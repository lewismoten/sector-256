; Give one of four short answers to a yes-or-no question.
.include "api.inc"
.cpu "6502"
*=$c000
c=$02
p=$20
 lda #>t
 sta p+1
r:jsr RANDOM
 and #3
 sta c
 jsr CLEAR
 ldx #<t
 jsr z
 ldx c
 lda q,x
 tax
 jsr z
k:jsr WAITKEY
 cmp #32
 beq r
 jmp k
z:stx p
 ldy #0
l:lda (p),y
 beq e
 jsr PUTCHAR
 iny
 bne l
e:rts
t:.text "ASK A YES/NO QUESTION",13,13,"SPACE=ASK AGAIN",13,13,0
q:.byte <yes,<no,<maybe,<later
yes:.text "YES",13,0
no:.text "NO",13,0
maybe:.text "MAYBE",13,0
later:.text "ASK LATER",13,0

; Complete three simple number sequences.
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
 cmp #3
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
t:.text "NUMBER SEQUENCE",13,0
q:.byte <a1,<a2,<a3
v:.byte 56,55,57
a1:.text "2 4 6 ?",13,0
a2:.text "1 3 5 ?",13,0
a3:.text "3 5 7 ?",13,0
w:.text "GREAT! RETURN=NEW",13,0
n:.text "TRY AGAIN RETURN=NEW",13,0

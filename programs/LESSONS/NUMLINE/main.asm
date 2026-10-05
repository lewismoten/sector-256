; Read the marked value on three small number lines.
.include "api.inc"
.cpu "6502"
*=$c000
s=$02
p=$20
 lda #>t
 sta p+1
r:lda #0
 sta s
a:jsr CLEAR
 ldx #<t
 jsr z
 ldx s
 lda q,x
 tax
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
t:.text "NUMBER LINE",13,"TYPE THE MARKED VALUE",13,0
q:.byte <a1,<a2,<a3
v:.byte 51,54,57
a1:.text "0 1 2 3 4 5",13,"      ^",13,"VALUE?",13,0
a2:.text "0 1 2 3 4 5 6",13,"            ^",13,"VALUE?",13,0
a3:.text "5 6 7 8 9",13,"        ^",13,"VALUE?",13,0
w:.text "GREAT! RETURN=NEW",13,0
n:.text "TRY AGAIN RETURN=NEW",13,0

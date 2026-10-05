; Home-row typing drill.
.include "api.inc"
.cpu "6502"
*=$c000
s=$02
p=$20
 lda #>t
 sta p+1
r:lda #0
 sta s
 jsr CLEAR
 ldx #<t
 stx p
 jsr z
k:jsr WAITKEY
 ldx s
 cmp q,x
 bne n
 inc s
 lda s
 cmp #4
 bne k
 ldx #<w
 bne o
n:ldx #<x
o:jsr z
g:jsr WAITKEY
 cmp #13
 bne g
 jmp r
z:ldy #0
l:lda (p),y
 beq d
 jsr PUTCHAR
 iny
 bne l
d:rts
q:.text "ASDF"
t:.text "HOME ROW: TYPE ASDF",13,0
w:.text "GOOD! RETURN=NEW",13,0
x:.text "START AGAIN RETURN=NEW",13,0

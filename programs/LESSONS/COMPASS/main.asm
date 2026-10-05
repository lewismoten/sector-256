; Identify cardinal directions from their arrows.
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
 cmp #4
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
t:.text "COMPASS N E S W",13,0
q:.byte <a1,<a2,<a3,<a4
v:.byte 78,69,83,87
a1:.text "^",13,"DIRECTION ?",13,0
a2:.text ">",13,"DIRECTION ?",13,0
a3:.text "V",13,"DIRECTION ?",13,0
a4:.text "<",13,"DIRECTION ?",13,0
w:.text "GREAT! RETURN=NEW",13,0
n:.text "TRY AGAIN RETURN=NEW",13,0

; Name one note on a staff.
.include "api.inc"
.cpu "6502"
*=$c000
p=$20
 lda #>t
 sta p+1
r:jsr CLEAR
 ldx #<t
 stx p
 jsr z
k:jsr WAITKEY
 cmp #69
 bne n
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
t:.text "NOTE READER",13,"-----",13,"  O",13,"-----",13,"NAME NOTE?",13,0
w:.text "E IS RIGHT! RETURN=NEW",13,0
x:.text "THIS NOTE IS E",13,0

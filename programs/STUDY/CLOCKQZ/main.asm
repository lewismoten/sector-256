; Read a compact analog clock face.
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
 cmp #51
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
t:.text "CLOCK QUIZ",13,"     12",13,"  9 --O 3",13,"      6",13,"WHAT HOUR?",13,0
w:.text "3 O CLOCK! RETURN=NEW",13,0
x:.text "LOOK RIGHT. RETURN=NEW",13,0

; Estimate a line angle from a character drawing.
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
 cmp #52
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
t:.text "ANGLE ESTIMATE",13,"     /",13,"    /",13,"45 DEGREES? TYPE 4",13,0
w:.text "RIGHT! RETURN=NEW",13,0
x:.text "TRY 4. RETURN=NEW",13,0

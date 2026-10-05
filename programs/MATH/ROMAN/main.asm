; Show the Roman numerals from one through ten.
.include "api.inc"
.cpu "6502"
*=$c000
p=$20
 lda #>t
 sta p+1
 jsr CLEAR
 ldx #<t
 stx p
 ldy #0
l:lda (p),y
 beq d
 jsr PUTCHAR
 iny
 bne l
d:jsr WAITKEY
 jmp d
t:.text "ROMAN NUMERALS",13,13,"1 I    2 II",13,"3 III  4 IV",13,"5 V    6 VI",13,"7 VII  8 VIII",13,"9 IX  10 X",13,0

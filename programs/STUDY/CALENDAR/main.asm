; A month calendar reference.
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
 jsr WAITKEY
 jmp r
z:ldy #0
l:lda (p),y
 beq d
 jsr PUTCHAR
 iny
 bne l
d:rts
t:.text "MARCH 2026",13,"SU MO TU WE TH FR SA",13," 1  2  3  4  5  6  7",13," 8  9 10 11 12 13 14",13,"15 16 17 18 19 20 21",13,"22 23 24 25 26 27 28",13,"29 30 31",13,"KEY=REFRESH",13,0

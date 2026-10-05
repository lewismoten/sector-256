; Display common sine values as decimal approximations.
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
t:.text "SINE TABLE",13,13,"DEG   SIN",13,"  0  0.00",13," 30  0.50",13," 45  0.71",13," 60  0.87",13," 90  1.00",13,0

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
t:.text "BINARY CLOCK",13,13,"8 4 2 1",13,"0 1 0 1 = 5",13,"0 1 1 0 = 6",13,"0 1 1 1 = 7",13,0

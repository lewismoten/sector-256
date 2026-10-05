; A three-level character-mode Sierpinski carpet.
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
t:.text "SIERPINSKI CARPET",13,13,"*** *** ***",13,"* * * * * *",13,"*** *** ***",13,"   ***",13,"*** *** ***",13,"* * * * * *",13,"*** *** ***",13,0

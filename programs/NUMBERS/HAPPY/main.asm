; Introduce happy numbers and list the first few examples.
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
t:.text "HAPPY NUMBERS",13,13,"SQUARE DIGITS UNTIL 1",13,13,"FIRST: 1 7 10 13 19",13,"23 28 31 32 44",13,0

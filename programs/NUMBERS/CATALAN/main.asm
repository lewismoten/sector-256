; List the first Catalan numbers and a familiar interpretation.
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
t:.text "CATALAN NUMBERS",13,13,"1 1 2 5 14 42",13,"132 429",13,13,"COUNT PARENTHESIS FORMS",13,0

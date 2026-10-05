; Display factorial values through eight factorial.
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
t:.text "FACTORIALS",13,13,"1! 1    2! 2",13,"3! 6    4! 24",13,"5! 120  6! 720",13,"7! 5040 8! 40320",13,0

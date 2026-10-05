; Modular multiplication circle and tables.
.include "api.inc"
.cpu "6502"
*=$c000
p=$20
 lda #<t
 sta p
 lda #>t
 sta p+1
 jsr CLEAR
 ldy #0
l:lda (p),y
 beq d
 jsr PUTCHAR
 iny
 bne l
d:jsr WAITKEY
 jmp d
t:.text "TIMES TABLE MOD 12",13,13,"        12",13,"     11    1",13,"   10        2",13," 9    [ X ]   3",13,"   8        4",13,"     7    5",13,"        6",13,13,"2X: 0 2 4 6 8 10",13,"3X: 0 3 6 9",13,"4X: 0 4 8",13,0

; Compact one-through-five multiplication table.
.include "api.inc"
.cpu "6502"
*=$c000
p=$20
 lda #>s
 sta p+1
r:jsr CLEAR
 ldx #<s
 stx p
 ldy #0
l:lda (p),y
 beq k
 jsr PUTCHAR
 iny
 bne l
k:jsr WAITKEY
 jmp r
s:.text "TIMES TABLE 1-5",13,13
 .text "    1  2  3  4  5",13
 .text "1:  1  2  3  4  5",13
 .text "2:  2  4  6  8 10",13
 .text "3:  3  6  9 12 15",13
 .text "4:  4  8 12 16 20",13
 .text "5:  5 10 15 20 25",13,0

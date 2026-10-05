; Odd-number sums that make successive square numbers.
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
s:.text "ODD SUMS MAKE SQUARES",13,13
 .text "1 = 1 X 1",13
 .text "1 + 3 = 4 = 2 X 2",13
 .text "1 + 3 + 5 = 9 = 3 X 3",13
 .text "1 + 3 + 5 + 7 = 16 = 4 X 4",13
 .text "1 + 3 + 5 + 7 + 9 = 25 = 5 X 5",13,0

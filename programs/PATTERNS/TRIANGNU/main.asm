; First ten triangular numbers as sums from one through n.
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
s:.text "TRIANGULAR NUMBERS",13,13
 .text "1 = 1",13,"1+2 = 3",13,"1+2+3 = 6",13
 .text "1+2+3+4 = 10",13,"... +5 = 15",13,"... +6 = 21",13
 .text "... +7 = 28",13,"... +8 = 36",13,"... +9 = 45",13,"... +10 = 55",13,0

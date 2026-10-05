; Three-digit Armstrong numbers equal the sum of digit cubes.
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
s:.text "ARMSTRONG NUMBERS",13,13
 .text "153 = 1^3 + 5^3 + 3^3",13
 .text "370 = 3^3 + 7^3 + 0^3",13
 .text "371 = 3^3 + 7^3 + 1^3",13
 .text "407 = 4^3 + 0^3 + 7^3",13,0

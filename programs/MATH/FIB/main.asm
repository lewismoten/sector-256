; Fibonacci numbers through the unsigned 16-bit limit.
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
s:.text "FIBONACCI TO 16-BIT",13,13
 .text "0  1  1  2  3  5  8  13",13
 .text "21  34  55  89  144  233",13
 .text "377  610  987  1597  2584",13
 .text "4181  6765  10946  17711",13
 .text "28657  46368",13,0

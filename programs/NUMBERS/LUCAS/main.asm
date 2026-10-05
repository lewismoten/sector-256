; Lucas numbers through the unsigned 16-bit limit.
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
s:.text "LUCAS NUMBERS",13,13
 .text "2  1  3  4  7  11  18",13
 .text "29  47  76  123  199",13
 .text "322  521  843  1364",13
 .text "2207  3571  5778",13
 .text "9349  15127  24476  39603",13
 .text "64079",13,0

; A four-digit Kaprekar routine converging to 6174.
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
s:.text "KAPREKAR ROUTINE",13,13
 .text "START: 3524",13
 .text "5432 - 2345 = 3087",13
 .text "8730 - 0378 = 8352",13
 .text "8532 - 2358 = 6174",13
 .text "7641 - 1467 = 6174",13,0

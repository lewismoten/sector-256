; Prime numbers through 97.
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
s:.text "PRIMES TO 97",13,13
 .text "2 3 5 7 11 13 17 19",13
 .text "23 29 31 37 41 43 47",13
 .text "53 59 61 67 71 73 79",13
 .text "83 89 97",13,0

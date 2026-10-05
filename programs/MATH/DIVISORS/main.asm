; Cycle through a few small divisor identities.
.include "api.inc"
.cpu "6502"
*=$c000
f=$02
again:
 jsr CLEAR
 lda #>title
 sta $21
 ldx #<title
 jsr text
 ldx f
 lda lo,x
 sta $20
 lda hi,x
 sta $21
 jsr print
 jsr WAITKEY
 inc f
 lda f
 and #3
 sta f
 jmp again
text:
 stx $20
print:
 ldy #0
n:lda ($20),y
 beq e
 jsr PUTCHAR
 iny
 bne n
e:rts
title:.text "DIVISORS",13,13,0
lo:.byte <a,<b,<c,<d
hi:.byte >a,>b,>c,>d
a:.text "12: 1 2 3 4 6 12",13,13,"KEY=NEXT",0
b:.text "18: 1 2 3 6 9 18",13,13,"KEY=NEXT",0
c:.text "20: 1 2 4 5 10 20",13,13,"KEY=NEXT",0
d:.text "24: 1 2 3 4 6 8 12 24",13,13,"KEY=NEXT",0

; Cycle through four small multiplication facts.
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
title:.text "TIMES DRILL",13,13,0
lo:.byte <a,<b,<c,<d
hi:.byte >a,>b,>c,>d
a:.text "3 X 4 = 12",13,13,"KEY=NEXT",0
b:.text "5 X 6 = 30",13,13,"KEY=NEXT",0
c:.text "7 X 8 = 56",13,13,"KEY=NEXT",0
d:.text "9 X 9 = 81",13,13,"KEY=NEXT",0

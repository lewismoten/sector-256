; Cycle through small coordinate-grid prompts.
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
title:.text "MAP GRID",13,13,"   A B C D",13,"1  . . . .",13,"2  . . . .",13,"3  . . . .",13,13,0
lo:.byte <a,<b,<c,<d
hi:.byte >a,>b,>c,>d
a:.text "FIND: A1",13,"KEY=NEXT",0
b:.text "FIND: C2",13,"KEY=NEXT",0
c:.text "FIND: D3",13,"KEY=NEXT",0
d:.text "FIND: B1",13,"KEY=NEXT",0

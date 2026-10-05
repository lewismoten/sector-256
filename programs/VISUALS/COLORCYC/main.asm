; Step the VIC background color through the sixteen-color palette.
.include "api.inc"
.cpu "6502"
*=$c000
c=$02
again:
 jsr CLEAR
 lda c
 sta $d021
 lda #>title
 sta $21
 ldx #<title
 jsr text
 jsr WAITKEY
 inc c
 lda c
 and #15
 sta c
 jmp again
text:
 stx $20
 ldy #0
n:lda ($20),y
 beq e
 jsr PUTCHAR
 iny
 bne n
e:rts
title:.text "COLOR CYCLE",13,13,"KEY=NEXT COLOR",13,"RUN/STOP=EXIT",0

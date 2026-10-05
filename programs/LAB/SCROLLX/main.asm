; Step VIC-II horizontal fine scroll from zero through seven.
.include "api.inc"
.cpu "6502"
*=$c000
x=$02
again:
 jsr CLEAR
 lda #>title
 sta $21
 ldx #<title
 jsr text
 lda $d016
 and #$f8
 ora x
 sta $d016
 lda x
 clc
 adc #'0'
 jsr PUTCHAR
 jsr WAITKEY
 inc x
 lda x
 and #7
 sta x
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
title:.text "HORIZONTAL SCROLL",13,13,"VIC OFFSET: ",0

; Step an eight-bit x^8+x^6+x^5+x^4+1 LFSR.
.include "api.inc"
.cpu "6502"
*=$c000
s=$02
t=$03
 lda #$a5
 sta s
again:
 jsr CLEAR
 lda #>title
 sta $21
 ldx #<title
 jsr text
 lda s
 sta t
 ldx #8
bits:
 asl t
 bcc zero
 lda #'1'
 bne put
zero:lda #'0'
put:jsr PUTCHAR
 dex
 bne bits
 asl s
 bcc wait
 lda s
 eor #$1d
 sta s
wait:
 jsr WAITKEY
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
title:.text "LFSR",13,13,"SHIFT REGISTER:",13,13,0

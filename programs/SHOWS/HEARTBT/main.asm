; Alternate two character-heart pulses with SID voice 1.
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
 lda #$50
 sta $d400
 lda #$21
 sta $d404
 jsr WAITKEY
 lda #0
 sta $d404
 inc f
 lda f
 and #1
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
title:.text "HEART BEAT",13,13,0
lo:.byte <a,<b
hi:.byte >a,>b
a:.text "   **   **",13,"  **** ****",13,"   *******",13,"    *****",13,"     ***",0
b:.text "    *   *",13,"   *** ***",13,"    *****",13,"     ***",13,"      *",0

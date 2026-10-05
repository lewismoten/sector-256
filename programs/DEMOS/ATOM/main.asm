; A tiny orbiting-electron character demo.
.include "api.inc"
.cpu "6502"
*=$c000
x=$02
 lda #>title
 sta $21
loop:
 jsr CLEAR
 ldx #<title
 stx $20
 jsr text
 ldx x
 lda orbit,x
 jsr PUTCHAR
 jsr WAITKEY
 inc x
 lda x
 and #3
 sta x
 jmp loop
text:
 stx $20
 ldy #0
next:lda ($20),y
 beq done
 jsr PUTCHAR
 iny
 bne next
done:rts
title:.text "ATOM",13,13,"  .     .",13,"    ",0
orbit:.byte '*','+','o','+'

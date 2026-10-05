; Sweep a scanner marker across a short line.
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
 ldx #24
line:
 cpx x
 bne dot
 lda #'#'
 bne put
dot:lda #'.'
put:jsr PUTCHAR
 dex
 bne line
 jsr WAITKEY
 inc x
 lda x
 cmp #24
 bcc save
 lda #0
save:sta x
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
title:.text "SCANNER",13,13,"SWEEP:",13,13,0

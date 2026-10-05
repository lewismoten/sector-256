; Sweep SID voice 1 upward with each key press.
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
 lda #$11
 sta $d405
 lda #$f8
 sta $d406
 lda #$21
 sta $d404
 ldx #0
sweep:
 stx $d400
 jsr WAITKEY
 inx
 bne sweep
 lda #0
 sta $d404
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
title:.text "SID SWEEP",13,13,"KEY=NEXT PITCH",13,"RUN/STOP=EXIT",0

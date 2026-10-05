; Alternate two SID telephone-ring tones.
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
 lda tones,x
 sta $d401
 lda #$12
 sta $d405
 lda #$f8
 sta $d406
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
 ldy #0
n:lda ($20),y
 beq e
 jsr PUTCHAR
 iny
 bne n
e:rts
title:.text "PHONE RING",13,13,"KEY=NEXT TONE",13,"RUN/STOP=EXIT",0
tones:.byte $48,$70

; Alternate two high SID bell pitches.
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
 lda #$41
 sta $d404
 lda #$10
 sta $d405
 lda #$fa
 sta $d406
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
title:.text "BELLS",13,13,"KEY=NEXT BELL",13,"RUN/STOP=EXIT",0
tones:.byte $80,$a0

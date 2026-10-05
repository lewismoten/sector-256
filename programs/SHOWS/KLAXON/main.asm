; A two-tone sawtooth klaxon on SID voice 1.
.include "api.inc"
.cpu "6502"
*=$c000
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
 lda #$80
 sta $d401
 jsr WAITKEY
 lda #$40
 sta $d401
 jsr WAITKEY
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
title:.text "KLAXON",13,13,"HIGH TONE: KEY",13,"LOW TONE:  KEY",13,13,"RUN/STOP=EXIT",0

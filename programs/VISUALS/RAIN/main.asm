; Repaint the text screen with sparse falling-rain characters.
.include "api.inc"
.cpu "6502"
*=$c000
r:ldx #0
a:jsr RANDOM
 and #3
 beq b
 lda #32
 bne c
b:lda #46
c:sta $0400,x
 sta $0500,x
 sta $0600,x
 sta $0700,x
 lda #5
 sta $d800,x
 sta $d900,x
 sta $da00,x
 sta $db00,x
 inx
 bne a
 ldx #0
d:jsr RANDOM
 and #3
 beq e
 lda #32
 bne f
e:lda #46
f:sta $07e8,x
 lda #5
 sta $dbe8,x
 inx
 cpx #232
 bne d
 jsr WAITKEY
 jmp r

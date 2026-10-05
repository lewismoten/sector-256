; Ascending C-major octave on SID voice 1. Press a key to repeat.
.include "api.inc"
.cpu "6502"
*=$c000
p=$20
 lda #15
 sta $d418
 lda #>t
 sta p+1
r:jsr CLEAR
 ldx #<t
 stx p
 jsr z
 ldx #0
n:lda lo,x
 sta $d400
 lda hi,x
 sta $d401
 lda #17
 sta $d404
 jsr d
 lda #0
 sta $d404
 inx
 cpx #8
 bne n
 jsr WAITKEY
 jmp r
d:ldy #32
o:lda #0
i:sec
 sbc #1
 bne i
 dey
 bne o
 rts
z:ldy #0
q:lda (p),y
 beq e
 jsr PUTCHAR
 iny
 bne q
e:rts
lo:.byte $68,$88,$f2,$39,$18,$4c,$e4,$d0
hi:.byte 17,19,21,23,26,29,32,34
t:.text "SID SCALE",13,"KEY=REPEAT",13,0

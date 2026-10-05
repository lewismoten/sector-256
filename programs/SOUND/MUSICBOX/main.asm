; Opening Twinkle phrase on SID voice 1.
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
d:ldy #48
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
lo:.byte $68,$68,$18,$18,$4c,$4c,$18,$4c
hi:.byte 17,17,26,26,29,29,26,29
t:.text "MUSIC BOX",13,"KEY=REPEAT",13,0

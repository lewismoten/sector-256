; Eight rapid C-major arpeggios on SID voice 1.
.include "api.inc"
.cpu "6502"
*=$c000
p=$20
c=$02
 lda #15
 sta $d418
 lda #>t
 sta p+1
r:jsr CLEAR
 ldx #<t
 stx p
 jsr z
 lda #8
 sta c
 ldx #0
n:lda lo,x
 sta $d400
 lda hi,x
 sta $d401
 lda #17
 sta $d404
 jsr d
 inx
 cpx #3
 bne n
 ldx #0
 dec c
 bne n
 lda #0
 sta $d404
 jsr WAITKEY
 jmp r
d:ldy #8
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
lo:.byte $68,$f2,$18
hi:.byte 17,21,26
t:.text "ARPEGGIO",13,"KEY=REPEAT",13,0

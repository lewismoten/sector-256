; Two-note doorbell chime on SID voice 1.
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
 cpx #2
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
lo:.byte $4c,$68
hi:.byte 29,34
t:.text "DING DONG",13,"KEY=REPEAT",13,0

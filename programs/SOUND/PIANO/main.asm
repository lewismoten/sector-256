; Four keyboard keys trigger four SID notes.
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
k:jsr WAITKEY
 cmp #65
 beq a
 cmp #83
 beq s
 cmp #68
 beq d
 cmp #70
 bne k
 ldx #3
 bne n
a:ldx #0
 beq n
s:ldx #1
 bne n
d:ldx #2
n:lda lo,x
 sta $d400
 lda hi,x
 sta $d401
 lda #17
 sta $d404
 jsr wait
 lda #0
 sta $d404
 jmp k
wait:ldy #48
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
lo:.byte $68,$88,$f2,$39
hi:.byte 17,19,21,23
t:.text "PIANO A S D F",13,"PLAY A SCALE",13,0

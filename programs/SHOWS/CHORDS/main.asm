; C, F, and G play major chords on the three SID voices.
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
 cmp #67
 beq c
 cmp #70
 beq f
 cmp #71
 bne k
 ldx #6
 bne n
c:ldx #0
 beq n
f:ldx #3
n:lda lo,x
 sta $d400
 lda hi,x
 sta $d401
 inx
 lda lo,x
 sta $d407
 lda hi,x
 sta $d408
 inx
 lda lo,x
 sta $d40e
 lda hi,x
 sta $d40f
 lda #17
 sta $d404
 sta $d40b
 sta $d412
 jsr wait
 lda #0
 sta $d404
 sta $d40b
 sta $d412
 jmp k
wait:ldy #64
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
lo:.byte $68,$f2,$18,$39,$4c,$e4,$18,$d0,$39
hi:.byte 17,21,26,23,29,34,26,32,23
t:.text "CHORDS C F G",13,"PLAY MAJOR CHORDS",13,0

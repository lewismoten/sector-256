; Sound a short SID tick each time SPACE is pressed.
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
 cmp #32
 bne k
 lda #$00
 sta $d400
 lda #35
 sta $d401
 lda #17
 sta $d404
 jsr d
 lda #0
 sta $d404
 jmp k
d:ldy #20
o:lda #0
i:sec
 sbc #1
 bne i
 dey
 bne o
 rts
z:ldy #0
l:lda (p),y
 beq e
 jsr PUTCHAR
 iny
 bne l
e:rts
t:.text "SID METRONOME",13,13,"SPACE=TICK",13,0

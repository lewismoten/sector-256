; Tap back a three-beat rhythm.
.include "api.inc"
.cpu "6502"
*=$c000
s=$02
p=$20
 lda #0
 sta $d404
 sta $d418
 lda #>t
 sta p+1
r:lda #0
 sta s
 jsr CLEAR
 ldx #<t
 stx p
 jsr z
 lda #15
 sta $d418
 jsr tick
 jsr tick
 jsr tick
k:jsr WAITKEY
 ldx s
 cmp q,x
 bne x
 inc s
 lda s
 cmp #3
 bne k
 ldx #<w
 bne o
x:ldx #<b
o:jsr z
g:jsr WAITKEY
 cmp #13
 bne g
 jmp r
tick:lda #$40
 sta $d400
 lda #20
 sta $d401
 lda #17
 sta $d404
 ldy #20
dly:jsr POLLKEY
 dey
 bne dly
 lda #0
 sta $d404
 rts
z:ldy #0
out:lda (p),y
 beq e
 jsr PUTCHAR
 iny
 bne out
e:rts
q:.text "AAS"
t:.text "RHYTHM: HEAR 3 TICKS",13,"TAP A A S",13,0
w:.text "IN TIME! RETURN=NEW",13,0
b:.text "TRY A A S",13,0

; Hear a C and name it.
.include "api.inc"
.cpu "6502"
*=$c000
p=$20
 lda #0
 sta $d404
 sta $d418
 lda #>t
 sta p+1
r:jsr CLEAR
 ldx #<t
 stx p
 jsr z
 lda #15
 sta $d418
 lda #$68
 sta $d400
 lda #17
 sta $d401
 lda #17
 sta $d404
 jsr d
 lda #0
 sta $d404
k:jsr WAITKEY
 cmp #67
 bne n
 ldx #<w
 bne o
n:ldx #<x
o:jsr z
g:jsr WAITKEY
 cmp #13
 bne g
 jmp r
d:ldy #45
dly:jsr POLLKEY
 dey
 bne dly
 rts
z:ldy #0
out:lda (p),y
 beq e
 jsr PUTCHAR
 iny
 bne out
e:rts
t:.text "PIANO QUIZ",13,"HEAR THE NOTE",13,"TYPE C",13,0
w:.text "C! RETURN=NEW",13,0
x:.text "THAT WAS C",13,0

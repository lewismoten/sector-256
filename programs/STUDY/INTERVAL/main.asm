; Hear C then E and identify a third.
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
 jsr n
 lda #$f2
 sta $d400
 lda #21
 sta $d401
 jsr n
k:jsr WAITKEY
 cmp #51
 bne x
 ldx #<w
 bne o
x:ldx #<b
o:jsr z
g:jsr WAITKEY
 cmp #13
 bne g
 jmp r
n:lda #17
 sta $d404
 ldy #35
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
t:.text "INTERVAL QUIZ",13,"HEAR TWO NOTES",13,"TYPE 3=THIRD",13,0
w:.text "THIRD! RETURN=NEW",13,0
b:.text "C TO E IS THIRD",13,0

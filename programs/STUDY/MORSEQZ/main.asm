; Hear Morse A: dot dash.
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
 jsr dot
 jsr dash
k:jsr WAITKEY
 cmp #65
 bne x
 ldx #<w
 bne o
x:ldx #<b
o:jsr z
g:jsr WAITKEY
 cmp #13
 bne g
 jmp r
dot:ldy #18
 bne tone
dash:ldy #54
tone:lda #$80
 sta $d400
 lda #20
 sta $d401
 lda #17
 sta $d404
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
t:.text "MORSE QUIZ",13,"HEAR .-",13,"TYPE LETTER",13,0
w:.text "A! RETURN=NEW",13,0
b:.text ".- MEANS A",13,0

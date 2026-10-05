; Advance an hour through arithmetic modulo twelve.
.include "api.inc"
.cpu "6502"
*=$c000
h=$02
t=$03
p=$20
 lda #>s
 sta p+1
 lda #1
 sta h
r:jsr CLEAR
 ldx #<s
 jsr z
 lda h
 jsr n
 ldx #<e
 jsr z
k:jsr WAITKEY
 cmp #32
 bne k
 inc h
 lda h
 cmp #13
 bne r
 lda #1
 sta h
 bne r
n:ldx #0
u:cmp #10
 bcc v
 sbc #10
 inx
 bne u
v:pha
 txa
 beq w
 clc
 adc #48
 jsr PUTCHAR
w:pla
 clc
 adc #48
 jsr PUTCHAR
 rts
z:stx p
 ldy #0
l:lda (p),y
 beq d
 jsr PUTCHAR
 iny
 bne l
d:rts
s:.text "MOD 12 CLOCK",13,13,"HOUR: ",0
e:.text 13,13,"SPACE=ADD 1 HOUR",13,0

; Alternate two sampled positions of a quickly moving object.
.include "api.inc"
.cpu "6502"
*=$c000
f=$02
p=$20
 lda #>t
 sta p+1
r:jsr CLEAR
 ldx #<t
 jsr z
 ldx f
 lda q,x
 tax
 jsr z
k:jsr WAITKEY
 inc f
 lda f
 and #1
 sta f
 jmp r
z:stx p
 ldy #0
l:lda (p),y
 beq e
 jsr PUTCHAR
 iny
 bne l
e:rts
t:.text "SAMPLING ALIAS",13,"KEY=NEXT FRAME",13,13,0
q:.byte <a,<b
a:.text "*----------O",13,0
b:.text "O----------*",13,0

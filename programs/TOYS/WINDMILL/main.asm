; Advance a four-frame character-art windmill with SPACE.
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
 cmp #32
 bne k
 inc f
 lda f
 cmp #4
 bne r
 lda #0
 sta f
 beq r
z:stx p
 ldy #0
l:lda (p),y
 beq e
 jsr PUTCHAR
 iny
 bne l
e:rts
t:.text "WINDMILL",13,"SPACE=SPIN",13,13,0
q:.byte <a,<b,<c,<d
a:.text "    /",13,"   /|",13,"  --+--",13,"   |/",13,"  /",13,0
b:.text "   |",13," --+--",13,"   |",13,"   |",13,0
c:.text "  "
 .byte 92,13
 .text "   "
 .byte 92,124,13
 .text "  --+--",13,"   |"
 .byte 92,13
 .text "    "
 .byte 92,13,0
d:.text "   |",13," --+--",13,"   |",13,"   |",13,0

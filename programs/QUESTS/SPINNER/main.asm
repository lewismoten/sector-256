; Pick one of four directions whenever SPACE is pressed.
.include "api.inc"
.cpu "6502"
*=$c000
c=$02
p=$20
 lda #>t
 sta p+1
r:jsr RANDOM
 and #3
 sta c
 jsr CLEAR
 ldx #<t
 jsr z
 ldx c
 lda q,x
 tax
 jsr z
k:jsr WAITKEY
 cmp #32
 beq r
 jmp k
z:stx p
 ldy #0
l:lda (p),y
 beq e
 jsr PUTCHAR
 iny
 bne l
e:rts
t:.text "BOARD GAME SPINNER",13,13,"SPACE=SPIN",13,13,0
q:.byte <north,<east,<south,<west
north:.text "     NORTH",13,0
east:.text "     EAST",13,0
south:.text "     SOUTH",13,0
west:.text "     WEST",13,0

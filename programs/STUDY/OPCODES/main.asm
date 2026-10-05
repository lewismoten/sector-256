; Identify the mnemonic for opcode A9.
.include "api.inc"
.cpu "6502"
*=$c000
p=$20
 lda #>t
 sta p+1
r:jsr CLEAR
 ldx #<t
 stx p
 jsr z
k:jsr WAITKEY
 cmp #76
 bne n
 ldx #<w
 bne o
n:ldx #<x
o:jsr z
g:jsr WAITKEY
 cmp #13
 bne g
 jmp r
z:ldy #0
l:lda (p),y
 beq d
 jsr PUTCHAR
 iny
 bne l
d:rts
t:.text "6502 OPCODE",13,"A9 = ?",13,"L=LOAD A",13,0
w:.text "LDA! RETURN=NEW",13,0
x:.text "A9 IS LDA",13,0

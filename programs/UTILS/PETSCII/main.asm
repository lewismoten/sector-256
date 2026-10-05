; Display a handful of useful PETSCII values.
.include "api.inc"
.cpu "6502"
*=$c000
p=$20
 lda #>t
 sta p+1
 jsr CLEAR
 ldx #<t
 stx p
 ldy #0
l:lda (p),y
 beq d
 jsr PUTCHAR
 iny
 bne l
d:jsr WAITKEY
 jmp d
t:.text "PETSCII REFERENCE",13,13,"SPACE 32",13,"RETURN 13",13,"A 65  B 66  C 67",13,"X 88  Y 89  Z 90",13,0

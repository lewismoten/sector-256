; Show one reverse-and-add route to a palindrome.
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
t:.text "REVERSE AND ADD",13,13,"56 + 65 = 121",13,13,"121 READS THE SAME",13,0

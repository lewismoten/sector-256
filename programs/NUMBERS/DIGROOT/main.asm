; Show repeated digit sums until a single-digit root remains.
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
t:.text "DIGITAL ROOT",13,13,"987",13,"9+8+7 = 24",13,"2+4 = 6",13,13,"ROOT = 6",13,0

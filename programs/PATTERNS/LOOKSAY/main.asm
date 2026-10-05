; Show the early look-and-say sequence, beginning with one.
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
t:.text "LOOK AND SAY",13,13,"1",13,"11  (ONE 1)",13,"21  (TWO 1S)",13,"1211",13,"111221",13,"312211",13,0

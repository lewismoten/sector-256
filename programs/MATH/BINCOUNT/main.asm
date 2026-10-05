; An eight-bit binary counter. Any key advances the value.
.include "api.inc"
.cpu "6502"
*=$c000
n=$02
b=$03
p=$20
 lda #>t
 sta p+1
r:jsr CLEAR
 ldx #<t
 stx p
 jsr z
 lda n
 sta b
 ldx #8
l:asl b
 lda #48
 bcc q
 adc #0
q:jsr PUTCHAR
 dex
 bne l
 jsr WAITKEY
 inc n
 jmp r
z:ldy #0
k:lda (p),y
 beq d
 jsr PUTCHAR
 iny
 bne k
d:rts
t:.text "BINARY COUNTER",13,13,0

; Show the eight processor-port bits that control memory banking.
.include "api.inc"
.cpu "6502"
*=$c000
b=$02
p=$20
 lda #>t
 sta p+1
r:jsr CLEAR
 ldx #<t
 stx p
 jsr z
 lda $01
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
 jmp r
z:ldy #0
k:lda (p),y
 beq e
 jsr PUTCHAR
 iny
 bne k
e:rts
t:.text "PROCESSOR PORT $01",13,"MEMORY BITS: ",0

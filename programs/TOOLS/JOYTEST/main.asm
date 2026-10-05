; Display joystick ports 2 and 1 as active-low UDLRF bits.
.include "api.inc"
.cpu "6502"
*=$c000
b=$02
p=$20
 lda #>t
 sta p+1
r:lda $dc00
 asl
 asl
 asl
 sta b
 ldx #0
a:asl b
 lda #48
 bcc q
 adc #0
q:sta p2,x
 inx
 cpx #5
 bne a
 lda $dc01
 asl
 asl
 asl
 sta b
 ldx #0
c:asl b
 lda #48
 bcc d
 adc #0
d:sta p1,x
 inx
 cpx #5
 bne c
 jsr CLEAR
 ldx #<t
 stx p
 jsr z
 jsr WAITKEY
 jmp r
z:ldy #0
l:lda (p),y
 beq e
 jsr PUTCHAR
 iny
 bne l
e:rts
t:.text "JOYSTICK TEST",13,"UDLRF: 1=OPEN 0=HELD",13,"PORT 2: "
p2:.text "00000",13,"PORT 1: "
p1:.text "00000",13,0

; Toggle two one-bit inputs and view their AND result.
.include "api.inc"
.cpu "6502"
*=$c000
a=$02
b=$03
p=$20
 lda #>t
 sta p+1
r:lda a
 clc
 adc #48
 sta aa
 lda b
 clc
 adc #48
 sta bb
 lda a
 and b
 clc
 adc #48
 sta rr
 jsr CLEAR
 ldx #<t
 stx p
 jsr z
k:jsr WAITKEY
 cmp #65
 bne s
 lda a
 eor #1
 sta a
 jmp r
s:cmp #83
 bne k
 lda b
 eor #1
 sta b
 jmp r
z:ldy #0
q:lda (p),y
 beq e
 jsr PUTCHAR
 iny
 bne q
e:rts
t:.text "LOGIC AND GATE",13,"A=TOGGLE A S=TOGGLE B",13,13,"A="
aa:.byte 48
 .text " B="
bb:.byte 48
 .text " A AND B="
rr:.byte 48,13,0

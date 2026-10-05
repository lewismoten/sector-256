; Two-player one-digit scoreboard: A scores left, L scores right.
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
 sta sa
 lda b
 clc
 adc #48
 sta sb
 jsr CLEAR
 ldx #<t
 stx p
 jsr z
k:jsr WAITKEY
 cmp #65
 bne l
 inc a
 lda a
 cmp #10
 bne r
 lda #0
 sta a
 jmp r
l:cmp #76
 bne k
 inc b
 lda b
 cmp #10
 bne r
 lda #0
 sta b
 jmp r
z:ldy #0
q:lda (p),y
 beq e
 jsr PUTCHAR
 iny
 bne q
e:rts
t:.text "SCOREBOARD",13,13,"PLAYER 1: "
sa:.byte 48
 .text 13,"PLAYER 2: "
sb:.byte 48
 .text 13,13,"A=PLAYER 1  L=PLAYER 2",13,0

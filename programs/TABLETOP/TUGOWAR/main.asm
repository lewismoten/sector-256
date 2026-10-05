; Two-player tug of war: Q pulls left, P pulls right.
.include "api.inc"
.cpu "6502"
*=$c000
x=$02
p=$20
 lda #>t
 sta p+1
r:lda #20
 sta x
d:jsr CLEAR
 ldx #<t
 jsr z
 ldx #10
 ldy x
 clc
 jsr PLOT
 lda #42
 jsr PUTCHAR
k:jsr WAITKEY
 cmp #81
 beq l
 cmp #80
 bne k
 inc x
 lda x
 cmp #39
 beq right
 jmp d
l:dec x
 bne d
 ldx #<leftwin
 bne o
right:ldx #<rightwin
o:jsr z
g:jsr WAITKEY
 cmp #13
 bne g
 jmp r
z:stx p
 ldy #0
n:lda (p),y
 beq e
 jsr PUTCHAR
 iny
 bne n
e:rts
t:.text "TUG O WAR  Q=LEFT P=RIGHT",13,0
leftwin:.text "LEFT WINS! RETURN=NEW",13,0
rightwin:.text "RIGHT WINS! RETURN=NEW",13,0

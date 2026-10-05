; WASD sketchpad; every cursor position leaves a mark.
.include "api.inc"
.cpu "6502"
*=$c000
y=$02
x=$03
 lda #>t
 sta $21
 jsr CLEAR
 ldx #<t
 stx $20
 jsr z
 lda #12
 sta y
 lda #20
 sta x
l:ldx y
 ldy x
 clc
 jsr PLOT
 lda #42
 jsr PUTCHAR
k:jsr WAITKEY
 cmp #87
 bne s
 lda y
 beq l
 dec y
 jmp l
s:cmp #83
 bne a
 lda y
 cmp #24
 beq l
 inc y
 jmp l
a:cmp #65
 bne d
 lda x
 beq l
 dec x
 jmp l
d:cmp #68
 bne c
 lda x
 cmp #39
 beq l
 inc x
 jmp l
c:cmp #67
 bne l
 jsr CLEAR
 jmp l
z:ldy #0
q:lda ($20),y
 beq e
 jsr PUTCHAR
 iny
 bne q
e:rts
t:.text "DOODLE  WASD=DRAW C=CLEAR",13,0

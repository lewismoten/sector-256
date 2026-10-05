; Dragon-curve folds in character mode.
.include "api.inc"
.cpu "6502"
*=$c000
p=$20
 lda #<t
 sta p
 lda #>t
 sta p+1
 jsr CLEAR
 ldy #0
l:lda (p),y
 beq d
 jsr PUTCHAR
 iny
 bne l
d:jsr WAITKEY
 jmp d
t:.text "DRAGON FOLDS",13,13,"       +--+",13,"    +--+  |",13,"    |  +--+",13," +--+",13," |  |",13," +--+  +--+",13,"     |  |",13,"     +--+",13,13,"PRESS RUN/STOP",0

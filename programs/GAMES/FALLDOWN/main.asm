; Line up with each gap before the floor rises.
.include "api.inc"
.cpu "6502"
*=$c000
you=$02
gap=$03
score=$04
p=$20
 lda #>title
 sta p+1
round:
 lda #4
 sta you
 lda #0
 sta score
next:
 jsr RANDOM
 and #7
 clc
 adc #1
 sta gap
draw:
 jsr CLEAR
 lda you
 clc
 adc #48
 sta yd
 lda gap
 clc
 adc #48
 sta gd
 lda score
 clc
 adc #48
 sta sd
 ldx #<title
 jsr print
key:
 jsr WAITKEY
 cmp #65
 bne right
 lda you
 cmp #1
 beq draw
 dec you
 jmp draw
right:
 cmp #68
 bne drop
 lda you
 cmp #8
 beq draw
 inc you
 jmp draw
drop:
 cmp #32
 bne key
 lda you
 cmp gap
 bne crash
 inc score
 lda score
 cmp #10
 bne next
 jmp round
crash:
 ldx #<lost
 jsr print
again:
 jsr WAITKEY
 cmp #13
 bne again
 jmp round
print:
 stx p
 ldy #0
l:lda (p),y
 beq done
 jsr PUTCHAR
 iny
 bne l
done:rts
title:.text "FALL DOWN A/D SPACE",13,"GAP "
gd:.byte 49
.text " YOU "
yd:.byte 52
.text " SCORE "
sd:.byte 48
.byte 13,0
lost:.text "CRASH! RETURN=NEW",13,0

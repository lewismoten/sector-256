; Keep stepping before the tile beneath you crumbles.
.include "api.inc"
.cpu "6502"
*=$c000
you=$02
lava=$03
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
 sta lava
draw:
 jsr CLEAR
 lda you
 clc
 adc #48
 sta yd
 lda lava
 clc
 adc #48
 sta ld
 lda score
 clc
 adc #48
 sta sd
 ldx #<title
 jsr print
key:jsr WAITKEY
 cmp #65
 beq left
 cmp #68
 bne key
 lda you
 cmp #8
 beq key
 inc you
 jmp step
left:lda you
 cmp #1
 beq key
 dec you
step:lda you
 cmp lava
 beq burn
 inc score
 jmp next
burn:
 ldx #<lost
 jsr print
again:jsr WAITKEY
 cmp #13
 bne again
 jmp round
print:stx p
 ldy #0
l:lda (p),y
 beq done
 jsr PUTCHAR
 iny
 bne l
done:rts
title:.text "LAVA A/D MOVE",13,"YOU "
yd:.byte 52
.text " LAVA "
ld:.byte 49
.text " SCORE "
sd:.byte 48
.byte 13,0
lost:.text "BURN! RETURN=NEW",13,0

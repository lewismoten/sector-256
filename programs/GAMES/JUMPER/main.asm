; Charge a jump high enough for every approaching obstacle.
.include "api.inc"
.cpu "6502"
*=$c000
need=$02
jump=$03
score=$04
p=$20
 lda #>title
 sta p+1
round:
 lda #0
 sta score
next:
 jsr RANDOM
 and #3
 clc
 adc #1
 sta need
 lda #0
 sta jump
draw:
 jsr CLEAR
 lda need
 clc
 adc #48
 sta nd
 lda jump
 clc
 adc #48
 sta jd
 lda score
 clc
 adc #48
 sta sd
 ldx #<title
 jsr print
key:jsr WAITKEY
 cmp #65
 bne leap
 inc jump
 lda jump
 cmp #5
 bne draw
 lda #0
 sta jump
 jmp draw
leap:cmp #32
 bne key
 lda jump
 cmp need
 bcc crash
 inc score
 jmp next
crash:
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
title:.text "JUMPER A=CHARGE SPACE",13,"WALL "
nd:.byte 49
.text " JUMP "
jd:.byte 48
.text " SCORE "
sd:.byte 48
.byte 13,0
lost:.text "CRASH! RETURN=NEW",13,0

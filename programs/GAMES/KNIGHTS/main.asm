; Four keys make the forward knight moves on a 4x4 board.
.include "api.inc"
.cpu "6502"
*=$c000
c=$02
r=$03
p=$20
 lda #>title
 sta p+1
round:
 lda #2
 sta c
 lda #1
 sta r
draw:
 jsr CLEAR
 lda c
 clc
 adc #48
 sta cd
 lda r
 clc
 adc #48
 sta rd
 ldx #<title
 jsr print
wait:jsr WAITKEY
 cmp #65
 beq a
 cmp #68
 beq d
 cmp #74
 beq j
 cmp #76
 bne wait
 lda c
 cmp #3
 bcc wait
 sec
 sbc #2
 sta c
 jmp down
a:lda c
 cmp #4
 beq wait
 inc c
 lda r
 clc
 adc #2
 sta r
 jmp check
d:lda c
 beq wait
 dec c
 lda r
 clc
 adc #2
 sta r
 jmp check
j:lda c
 cmp #3
 bcs wait
 clc
 adc #2
 sta c
down:inc r
check:
 lda r
 cmp #5
 bcs wait
 lda c
 cmp #3
 bne draw
 lda r
 cmp #4
 bne draw
 ldx #<win
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
title:.text "KNIGHT A D J L",13,"C"
cd:.byte 50
.text " R"
rd:.byte 49
.text " GOAL C3 R4",13,0
win:.text "TOUR! RETURN=NEW",13,0

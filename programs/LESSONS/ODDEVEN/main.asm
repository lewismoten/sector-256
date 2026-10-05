; Mark random numbers odd or even.
.include "api.inc"
.cpu "6502"
*=$c000
number=$02
score=$03
p=$20
 lda #>title
 sta p+1
round:
 lda #0
 sta score
next:
 jsr RANDOM
 and #7
 clc
 adc #1
 sta number
 clc
 adc #48
 sta nd
 jsr CLEAR
 ldx #<title
 jsr print
key:jsr WAITKEY
 ldx number
 txa
 and #1
 beq even
 cmp #79
 bne wrong
 jmp right
even:cmp #69
 bne wrong
right:inc score
 lda score
 cmp #3
 bne next
 ldx #<win
 bne say
wrong:ldx #<no
say:jsr print
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
title:.text "ODD OR EVEN? O/E "
nd:.byte 49
.byte 13,0
win:.text "GREAT! RETURN=NEW",13,0
no:.text "TRY AGAIN RETURN=NEW",13,0

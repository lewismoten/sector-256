; Count the stars, then enter the number.
.include "api.inc"
.cpu "6502"
*=$c000
count=$02
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
 sta count
 jsr CLEAR
 ldx #<title
 jsr print
 ldx count
stars:lda #42
 jsr PUTCHAR
 dex
 bne stars
 lda #13
 jsr PUTCHAR
key:jsr WAITKEY
 sec
 sbc #48
 cmp count
 bne wrong
 inc score
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
title:.text "COUNT THE STARS",13,0
win:.text "GREAT! RETURN=NEW",13,0
no:.text "TRY AGAIN RETURN=NEW",13,0

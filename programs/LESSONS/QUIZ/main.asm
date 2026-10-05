; Three short addition questions.
.include "api.inc"
.cpu "6502"
*=$c000
score=$02
answer=$03
p=$20
 lda #>title
 sta p+1
round:
 lda #0
 sta score
ask:
 jsr CLEAR
 ldx score
 lda questions,x
 tax
 jsr print
key:jsr WAITKEY
 sec
 sbc #48
 sta answer
 lda score
 asl
 clc
 adc #4
 cmp answer
 bne wrong
 inc score
 lda score
 cmp #3
 bne ask
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
title:.text "QUIZ",13,0
questions:.byte <q1,<q2,<q3
q1:.text "2+2=",0
q2:.text "3+3=",0
q3:.text "4+4=",0
win:.text "PERFECT! RETURN=NEW",13,0
no:.text "TRY AGAIN RETURN=NEW",13,0

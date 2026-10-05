; Choose the next letter in three small sequences.
.include "api.inc"
.cpu "6502"
*=$c000
score=$02
p=$20
 lda #>title
 sta p+1
round:
 lda #0
 sta score
ask:
 ldx score
 lda questions,x
 tax
 jsr CLEAR
 jsr print
key:jsr WAITKEY
 ldx score
 cmp answers,x
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
title:.text "ALPHABET",13,0
questions:.byte <q1,<q2,<q3
answers:.byte 67,70,73
q1:.text "A B ?",13,0
q2:.text "D E ?",13,0
q3:.text "G H ?",13,0
win:.text "GREAT! RETURN=NEW",13,0
no:.text "TRY AGAIN RETURN=NEW",13,0

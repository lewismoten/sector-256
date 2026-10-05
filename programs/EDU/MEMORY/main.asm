; Recall a short number sequence.
.include "api.inc"
.cpu "6502"
*=$c000
step=$02
p=$20
 lda #>title
 sta p+1
round:
 lda #0
 sta step
 jsr CLEAR
 ldx #<title
 jsr print
key:jsr WAITKEY
 sec
 sbc #48
 ldx step
 cmp sequence,x
 bne wrong
 inc step
 lda step
 cmp #3
 bne key
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
title:.text "MEMORY: 1 2 3",13,"TYPE IT",13,0
sequence:.byte 1,2,3
win:.text "CORRECT! RETURN=NEW",13,0
no:.text "TRY AGAIN RETURN=NEW",13,0

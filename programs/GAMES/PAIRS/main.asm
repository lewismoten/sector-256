; Find three pairs; each round shuffles the matching parity.
.include "api.inc"
.cpu "6502"
*=$c000
first=$02
score=$03
p=$20
 lda #>title
 sta p+1
round:
 lda #0
 sta score
draw:
 jsr CLEAR
 lda score
 clc
 adc #48
 sta sd
 ldx #<title
 jsr print
one:jsr WAITKEY
 sec
 sbc #48
 beq one
 cmp #5
 bcs one
 sta first
two:jsr WAITKEY
 sec
 sbc #48
 beq two
 cmp #5
 bcs two
 cmp first
 beq two
 eor first
 and #1
 bne miss
 inc score
 lda score
 cmp #3
 beq win
 ldx #<hit
 bne say
miss:ldx #<no
say:jsr print
 jmp draw
win:ldx #<won
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
title:.text "PAIRS [ ][ ][ ][ ]",13,"FOUND "
sd:.byte 48
.byte 13,0
hit:.text "PAIR!",13,0
no:.text "NO MATCH",13,0
won:.text "THREE PAIRS! RETURN=NEW",13,0

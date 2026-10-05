; Cards 1/3 and 2/4 form the two hidden pairs.
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
pick1:jsr WAITKEY
 sec
 sbc #48
 beq pick1
 cmp #5
 bcs pick1
 sta first
pick2:jsr WAITKEY
 sec
 sbc #48
 beq pick2
 cmp #5
 bcs pick2
 cmp first
 beq pick2
 eor first
 and #1
 bne miss
 inc score
 lda score
 cmp #2
 beq win
 ldx #<hit
 bne result
miss:ldx #<no
result:jsr print
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
title:.text "MATCH 1-4: [ ][ ][ ][ ]",13,"PAIRS "
sd:.byte 48
.byte 13,0
hit:.text "PAIR!",13,0
no:.text "MISS!",13,0
won:.text "ALL PAIRS! RETURN=NEW",13,0

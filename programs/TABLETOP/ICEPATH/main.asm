; Slide until a wall stops you; land on the exit.
.include "api.inc"
.cpu "6502"
*=$c000
x=$02
y=$03
p=$20
 lda #>title
 sta p+1
round:
 lda #3
 sta x
 sta y
draw:
 jsr CLEAR
 ldx #<title
 jsr print
 ldy #1
row:
 ldx #1
col:
 txa
 cmp x
 bne empty
 tya
 cmp y
 bne empty
 lda #64
 bne put
empty:
 cpx #5
 bne dot
 cpy #5
 bne dot
 lda #88
 bne put
dot:lda #46
put:jsr PUTCHAR
 inx
 cpx #6
 bne col
 lda #13
 jsr PUTCHAR
 iny
 cpy #6
 bne row
wait:
 jsr WAITKEY
 cmp #65
 beq left
 cmp #68
 beq right
 cmp #87
 beq up
 cmp #83
 bne wait
 lda #5
 sta y
 bne check
left:lda #1
 sta x
 bne check
right:lda #5
 sta x
 bne check
up:lda #1
 sta y
check:
 lda x
 cmp #5
 bne draw
 lda y
 cmp #5
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
title:.text "ICE PATH A/D W/S",13,0
win:.text "EXIT! RETURN=NEW",13,0

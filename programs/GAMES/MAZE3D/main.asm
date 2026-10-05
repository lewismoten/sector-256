; Pick the open corridor at each wireframe junction.
.include "api.inc"
.cpu "6502"
*=$c000
path=$02
steps=$03
p=$20
 lda #>title
 sta p+1
round:
 lda #0
 sta steps
next:
 jsr RANDOM
 and #1
 sta path
 jsr CLEAR
 lda steps
 clc
 adc #48
 sta sd
 ldx #<title
 jsr print
 lda path
 beq left
 ldx #<right
 bne show
left:ldx #<openl
show:jsr print
key:jsr WAITKEY
 cmp #65
 beq a
 cmp #68
 bne key
 lda #1
 bne check
a:lda #0
check:cmp path
 bne wall
 inc steps
 lda steps
 cmp #5
 bne next
 ldx #<win
 bne over
wall:ldx #<lost
over:jsr print
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
title:.text "MAZE 3D A/D STEP "
sd:.byte 48
.byte 13,0
openl:.text "| OPEN LEFT |",13,0
right:.text "| OPEN RIGHT |",13,0
win:.text "OUT! RETURN=NEW",13,0
lost:.text "WALL! RETURN=NEW",13,0

; Only the next passage is visible in this dark maze.
.include "api.inc"
.cpu "6502"
*=$c000
door=$02
depth=$03
p=$20
 lda #>title
 sta p+1
round:
 lda #0
 sta depth
next:
 jsr RANDOM
 and #1
 sta door
 jsr CLEAR
 lda depth
 clc
 adc #48
 sta dd
 ldx #<title
 jsr print
 lda door
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
check:cmp door
 bne lost
 inc depth
 lda depth
 cmp #6
 bne next
 ldx #<win
 bne over
lost:ldx #<dead
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
title:.text "DARK MAZE DEPTH "
dd:.byte 48
.byte 13,0
openl:.text "GLOW LEFT",13,0
right:.text "GLOW RIGHT",13,0
win:.text "EXIT! RETURN=NEW",13,0
dead:.text "LOST! RETURN=NEW",13,0

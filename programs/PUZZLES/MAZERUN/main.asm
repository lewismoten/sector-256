; Follow five open turns before seven moves run out.
.include "api.inc"
.cpu "6502"
*=$c000
door=$02
left=$03
depth=$04
p=$20
 lda #>title
 sta p+1
round:
 lda #7
 sta left
 lda #0
 sta depth
next:
 jsr RANDOM
 and #1
 sta door
 jsr CLEAR
 lda left
 clc
 adc #48
 sta ld
 ldx #<title
 jsr print
 lda door
 beq openl
 ldx #<right
 bne show
openl:ldx #<leftopen
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
 bne miss
 inc depth
 lda depth
 cmp #5
 beq win
miss:dec left
 bne next
 ldx #<lost
 bne over
win:ldx #<won
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
title:.text "MAZE RUN MOVES "
ld:.byte 55
.byte 13,0
leftopen:.text "OPEN LEFT",13,0
right:.text "OPEN RIGHT",13,0
won:.text "ESCAPE! RETURN=NEW",13,0
lost:.text "TIME! RETURN=NEW",13,0

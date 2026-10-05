; Flash five dots briefly, then ask for the count.
.include "api.inc"
.cpu "6502"
*=$c000
p=$20
 lda #>flash
 sta p+1
r:jsr CLEAR
 ldx #<flash
 stx p
 jsr z
 jsr d
 jsr CLEAR
 ldx #<ask
 stx p
 jsr z
k:jsr WAITKEY
 cmp #53
 bne no
 ldx #<win
 bne o
no:ldx #<bad
o:jsr z
g:jsr WAITKEY
 cmp #13
 bne g
 jmp r
d:ldy #96
waito:lda #0
waiti:sec
 sbc #1
 bne waiti
 dey
 bne waito
 rts
z:stx p
 ldy #0
l:lda (p),y
 beq e
 jsr PUTCHAR
 iny
 bne l
e:rts
flash:.text "* * * * *",13,0
ask:.text "HOW MANY DOTS?",13,0
win:.text "RIGHT! RETURN=NEW",13,0
bad:.text "TRY AGAIN RETURN=NEW",13,0

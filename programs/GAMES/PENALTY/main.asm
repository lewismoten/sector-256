; Choose a corner; a random keeper blocks one of three choices.
.include "api.inc"
.cpu "6502"
*=$c000
k0=$02
p=$20
 lda #>t
 sta p+1
r:jsr RANDOM
 and #3
 cmp #3
 beq r
 sta k0
 jsr CLEAR
 ldx #<t
 stx p
 jsr z
a:jsr WAITKEY
 cmp #49
 bcc a
 cmp #52
 bcs a
 sec
 sbc #49
 cmp k0
 beq save
 ldx #<goal
 bne o
save:ldx #<no
o:jsr z
g:jsr WAITKEY
 cmp #13
 bne g
 jmp r
z:stx p
 ldy #0
l:lda (p),y
 beq e
 jsr PUTCHAR
 iny
 bne l
e:rts
t:.text "PENALTY SHOOT",13,"1=LEFT 2=CENTER 3=RIGHT",13,0
goal:.text "GOAL! RETURN=NEW",13,0
no:.text "SAVED! RETURN=NEW",13,0

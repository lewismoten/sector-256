; Memorize a three-digit sequence, then type it back.
.include "api.inc"
.cpu "6502"
*=$c000
s=$02
p=$20
 lda #>show
 sta p+1
r:jsr CLEAR
 ldx #<show
 jsr z
w:jsr WAITKEY
 cmp #13
 bne w
 lda #0
 sta s
a:jsr CLEAR
 ldx #<ask
 jsr z
k:jsr WAITKEY
 ldx s
 cmp q,x
 bne bad
 inc s
 lda s
 cmp #3
 bne a
 ldx #<win
 bne o
bad:ldx #<no
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
show:.text "MEMORIZE: 3 7 1",13,"RETURN=HIDE",13,0
ask:.text "TYPE THE NUMBER",13,0
q:.byte 51,55,49
win:.text "GREAT! RETURN=NEW",13,0
no:.text "MISSED! RETURN=NEW",13,0

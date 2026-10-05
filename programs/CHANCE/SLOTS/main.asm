; Three-reel slot machine; SPACE spins, triple match wins.
.include "api.inc"
.cpu "6502"
*=$c000
a=$02
b=$03
c=$04
p=$20
 lda #>t
 sta p+1
r:jsr CLEAR
 ldx #<t
 jsr z
k:jsr WAITKEY
 cmp #32
 bne k
 jsr RANDOM
 and #3
 sta a
 jsr RANDOM
 and #3
 sta b
 jsr RANDOM
 and #3
 sta c
 jsr CLEAR
 ldx #<s
 jsr z
 ldx a
 lda q,x
 jsr PUTCHAR
 lda #32
 jsr PUTCHAR
 ldx b
 lda q,x
 jsr PUTCHAR
 lda #32
 jsr PUTCHAR
 ldx c
 lda q,x
 jsr PUTCHAR
 lda a
 cmp b
 bne lose
 cmp c
 bne lose
 ldx #<win
 bne o
lose:ldx #<no
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
t:.text "SLOTS SPACE=SPIN",13,0
s:.text "SPINNING...",13,0
q:.text "7O*$"
win:.text 13,"JACKPOT! RETURN=NEW",13,0
no:.text 13,"NO MATCH RETURN=NEW",13,0

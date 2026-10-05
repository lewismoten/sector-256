; Randomly select a compact fortune-cookie message.
.include "api.inc"
.cpu "6502"
*=$c000
p=$20
 lda #>t
 sta p+1
r:jsr CLEAR
 ldx #<t
 jsr z
 jsr RANDOM
 and #3
 tax
 lda q,x
 tax
 jsr z
 jsr WAITKEY
 jmp r
z:stx p
 ldy #0
l:lda (p),y
 beq e
 jsr PUTCHAR
 iny
 bne l
e:rts
t:.text "FORTUNE COOKIE",13,13,0
q:.byte <a,<b,<c,<d
a:.text "YES. THE STARS AGREE.",13,0
b:.text "TRY AGAIN TOMORROW.",13,0
c:.text "FOLLOW THE BLUE PATH.",13,0
d:.text "LUCK FAVORS PATIENCE.",13,0

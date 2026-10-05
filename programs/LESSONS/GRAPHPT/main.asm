; Read the coordinates of a marked point on a five-by-five grid.
.include "api.inc"
.cpu "6502"
*=$c000
s=$02
p=$20
 lda #>t
 sta p+1
r:lda #0
 sta s
a:ldx s
 lda q,x
 tax
 jsr CLEAR
 jsr z
k:jsr WAITKEY
 ldx s
 cmp v,x
 bne bad
 inc s
 lda s
 cmp #2
 bne a
 ldx #<w
 bne o
bad:ldx #<n
o:jsr z
g:jsr WAITKEY
 cmp #13
 bne g
 jmp r
z:stx p
 ldy #0
l:lda (p),y
 beq d
 jsr PUTCHAR
 iny
 bne l
d:rts
t:.text "GRAPH POINT",13,13,"    1 2 3 4 5",13,"  1 . . . . .",13,"  2 . . . X .",13,"  3 . . . . .",13,"  4 . . . . .",13,"  5 . . . . .",13,13,0
q:.byte <x,<y
v:.byte 52,50
x:.text "X COORDINATE?",13,0
y:.text "Y COORDINATE?",13,0
w:.text "RIGHT! RETURN=NEW",13,0
n:.text "TRY AGAIN RETURN=NEW",13,0

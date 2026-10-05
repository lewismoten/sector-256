; Set VIC border/background colors with B/G and keys 0-7.
.include "api.inc"
.cpu "6502"
*=$c000
s=$02
p=$20
 lda #>t
 sta p+1
r:jsr CLEAR
 ldx #<t
 jsr z
 ldx s
 lda q,x
 tax
 jsr z
k:jsr WAITKEY
 cmp #66
 bne g
 lda #0
 sta s
 jmp r
g:cmp #71
 bne n
 lda #1
 sta s
 jmp r
n:cmp #48
 bcc k
 cmp #56
 bcs k
 sec
 sbc #48
 ldy s
 sta $d020,y
 jmp r
z:stx p
 ldy #0
l:lda (p),y
 beq e
 jsr PUTCHAR
 iny
 bne l
e:rts
t:.text "COLOR SET",13,"B=BORDER G=BACKGROUND",13,"0-7 CHANGES COLOR",13,0
q:.byte <b,<g0
b:.text "TARGET: BORDER",13,0
g0:.text "TARGET: BACKGROUND",13,0

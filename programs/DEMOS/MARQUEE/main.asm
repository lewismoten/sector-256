; A small chasing-light text marquee.
.include "api.inc"
.cpu "6502"
*=$c000
x=$02
again:
 jsr CLEAR
 lda #>top
 sta $21
 ldx #<top
 jsr text
 ldx x
 lda dots,x
 jsr PUTCHAR
 lda #>bottom
 sta $21
 ldx #<bottom
 jsr text
 jsr WAITKEY
 inc x
 lda x
 and #3
 sta x
 jmp again
text:
 stx $20
 ldy #0
l:lda ($20),y
 beq e
 jsr PUTCHAR
 iny
 bne l
e:rts
top:.text "MARQUEE",13,13,"****************",13,"* CHASING LIGHT *",13,"*",0
bottom:.text "*",13,"****************",13,13,"KEY=NEXT",0
dots:.text "+o*o"

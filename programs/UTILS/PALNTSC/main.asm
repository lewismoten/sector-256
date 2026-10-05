; Report the KERNAL PAL/NTSC video-standard flag at $02a6.
.include "api.inc"
.cpu "6502"
*=$c000
p=$20
 lda #>t
 sta p+1
r:jsr CLEAR
 ldx #<t
 stx p
 jsr z
 lda $02a6
 beq n
 ldx #<pal
 bne o
n:ldx #<ntsc
o:jsr z
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
t:.text "VIDEO STANDARD",13,0
pal:.text "PAL (50 HZ)",13,0
ntsc:.text "NTSC (60 HZ)",13,0

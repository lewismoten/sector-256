; Alternate two compact credit pages.
.include "api.inc"
.cpu "6502"
*=$c000
p=$02
again:
 jsr CLEAR
 ldx p
 lda lo,x
 sta $20
 lda hi,x
 sta $21
 jsr print
 jsr WAITKEY
 inc p
 lda p
 and #1
 sta p
 jmp again
print:
 ldy #0
n:lda ($20),y
 beq e
 jsr PUTCHAR
 iny
 bne n
e:rts
lo:.byte <a,<b
hi:.byte >a,>b
a:.text "SECTOR 256",13,13,"CODE: SIZECODERS",13,13,"ART: PIXEL CREW",13,13,"SOUND: SID PLAYERS",13,13,"KEY=NEXT",0
b:.text "THANKS",13,13,"A TINY DISK",13,"FULL OF IDEAS",13,13,"C64 FOREVER",13,13,"KEY=FIRST PAGE",0

; Alternate two simple concentric character-ring frames.
.include "api.inc"
.cpu "6502"
*=$c000
f=$02
again:
 jsr CLEAR
 ldx f
 lda lo,x
 sta $20
 lda hi,x
 sta $21
 jsr print
 jsr WAITKEY
 inc f
 lda f
 and #1
 sta f
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
a:.text "HYPNO",13,13,"   *********",13,"  ** ***** **",13,"  ** *   * **",13,"  ** ***** **",13,"   *********",0
b:.text "HYPNO",13,13,"   +++++++++",13,"  ++ +++++ ++",13,"  ++ +   + ++",13,"  ++ +++++ ++",13,"   +++++++++",0

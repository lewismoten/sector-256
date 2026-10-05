; Echo keys with a short SID beep whose pitch follows the key code.
.include "api.inc"
.cpu "6502"
*=$c000
p=$20
 lda #15
 sta $d418
 lda #>t
 sta p+1
 jsr CLEAR
 ldx #<t
 stx p
 jsr z
k:jsr WAITKEY
 pha
 jsr PUTCHAR
 pla
 sta $d400
 lda #20
 sta $d401
 lda #17
 sta $d404
 jsr d
 lda #0
 sta $d404
 jmp k
d:ldy #16
o:lda #0
i:sec
 sbc #1
 bne i
 dey
 bne o
 rts
z:ldy #0
q:lda (p),y
 beq e
 jsr PUTCHAR
 iny
 bne q
e:rts
t:.text "BEEPER TYPE KEYS",13,0

; Four character-mode levels of the Cantor set.
.include "api.inc"
.cpu "6502"
*=$c000
p=$20
 lda #>s
 sta p+1
r:jsr CLEAR
 ldx #<s
 stx p
 ldy #0
l:lda (p),y
 beq k
 jsr PUTCHAR
 iny
 bne l
k:jsr WAITKEY
 jmp r
s:.text "CANTOR SET",13,13
 .text "################################",13
 .text "###########          ###########",13
 .text "###   ###            ###   ###",13
 .text "# #   # #            # #   # #",13,0

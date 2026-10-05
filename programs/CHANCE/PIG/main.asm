; One-turn Pig: roll toward nine, but a one busts.
.include "api.inc"
.cpu "6502"
*=$c000
s=$02
d=$03
p=$20
 lda #>t
 sta p+1
r:lda #0
 sta s
 sta d
draw:lda s
 clc
 adc #48
 sta ss
 lda d
 clc
 adc #48
 sta dd
 jsr CLEAR
 ldx #<t
 stx p
 jsr z
k:jsr WAITKEY
 cmp #82
 beq roll
 cmp #72
 bne k
 ldx #<bank
 bne end
roll:jsr RANDOM
 and #3
 clc
 adc #1
 sta d
 cmp #1
 beq bust
 clc
 adc s
 sta s
 cmp #9
 bcs win
 jmp draw
bust:ldx #<lose
 bne end
win:ldx #<won
end:jsr z
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
t:.text "PIG R=ROLL H=HOLD",13,"TOTAL: "
ss:.byte 48
 .text "  ROLL: "
dd:.byte 48,13,0
bank:.text "BANKED! RETURN=NEW",13,0
lose:.text "BUST! RETURN=NEW",13,0
won:.text "NINE! RETURN=NEW",13,0

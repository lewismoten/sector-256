; A two-player seven-space fox-and-goose chase.
.include "api.inc"
.cpu "6502"
*=$c000
fox=$02
goose=$03
turn=$04
p=$20
 lda #>title
 sta p+1
round:
 lda #2
 sta fox
 lda #4
 sta goose
 lda #0
 sta turn
draw:
 jsr CLEAR
 ldx #<title
 jsr print
 ldy #1
board:
 tya
 cmp fox
 beq f
 cmp goose
 beq g
 lda #46
 bne put
f:lda #70
 bne put
g:lda #71
put:jsr PUTCHAR
 iny
 cpy #8
 bne board
 lda #13
 jsr PUTCHAR
 ldx #<keys
 jsr print
wait:
 jsr WAITKEY
 ldx turn
 beq foxturn
 cmp #74
 beq gl
 cmp #76
 bne wait
 lda goose
 cmp #7
 beq wait
 inc goose
 jmp catch
gl:lda goose
 cmp #1
 beq wait
 dec goose
catch:
 lda goose
 cmp fox
 beq goosewin
 jmp swap
foxturn:
 cmp #65
 beq fl
 cmp #68
 bne wait
 lda fox
 cmp #7
 beq wait
 inc fox
 jmp blocked
fl:lda fox
 cmp #1
 beq wait
 dec fox
blocked:
 lda fox
 cmp goose
 bne foxok
undo: ; a fox may not step onto a goose
 lda fox
 cmp #1
 beq plus
 dec fox
 jmp wait
plus:inc fox
 jmp wait
foxok:
 lda fox
 cmp #7
 beq foxwin
swap:
 lda turn
 eor #1
 sta turn
 jmp draw
foxwin:
 ldx #<fw
 bne over
goosewin:
 ldx #<gw
over:jsr print
again:jsr WAITKEY
 cmp #13
 bne again
 jmp round
print:stx p
 ldy #0
l:lda (p),y
 beq done
 jsr PUTCHAR
 iny
 bne l
done:rts
title:.text "FOX GEESE",13,0
keys:.text "A/D J/L",13,0
fw:.text "FOX WINS",13,0
gw:.text "GOOSE WINS",13,0

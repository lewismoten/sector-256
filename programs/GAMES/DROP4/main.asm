; Players drop into four columns; the player who completes a stack of four wins.
.include "api.inc"
.cpu "6502"
* = $c000
player=$02
heights=$20
text_ptr=$24
    lda #>title
    sta text_ptr+1
round:
    ldx #3
    lda #0
zero: sta heights,x
    dex
    bpl zero
    lda #1
    sta player
draw:
    jsr CLEAR
    ldx #<title
    jsr print
    lda player
    clc
    adc #48
    sta p
pick:
    jsr WAITKEY
    sec
    sbc #49
    cmp #4
    bcs pick
    tax
    inc heights,x
    lda heights,x
    cmp #4
    beq win
    lda player
    eor #3
    sta player
    jmp draw
win:
    ldx #<won
    jsr print
again:
    jsr WAITKEY
    cmp #13
    bne again
    jmp round
print: stx text_ptr
    ldy #0
l: lda (text_ptr),y
    beq d
    jsr PUTCHAR
    iny
    bne l
d: rts
title: .text "DROP4 1-4",13,"P"
p: .byte 49
.text " COLUMN: "
.byte 0
won: .text "STACK FOUR! RETURN=NEW",13
.byte 0

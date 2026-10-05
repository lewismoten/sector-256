; Two players take a chocolate square and every square to its right. Square 1 loses.
.include "api.inc"
.cpu "6502"
* = $c000
left = $02
player = $03
text_ptr = $20

    lda #>title
    sta text_ptr+1
round:
    lda #5
    sta left
    lda #1
    sta player
draw:
    jsr CLEAR
    ldx #<title
    jsr print
    ldx left
bar:
    lda #79
    jsr PUTCHAR
    dex
    bne bar
    lda #13
    jsr PUTCHAR
    lda player
    clc
    adc #48
    sta player_digit
    ldx #<prompt
    jsr print
pick:
    jsr WAITKEY
    sec
    sbc #48
    beq poisoned
    cmp left
    bcs pick
    sta left
    lda player
    eor #3
    sta player
    jmp draw
poisoned:
    ldx #<lose
    jsr print
again:
    jsr WAITKEY
    cmp #13
    bne again
    jmp round

print:
    stx text_ptr
    ldy #0
loop:
    lda (text_ptr),y
    beq done
    jsr PUTCHAR
    iny
    bne loop
done: rts

title: .text "CHOMP 1 IS POISON",13
.byte 0
prompt: .text "P"
player_digit: .byte 49
.text " PICK 2-5: "
.byte 0
lose: .text "POISON! RETURN=NEW",13
.byte 0

; Pick red or black, then the wheel chooses 0-9 and its color.
.include "api.inc"
.cpu "6502"
* = $c000
bet = $02
number = $03
color = $04
text = $20

    lda #>title
    sta text+1
round:
    jsr CLEAR
    ldx #<title
    jsr print
choose:
    jsr WAITKEY
    cmp #82
    beq red_bet
    cmp #66
    bne choose
    lda #2
    bne spin
red_bet:
    lda #1
spin:
    sta bet
roll:
    jsr RANDOM
    and #15
    cmp #10
    bcs roll
    sta number
    clc
    adc #48
    sta digit
    ldx #<outcome
    jsr print
    lda number
    beq green
    and #1
    beq black
    lda #1
    ldx #<red
    bne color_ready
black:
    lda #2
    ldx #<black_text
    bne color_ready
green:
    lda #0
    ldx #<green_text
color_ready:
    sta color
    jsr print
    lda color
    cmp bet
    beq win
    ldx #<lose
    bne result
win:
    ldx #<won
result:
    jsr print
again:
    jsr WAITKEY
    cmp #13
    bne again
    jmp round

print:
    stx text
    ldy #0
loop:
    lda (text),y
    beq done
    jsr PUTCHAR
    iny
    bne loop
done:
    rts

title: .text "ROULETTE BET R=RED B=BLACK",13,0
outcome: .text "NUMBER "
digit: .byte 48
.byte 13,0
red: .text "RED",13,0
black_text: .text "BLACK",13,0
green_text: .text "GREEN",13,0
won: .text "YOU WIN! RETURN=SPIN",13,0
lose: .text "HOUSE WINS! RETURN=SPIN",13,0

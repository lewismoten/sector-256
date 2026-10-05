; Come-out roll: 7/11 wins, 2/3/12 loses; otherwise make the point before 7.
.include "api.inc"
.cpu "6502"
* = $c000
point = $02
sum = $03
die1 = $04
text_ptr = $20

    lda #>title
    sta text_ptr+1
round:
    jsr CLEAR
    lda #0
    sta point
    ldx #<title
    jsr print
roll_wait:
    jsr WAITKEY
    cmp #32
    bne roll_wait
    jsr die
    sta die1
    clc
    adc #48
    sta first_digit
    jsr die
    pha
    clc
    adc die1
    sta sum
    pla
    clc
    adc #48
    sta second_digit
    ldx #<rolled
    jsr print
    lda point
    bne point_roll
    lda sum
    cmp #7
    beq won
    cmp #11
    beq won
    cmp #2
    beq lost
    cmp #3
    beq lost
    cmp #12
    beq lost
    sta point
    ldx #<made_point
    jsr print
    jmp roll_wait
point_roll:
    cmp sum
    beq won
    lda sum
    cmp #7
    bne roll_wait
lost:
    ldx #<lose
    bne result
won:
    ldx #<win
result:
    jsr print
again:
    jsr WAITKEY
    cmp #13
    bne again
    jmp round

die:
    jsr RANDOM
    and #7
    cmp #6
    bcs die
    clc
    adc #1
    rts

print:
    stx text_ptr
    ldy #0
print_loop:
    lda (text_ptr),y
    beq printed
    jsr PUTCHAR
    iny
    bne print_loop
printed:
    rts

title: .text "CRAPS SPACE=ROLL",13
.byte 0
rolled: .text "DICE "
first_digit: .byte 49
.text " "
second_digit: .byte 49
.byte 13,0
made_point: .text "POINT! SPACE=ROLL",13
.byte 0
win: .text "WIN! RETURN=NEW",13
.byte 0
lose: .text "LOSE! RETURN=NEW",13
.byte 0

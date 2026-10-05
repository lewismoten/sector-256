; Move the paddle with A/D and keep the ball in play against three walls.
.include "api.inc"
.cpu "6502"
* = $c000
ball = $02
paddle = $03
direction = $04
score = $05
text = $20

    lda #>title
    sta text+1
round:
    lda #4
    sta ball
    sta paddle
    lda #1
    sta direction
    lda #0
    sta score
frame:
    jsr CLEAR
    lda ball
    clc
    adc #48
    sta ball_digit
    lda paddle
    clc
    adc #48
    sta paddle_digit
    lda score
    clc
    adc #48
    sta score_digit
    ldx #<title
    jsr print
    jsr POLLKEY
    cmp #65
    bne right
    lda paddle
    beq move
    dec paddle
    bne move
right:
    cmp #68
    bne move
    lda paddle
    cmp #8
    beq move
    inc paddle
move:
    lda direction
    beq left
    inc ball
    lda ball
    cmp #8
    bne frame
    cmp paddle
    bne lost
    inc score
    lda #0
    sta direction
    jmp frame
left:
    dec ball
    bpl frame
    lda #1
    sta direction
    inc ball
    jmp frame
lost:
    ldx #<miss
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

title: .text "SQUASH A/D PADDLE",13,"WALL BALL "
ball_digit: .byte 52
.text " P "
paddle_digit: .byte 52
.text " SCORE "
score_digit: .byte 48
.byte 13,0
miss: .text "MISS! RETURN=NEW",13,0

; Move the aim, then account for a random gust before firing.
.include "api.inc"
.cpu "6502"
* = $c000
aim = $02
target = $03
wind = $04
text_ptr = $20

    lda #>title
    sta text_ptr+1
round:
    jsr RANDOM
    and #7
    clc
    adc #1
    sta target
    jsr RANDOM
    and #1
    sta wind
    lda #4
    sta aim
draw:
    jsr CLEAR
    lda aim
    clc
    adc #48
    sta aim_digit
    lda target
    clc
    adc #48
    sta target_digit
    lda wind
    beq calm
    lda #62
    bne wind_ready
calm:
    lda #46
wind_ready:
    sta wind_char
    ldx #<title
    jsr print
aim_key:
    jsr WAITKEY
    cmp #65
    bne right
    lda aim
    cmp #1
    beq aim_key
    dec aim
    jmp draw
right:
    cmp #68
    bne fire_check
    lda aim
    cmp #8
    beq aim_key
    inc aim
    jmp draw
fire_check:
    cmp #32
    bne aim_key
    lda aim
    clc
    adc wind
    cmp target
    beq hit
    ldx #<miss
    bne result
hit:
    ldx #<win
result:
    jsr print
again:
    jsr WAITKEY
    cmp #13
    bne again
    jmp round

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

title: .text "ARCHERY A/D SPACE",13,"AIM "
aim_digit: .byte 52
.text " WIND "
wind_char: .byte 46
.text " TARGET "
target_digit: .byte 49
.byte 13,0
win: .text "BULLSEYE! RETURN=NEW",13
.byte 0
miss: .text "MISS! RETURN=NEW",13
.byte 0

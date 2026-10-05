; Position the rescue net beneath a randomly placed jumper.
.include "api.inc"
.cpu "6502"
* = $c000
net = $02
jumper = $03
text_ptr = $20

    lda #>title
    sta text_ptr+1
round:
    jsr RANDOM
    and #7
    clc
    adc #1
    sta jumper
    lda #4
    sta net
draw:
    jsr CLEAR
    lda net
    clc
    adc #48
    sta net_digit
    lda jumper
    clc
    adc #48
    sta jump_digit
    ldx #<title
    jsr print
key:
    jsr WAITKEY
    cmp #65
    bne right
    lda net
    cmp #1
    beq key
    dec net
    jmp draw
right:
    cmp #68
    bne catch
    lda net
    cmp #8
    beq key
    inc net
    jmp draw
catch:
    cmp #32
    bne key
    lda net
    cmp jumper
    beq saved
    ldx #<miss
    bne result
saved:
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
loop:
    lda (text_ptr),y
    beq done
    jsr PUTCHAR
    iny
    bne loop
done:
    rts

title: .text "FIREMAN A/D SPACE",13,"JUMPER "
jump_digit: .byte 49
.text " NET "
net_digit: .byte 52
.byte 13,0
win: .text "SAVED! RETURN=NEW",13
.byte 0
miss: .text "MISSED! RETURN=NEW",13
.byte 0

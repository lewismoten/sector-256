; Turn the dial until its hidden notch clicks, then try the lock.
.include "api.inc"
.cpu "6502"
* = $c000
dial = $02
notch = $03
text_ptr = $20

    lda #>title
    sta text_ptr+1
round:
    jsr RANDOM
    and #7
    clc
    adc #1
    sta notch
    lda #1
    sta dial
draw:
    jsr CLEAR
    lda dial
    clc
    adc #48
    sta dial_digit
    ldx #<title
    jsr print
    lda dial
    cmp notch
    bne key
    ldx #<click
    jsr print
key:
    jsr WAITKEY
    cmp #65
    bne right
    lda dial
    cmp #1
    bne down
    lda #8
    bne set
down:
    dec dial
    jmp draw
right:
    cmp #68
    bne try
    lda dial
    cmp #8
    bne up
    lda #1
set:
    sta dial
    jmp draw
up:
    inc dial
    jmp draw
try:
    cmp #32
    bne key
    lda dial
    cmp notch
    beq opened
    ldx #<fail
    bne result
opened:
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

title: .text "LOCKPICK A/D SPACE",13,"DIAL "
dial_digit: .byte 49
.byte 13,0
click: .text "CLICK!",13
.byte 0
win: .text "OPEN! RETURN=NEW",13
.byte 0
fail: .text "JAM! RETURN=NEW",13
.byte 0

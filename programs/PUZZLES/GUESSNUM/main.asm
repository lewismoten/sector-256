; Type two digits and narrow down a hidden number from 00 through 99.
.include "api.inc"
.cpu "6502"
* = $c000
target = $02
value = $03
text_ptr = $20

    lda #>title
    sta text_ptr+1
round:
    jsr CLEAR
    jsr RANDOM
mod_hundred:
    cmp #100
    bcc target_ready
    sec
    sbc #100
    bcs mod_hundred
target_ready:
    sta target
    ldx #<title
    jsr print
guess:
    jsr WAITKEY
    cmp #48
    bcc guess
    cmp #58
    bcs guess
    sec
    sbc #48
    tax
    lda tens,x
    sta value
    txa
    clc
    adc #48
    jsr PUTCHAR
ones:
    jsr WAITKEY
    cmp #48
    bcc ones
    cmp #58
    bcs ones
    sec
    sbc #48
    pha
    clc
    adc value
    sta value
    pla
    clc
    adc #48
    jsr PUTCHAR
    lda value
    cmp target
    beq won
    bcc too_low
    ldx #<high
    bne say
too_low:
    ldx #<low
say:
    jsr print
    jmp guess
won:
    ldx #<win
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

tens: .byte 0,10,20,30,40,50,60,70,80,90
title: .text "GUESSNUM 00-99",13,"GUESS: "
.byte 0
low: .text " LOW",13
.byte 0
high: .text " HIGH",13
.byte 0
win: .text " WIN! RETURN=NEW",13
.byte 0

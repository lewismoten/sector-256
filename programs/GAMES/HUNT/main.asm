; Find a hidden position from 1 through 8 using warm and cold hints.
.include "api.inc"
.cpu "6502"
* = $c000
target = $02
guess = $03
text_ptr = $20

    lda #>title
    sta text_ptr+1
round:
    jsr CLEAR
    jsr RANDOM
    and #7
    clc
    adc #1
    sta target
    ldx #<title
    jsr print
ask:
    jsr WAITKEY
    cmp #49
    bcc ask
    cmp #57
    bcs ask
    sec
    sbc #48
    sta guess
    clc
    adc #48
    jsr PUTCHAR
    lda guess
    cmp target
    beq found
    sec
    sbc target
    bcs distance
    eor #$ff
    clc
    adc #1
distance:
    cmp #3
    bcc warm
    ldx #<cold
    bne hint
warm:
    ldx #<warm_text
hint:
    jsr print
    jmp ask
found:
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

title: .text "HUNT 1-8",13,"WHERE? "
.byte 0
warm_text: .text " WARM",13
.byte 0
cold: .text " COLD",13
.byte 0
win: .text " FOUND! RETURN=NEW",13
.byte 0

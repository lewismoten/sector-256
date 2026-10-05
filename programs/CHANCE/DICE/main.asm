; SPACE starts a short, visibly tumbling two-die roll.
.include "api.inc"
.cpu "6502"
* = $c000
rolls = $02
text_ptr = $20

    lda #>title
    sta text_ptr+1
    jsr CLEAR
    ldx #<title
    jsr print
    lda #0
    sta rolls
frame:
    jsr POLLKEY
    cmp #32
    bne check_roll
    lda #12
    sta rolls
check_roll:
    lda rolls
    beq wait_raster
    jsr roll
    dec rolls
wait_raster:
    lda $d012
    bne wait_raster
    jmp frame

roll:
    jsr RANDOM
mod_six_1:
    cmp #6
    bcc first_die
    sec
    sbc #6
    bcs mod_six_1
first_die:
    clc
    adc #49
    sta $0429
    jsr RANDOM
mod_six_2:
    cmp #6
    bcc second_die
    sec
    sbc #6
    bcs mod_six_2
second_die:
    clc
    adc #49
    sta $042d
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

title: .text "DICE SPACE=ROLL",13,"[1] [1]"
.byte 0

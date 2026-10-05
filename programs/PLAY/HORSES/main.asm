; Pick one of five horses. The first to cross the short track wins.
.include "api.inc"
.cpu "6502"
* = $c000
pick = $02
counts = $04
track_ptr = $20
text_ptr = $22

    lda #>title
    sta text_ptr+1
restart:
    jsr CLEAR
    ldx #<title
    jsr print
choose:
    jsr WAITKEY
    cmp #49
    bcc choose
    cmp #54
    bcs choose
    sta pick
    jsr CLEAR
    ldx #<track
    jsr print
    ldx #4
zero_counts:
    lda #0
    sta counts,x
    dex
    bpl zero_counts
wait_raster:
    lda $d012
    bne wait_raster
race:
    jsr POLLKEY
    jsr RANDOM
mod_five:
    cmp #5
    bcc move
    sec
    sbc #5
    bcs mod_five
move:
    tax
    lda rows_lo,x
    sta track_ptr
    lda rows_hi,x
    sta track_ptr+1
    inc counts,x
    ldy counts,x
    lda #46
    dey
    sta (track_ptr),y
    iny
    lda #62
    sta (track_ptr),y
    cpy #5
    bne wait_raster
    txa
    clc
    adc #49
    sta winner_digit
    jsr CLEAR
    ldx #<result
    jsr print
    lda winner_digit
    cmp pick
    bne lost
    ldx #<win
    bne announce
lost:
    ldx #<lose
announce:
    jsr print
again:
    jsr WAITKEY
    cmp #13
    bne again
    jmp restart

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

rows_lo: .byte 1,41,81,121,161
rows_hi: .byte 4,4,4,4,4
title: .text "HORSE 1-5?"
.byte 0
track: .text "1>....",13,"2>....",13,"3>....",13,"4>....",13,"5>....",13
.byte 0
result: .text "HORSE "
winner_digit: .byte 48
.text " WINS!",13
.byte 0
win: .text "WIN! RETURN=RACE",13
.byte 0
lose: .text "LOSE! RETURN=RACE",13
.byte 0

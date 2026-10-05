; Move the two-cell basket with A/D and catch falling stars.
.include "api.inc"
.cpu "6502"
* = $c000
star_x = $02
star_y = $03
basket = $04
star_ptr = $20
text_ptr = $22

    lda #>title
    sta text_ptr+1
restart:
    jsr CLEAR
    ldx #<title
    jsr print
    lda #15
    sta basket
    jsr new_star
draw:
    ldy #0
    lda #42
    sta (star_ptr),y
    ldx basket
    lda #$a0
    sta $0798,x
    sta $0799,x
wait_raster:
    lda $d012
    bne wait_raster
frame:
    jsr POLLKEY
    pha
    ldx basket
    lda #32
    sta $0798,x
    sta $0799,x
    ldy #0
    sta (star_ptr),y
    pla
    cmp #65
    bne check_right
    ldx basket
    beq moved
    dec basket
    bne moved
check_right:
    cmp #68
    bne moved
    lda basket
    cmp #30
    beq moved
    inc basket
moved:
    lda star_y
    cmp #22
    beq landed
    inc star_y
    clc
    lda star_ptr
    adc #40
    sta star_ptr
    bcc draw
    inc star_ptr+1
    bne draw
landed:
    lda star_x
    sec
    sbc basket
    cmp #2
    bcc caught
    inc $042c                  ; M0 becomes M1, M2, then M3
    lda $042c
    cmp #51
    beq game_over
new_round:
    jsr new_star
    jmp draw
caught:
    inc $0429                  ; S0 becomes S1, S2 ...
    bne new_round
game_over:
    jsr CLEAR
    ldx #<over
    jsr print
again:
    jsr WAITKEY
    cmp #13
    bne again
    jmp restart

new_star:
    jsr RANDOM
    and #31
    sta star_x
    sta star_ptr
    lda #4
    sta star_ptr+1
    lda #0
    sta star_y
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

title: .text "CATCHER A/D",13,"S0 M0",13
.byte 0
over: .text "THREE MISSES!",13,"RETURN=AGAIN STOP=EXIT"
.byte 0

; Predict whether the next random card rank is higher or lower.
.include "api.inc"
.cpu "6502"
* = $c000
current = $02
next = $03
score = $04
choice = $05
text_ptr = $20

restart:
    lda #>title
    sta text_ptr+1
    lda #0
    sta score
new_card:
    jsr RANDOM
mod_13:
    cmp #13
    bcc card_ready
    sec
    sbc #13
    bcs mod_13
card_ready:
    sta current
show:
    jsr CLEAR
    tax
    lda faces,x
    sta card_rank
    lda score
    clc
    adc #48
    sta score_digit
    ldx #<title
    jsr print
choose:
    jsr WAITKEY
    cmp #72
    beq picked
    cmp #76
    bne choose
picked:
    sta choice
    jsr RANDOM
next_rank:
    cmp #13
    bcc compare
    sec
    sbc #13
    bcs next_rank
compare:
    sta next
    cmp current
    beq lost
    bcc lower
    lda choice
    cmp #72
    beq won
    bne lost
lower:
    lda choice
    cmp #76
    bne lost
won:
    inc score
    lda next
    sta current
    ldx #<win
    bne say
lost:
    ldx #<lose
say:
    jsr print
wait:
    jsr WAITKEY
    cmp #13
    beq restart
    jmp show

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

faces: .text "A23456789TJQK"
title: .text "HILO CARD "
card_rank: .byte 65
.text "  H=HIGH L=LOW",13,"SCORE "
score_digit: .byte 48
.byte 13,0
win: .text "WIN! ANY KEY=NEXT",13
.byte 0
lose: .text "LOSE! RETURN=NEW",13
.byte 0

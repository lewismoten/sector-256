; Wait for the random draw signal. First valid shot wins the duel.
.include "api.inc"
.cpu "6502"
* = $c000
timer = $02
text_ptr = $20

    lda #>title
    sta text_ptr+1
round:
    jsr CLEAR
    ldx #<title
    jsr print
    jsr RANDOM
    and #31
    clc
    adc #10
    sta timer
wait_raster:
    lda $d012
    bne wait_raster
wait:
    jsr POLLKEY
    bne early
    dec timer
    bne wait_raster
    ldx #<draw_text
    jsr print
fire:
    jsr WAITKEY
    cmp #65
    beq p1
    cmp #76
    bne fire
    ldx #<p2_win
    bne result
p1:
    ldx #<p1_win
result:
    jsr print
again:
    jsr WAITKEY
    cmp #13
    bne again
    jmp round
early:
    cmp #65
    beq p1_early
    cmp #76
    bne wait
    ldx #<p2_early
    bne result
p1_early:
    ldx #<p1_early_text
    bne result

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

title: .text "DUEL P1=A P2=L",13,"WAIT...",13
.byte 0
draw_text: .text "DRAW!",13
.byte 0
p1_win: .text "P1 WINS! RETURN=NEW",13
.byte 0
p2_win: .text "P2 WINS! RETURN=NEW",13
.byte 0
p1_early_text: .text "P1 EARLY! P2 WINS",13
.byte 0
p2_early: .text "P2 EARLY! P1 WINS",13
.byte 0

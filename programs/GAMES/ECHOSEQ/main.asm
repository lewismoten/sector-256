; Watch a growing random sequence of A-D signals, then repeat it exactly.
.include "api.inc"
.cpu "6502"
* = $c000
length = $02
pos = $03
sequence = $30
text_ptr = $20

    lda #>watch
    sta text_ptr+1
round:
    lda #0
    sta length
add_signal:
    ldx length
    jsr RANDOM
    and #3
    clc
    adc #65
    sta sequence,x
    inc length
show:
    jsr CLEAR
    ldx #<watch
    jsr print
    ldx #0
show_loop:
    lda sequence,x
    jsr PUTCHAR
    inx
    cpx length
    bne show_loop
    jsr WAITKEY
    jsr CLEAR
    ldx #<repeat
    jsr print
    ldx #0
input:
    jsr WAITKEY
    cmp sequence,x
    bne lost
    inx
    cpx length
    bne input
    cpx #6
    beq won
    jmp add_signal
lost:
    ldx #<lose
    bne result
won:
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

watch: .text "ECHOSEQ WATCH ",0
repeat: .text "REPEAT A-D",13
.byte 0
lose: .text "WRONG! RETURN=NEW",13
.byte 0
win: .text "SIX! RETURN=NEW",13
.byte 0

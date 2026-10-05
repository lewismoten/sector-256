; Three safe wire cuts defuse the bomb. Each stage has a random safe wire.
.include "api.inc"
.cpu "6502"
* = $c000
safe = $02
cuts = $03
text_ptr = $20

    lda #>title
    sta text_ptr+1
round:
    lda #0
    sta cuts
next_wire:
    jsr RANDOM
    and #3
    cmp #3
    bcs next_wire
    clc
    adc #1
    sta safe
    jsr CLEAR
    ldx #<title
    jsr print
choose:
    jsr WAITKEY
    cmp #49
    bcc choose
    cmp #52
    bcs choose
    sec
    sbc #48
    cmp safe
    bne boom
    inc cuts
    lda cuts
    cmp #3
    bne next_wire
    ldx #<win
    bne result
boom:
    ldx #<lost
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

title: .text "DEFUSE CUT WIRE 1-3",13,"CUT: "
.byte 0
win: .text "DEFUSED! RETURN=NEW",13
.byte 0
lost: .text "BOOM! RETURN=NEW",13
.byte 0

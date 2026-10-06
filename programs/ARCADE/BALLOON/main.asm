; Pump for points. RETURN holds the balloon: full pressure wins.
.include "api.inc"
.cpu "6502"
* = $c000
air = $02
text_ptr = $20

    lda #>title
    sta text_ptr+1
round:
    inc round_color
    lda round_color
    and #15
    sta round_color
    sta $d020
    sta $d021
    jsr CLEAR
    lda #0
    sta air
    ldx #<title
    jsr print
pump:
    jsr WAITKEY
    cmp #13
    bne not_hold
    lda air
    cmp #7
    beq won
    ldx #<lost
    jsr print
    jmp again
not_hold:
    cmp #32
    bne pump
    inc air
    lda #81
    jsr PUTCHAR
    jsr RANDOM
    and #7
    cmp air
    bcs pump
    dec air
    lda air
    clc
    adc #48
    sta score
    ldx #<popped
    jsr print
again:
    jsr WAITKEY
    cmp #13
    bne again
    jmp round
won:
    ldx #<winner
    jsr print
    jmp again

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

title: .text " .--.",13," /    "
.byte 92,13
.text "|      |",13
.byte 92
.text "  '--'",13,"BALLOON",13,"SP=P RT=H ",0
popped: .text 13,"POP! SCORE "
score: .byte 48
lost: .text 13,"NO WIN!",0
winner: .text 13,"FULL PRESSURE! YOU WIN! RT=AGAIN",0
round_color: .byte 1

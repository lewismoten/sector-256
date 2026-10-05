; Pick six digits. Six random balls are drawn and matched against the picks.
.include "api.inc"
.cpu "6502"
* = $c000
left = $02
matches = $03
picks = $20
text_ptr = $26

    lda #>title
    sta text_ptr+1
round:
    jsr CLEAR
    lda #6
    sta left
    lda #0
    sta matches
    ldx #<title
    jsr print
pick:
    jsr WAITKEY
    cmp #49
    bcc pick
    cmp #58
    bcs pick
    ldx left
    dex
    sta picks,x
    jsr PUTCHAR
    dec left
    bne pick
    ldx #<draw_text
    jsr print
    ldx #5
draw:
    jsr RANDOM
    and #7
    clc
    adc #49
    pha
    jsr PUTCHAR
    pla
    ldy #5
check:
    cmp picks,y
    beq hit
    dey
    bpl check
    beq next
hit:
    inc matches
next:
    dex
    bpl draw
    lda matches
    clc
    adc #48
    sta match_digit
    ldx #<result
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

title: .text "LOTTO PICK SIX 1-9",13,"PICKS: "
.byte 0
draw_text: .text 13,"DRAW: "
.byte 0
result: .text 13,"MATCHES "
match_digit: .byte 48
.text 13,"RETURN=AGAIN"
.byte 0

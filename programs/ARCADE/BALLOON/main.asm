; Pump for points, but each breath makes the balloon more likely to pop.
.include "api.inc"
.cpu "6502"
* = $c000
air = $02
text_ptr = $20

    lda #>title
    sta text_ptr+1
round:
    jsr CLEAR
    lda #0
    sta air
    ldx #<title
    jsr print
pump:
    jsr WAITKEY
    cmp #32
    bne pump
    inc air
    lda #79
    jsr PUTCHAR                ; one O for each safe pump
    jsr RANDOM
    and #7
    cmp air                    ; 1/8, then 2/8 ... until it must pop
    bcs pump
    jsr CLEAR
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

title: .text "    .--.",13,"   /    "
.byte 92,13
.text "   "
.byte 92
.text "    /",13,"    '--'",13,"BALLOON",13,"SPACE=PUMP",13,"AIR: "
.byte 0
popped: .text "POP! SCORE "
score: .byte 48
.text 13,"RETURN=AGAIN STOP=EXIT"
.byte 0

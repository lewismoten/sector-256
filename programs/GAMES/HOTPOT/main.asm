; Pass the keyboard. A hidden random fuse decides when the pot goes boom.
.include "api.inc"
.cpu "6502"
* = $c000
fuse = $02
passes = $03
text_ptr = $20

    lda #>title
    sta text_ptr+1
round:
    jsr CLEAR
    jsr RANDOM
    and #15
    clc
    adc #5
    sta fuse
    lda #0
    sta passes
    ldx #<title
    jsr print
pass:
    jsr WAITKEY
    dec fuse
    beq boom
    inc passes
    lda #42
    jsr PUTCHAR
    jmp pass
boom:
    jsr CLEAR
    lda passes
    clc
    adc #48
    sta pass_digit
    ldx #<lost
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

title: .text "HOTPOT PASS THE KEY",13,"ANY KEY=PASS",13
.byte 0
lost: .text "BOOM! PASS "
pass_digit: .byte 48
.text 13,"LAST PLAYER LOSES",13,"RETURN=AGAIN"
.byte 0

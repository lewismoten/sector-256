; Guess four digits: B is a correct position, C is a digit in the wrong place.
.include "api.inc"
.cpu "6502"
* = $c000
bulls = $02
cows = $03
secret = $20
guess = $24
text_ptr = $28

    lda #>title
    sta text_ptr+1
round:
    jsr CLEAR
    ldx #3
make_secret:
    jsr RANDOM
    and #7
    clc
    adc #48
    sta secret,x
    dex
    bpl make_secret
    ldx #<title
    jsr print
get_guess:
    ldx #0
digit:
    jsr WAITKEY
    cmp #48
    bcc digit
    cmp #56
    bcs digit
    sta guess,x
    jsr PUTCHAR
    inx
    cpx #4
    bne digit
    lda #0
    sta bulls
    sta cows
    ldx #3
find_bulls:
    lda guess,x
    cmp secret,x
    bne next_bull
    inc bulls
next_bull:
    dex
    bpl find_bulls
    ldx #3
find_cows:
    ldy #3
compare_digits:
    lda guess,x
    cmp secret,y
    bne next_digit
    inc cows
next_digit:
    dey
    bpl compare_digits
    dex
    bpl find_cows
    lda cows
    sec
    sbc bulls
    sta cows
    clc
    adc #48
    sta result+5
    lda bulls
    clc
    adc #48
    sta result+2
    ldx #<result
    jsr print
again:
    jsr WAITKEY
    cmp #13
    beq round
    jmp get_guess

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

title: .text "COWBULL 0-7",13,"GUESS: "
.byte 0
result: .text 13,"B0 C0",13,"RET=NEW",13
.byte 0

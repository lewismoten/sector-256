; Recolor the top-left region through the adjacent columns in two moves.
.include "api.inc"
.cpu "6502"
* = $c000
stage = $02
text_ptr = $20

    lda #>start
    sta text_ptr+1
round:
    lda #0
    sta stage
draw:
    jsr CLEAR
    ldx stage
    lda screens,x
    tax
    jsr print
choose:
    jsr WAITKEY
    ldx stage
    cmp needed,x
    bne lost
    inc stage
    lda stage
    cmp #2
    bne draw
    ldx #<win
    bne result
lost:
    ldx #<lose
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

screens: .byte <start,<middle
needed: .byte 66,67
start: .text "FLOOD B THEN C",13,"A B C",13,"A B C",13,"COLOR? "
.byte 0
middle: .text "FLOOD B THEN C",13,"B B C",13,"B B C",13,"COLOR? "
.byte 0
win: .text "C C C",13,"C C C",13,"FLOODED! RETURN=NEW",13
.byte 0
lose: .text "NO FLOOD! RETURN=NEW",13
.byte 0

; Monty Hall: car behind a random door, one goat revealed, stay or switch.
.include "api.inc"
.cpu "6502"
* = $c000
prize = $02
pick = $03
opened = $04
text_ptr = $22
result_ptr = $24

    lda #>intro
    sta text_ptr+1
round:
    jsr RANDOM                 ; launcher LFSR mixes in the jiffy clock
mod_three:
    cmp #3                     ; RANDOM returns 1..255: 85 of each remainder
    bcc prize_ready
    sbc #3
    bcs mod_three
prize_ready:
    sta prize                  ; choose before displaying or accepting a door
    jsr CLEAR
    ldx #<intro
    jsr print
    ldx #<score_text
    jsr print
choose:
    jsr WAITKEY
    sec
    sbc #49
    cmp #3
    bcs choose
    sta pick
    ldx #0
find_goat:
    cpx pick
    beq next_door
    cpx prize
    bne goat_found
next_door:
    inx
    bne find_goat
goat_found:
    stx opened
    txa
    clc
    adc #49
    sta goat_digit
    ldx #<goat_prompt
    jsr print
choice:
    jsr WAITKEY
    cmp #75                   ; K: keep the first door
    beq evaluate_keep
    cmp #83                   ; S: switch to the only unopened door
    bne choice
    lda #3
    sbc pick
    sbc opened
    bcs evaluate
evaluate_keep:
    lda pick
evaluate:
    cmp prize
    bne lost
    ldx #<win_text
    ldy #0
    beq tally
lost:
    ldx #<lose_text
    ldy #5
tally:
    stx result_ptr
    tya
    tax
    inc score_text+3,x
    lda score_text+3,x
    cmp #58
    bne score_ready
    lda #48
    sta score_text+3,x
    inc score_text+2,x
    lda score_text+2,x
    cmp #58
    bne score_ready
    lda #48
    sta score_text+2,x
    inc score_text+1,x
score_ready:
    ldx result_ptr
    jsr print
    ldx #<score_text
    jsr print
    ldx #<again_text
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
intro: .text "MONTY 1-3?",13
.byte 0
score_text: .text "W000 L000",13
.byte 0
goat_prompt: .text "OPEN "
goat_digit: .byte 48
.text ":GOAT",13,"S=SWITCH K=KEEP",13
.byte 0
win_text: .text "CAR!",13
.byte 0
lose_text: .text "GOAT",13
.byte 0
again_text: .text "RET=AGAIN",13
.byte 0

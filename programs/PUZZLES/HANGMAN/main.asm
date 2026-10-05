; Four six-letter words. Guess A-Z; repeated guesses are ignored.
; The launcher handles RUN/STOP through WAITKEY. RETURN starts a new round.
.include "api.inc"
.cpu "6502"
* = $c000
base = $02
misses = $03
remaining = $04
letter = $05
restart:
    jsr CLEAR
    jsr RANDOM
    and #3
    asl
    sta base
    asl
    clc
    adc base
    sta base                    ; word offset: random index * 6
    lda #0
    sta misses
    ldx #25
clear_guesses:
    sta $20,x
    dex
    bpl clear_guesses
    lda #6
    sta remaining
    ldx #5
mask_word:
    lda #45
    sta $0452,x                 ; six dashes on screen
    dex
    bpl mask_word
    ldx #0
print_title:
    lda title,x
    beq guess
    jsr PUTCHAR
    inx
    bne print_title
guess:
    jsr WAITKEY
    cmp #65
    bcc guess
    cmp #91
    bcs guess
    sta letter
    sec
    sbc #65
    tax
    lda $20,x
    bne guess                   ; do not count a repeated guess
    inc $20,x
    lda remaining
    pha
    ldx #5
check_letter:
    txa
    clc
    adc base
    tay
    lda words,y
    cmp letter
    bne next_letter
    and #$3f                    ; PETSCII to screen code
    sta $0452,x
    dec remaining
next_letter:
    dex
    bpl check_letter
    pla
    cmp remaining
    bne check_win
    ldx misses
    ldy positions,x
    lda body,x
    sta $0500,y                 ; add a body part for each wrong guess
    inc misses
    lda misses
    cmp #6
    bcc guess
    lda #76                     ; L: lost
    bne finished
check_win:
    lda remaining
    bne guess
    lda #87                     ; W: won
finished:
    jsr PUTCHAR
    ldx #0
print_finish:
    lda finish_text,x
    beq wait_restart
    jsr PUTCHAR
    inx
    bne print_finish
wait_restart:
    jsr WAITKEY
    cmp #13
    bne wait_restart
    jmp restart
positions: .byte 16,56,55,57,95,97
body: .byte 15,93,77,78,77,78
words: .text "SECTOR", "PIXELS", "SPRITE", "GAMING"
title: .text "HANGMAN  A-Z",13
.byte 0
finish_text: .text "  W=WIN L=LOSE",13,"RETURN=AGAIN STOP=EXIT"
.byte 0

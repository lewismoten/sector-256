; Cast with SPACE. Do not strike until the fish bites.
.include "api.inc"
.cpu "6502"
* = $c000
phase = $02
timer = $03
text_ptr = $20

    lda #>title
    sta text_ptr+1
restart:
    jsr CLEAR
    ldx #<title
    jsr print
    lda #0
    sta phase
frame:
    jsr POLLKEY
    pha
    lda phase
    beq idle
    cmp #1
    beq waiting
    pla
    cmp #32
    bne wait_raster
    inc $0429                  ; C0 becomes C1, C2 ...
    ldx #<caught
    jsr print
    lda #0
    sta phase
    beq wait_raster
idle:
    pla
    cmp #32
    bne wait_raster
    jsr RANDOM
    and #31
    clc
    adc #16
    sta timer
    lda #1
    sta phase
    ldx #<cast
    jsr print
    jmp wait_raster
waiting:
    pla
    cmp #32
    beq too_soon
    dec timer
    bne wait_raster
    inc phase
    ldx #<bite
    jsr print
    jmp wait_raster
too_soon:
    ldx #<lost
    jsr print
    lda #0
    sta phase
wait_raster:
    lda $d012
    bne wait_raster
    jmp frame

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

title: .text "FISHING SPACE=CAST",13,"C0",13
.byte 0
cast: .text "WAIT...",13
.byte 0
bite: .text "BITE! SPACE!",13
.byte 0
caught: .text "CAUGHT! CAST AGAIN",13
.byte 0
lost: .text "TOO SOON! CAST AGAIN",13
.byte 0

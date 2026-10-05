; Sector 256: every ordered pair of the 16 C64 colors, temporally swatched.
; Rows = color A; columns = color B. Four-frame duty: 1:3, 2:2, or 3:1.
; Diagonal patches always show the original hardware colors.
.include "api.inc"
.cpu "6502"
* = $c000
phase = $02
rate = $03
ticks = $04
weight = $05
ptr = $20
    jsr CLEAR
    ldx #0
banner_loop:
    lda banner,x
    beq setup_grid
    jsr PUTCHAR
    inx
    bne banner_loop
setup_grid:
    lda #<$0483              ; screen row 3, column 11: row label
    sta ptr
    lda #>$0483
    sta ptr+1
    ldx #0
init_row:
    lda #$a0                 ; inverse spaces: solid swatches
    ldy #16
init_cell:
    sta (ptr),y
    dey
    bne init_cell
    lda hex,x
    and #$3f                 ; ASCII/PETSCII to uppercase screen code
    sta (ptr),y
    jsr advance_row
    inx
    cpx #16
    bne init_row
    tya                      ; Y=0 after the final initialization row
    sta phase
    lda #2
    sta weight
    lsr
    sta rate
    sta ticks
draw:
    lda #<$d884              ; color RAM at row 3, column 12
    sta ptr
    lda #>$d884
    sta ptr+1
    ldx #0
draw_row:
    ldy #15
draw_cell:
    lda phase
    cmp weight
    bcc color_a
    tya                      ; B: column number
    bcs paint
color_a:
    txa                      ; A: row number
paint:
    sta (ptr),y
    dey
    bpl draw_cell
    jsr advance_row
    inx
    cpx #16
    bne draw_row
poll:
    lda rate
    ora #48
    sta $0404                ; live frames-per-phase digit
    lda weight
    ora #48
    sta $0408                ; live A-frames / 4 digit
    jsr POLLKEY              ; includes the common RUN/STOP exit
    cmp #32
    bne mix_key
    lda phase
    eor #$80                 ; SPACE freezes/resumes the current native frame
    sta phase
mix_key:
    cmp #77                  ; M cycles the A:B duty ratio
    bne rate_key
    dec weight
    lda weight
    bne rate_key
    lda #3
    sta weight
rate_key:
    sec
    sbc #49                  ; keys 1..9 = video frames per animation phase
    cmp #9
    bcs raster_low
    adc #1
    sta rate
    sta ticks
raster_low:
    bit $d011
    bmi raster_low
raster_high:
    bit $d011
    bpl raster_high
    lda phase
    bmi poll
    dec ticks
    bne poll
    lda rate
    sta ticks
    lda phase
    eor #2                   ; phase order 0,2,1,3: equal mixing is A,B,A,B
    cmp #2
    bcs next_phase
    eor #1
next_phase:
    sta phase
    jmp draw
advance_row:
    clc
    lda ptr
    adc #40
    sta ptr
    bcc advanced
    inc ptr+1
advanced:
    rts
banner:
    .text "1-9:1 M:2/4 SPACE STOP"
    .byte 13,13
    .text "            "
hex:
    .text "0123456789ABCDEF"
    .byte 0

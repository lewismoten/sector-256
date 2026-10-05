; Sector 256: each distinct pair of the 16 C64 colors, temporally swatched.
; Rows = color A; columns = color B. Four-frame duty: 1:3, 2:2, or 3:1.
; Draw the lower triangle; initialize the native-color diagonal only once.
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
    lda #<$047f              ; screen row 3, column 7: row label
    sta ptr
    lda #>$047f
    sta ptr+1
    ldx #0
init_row:
    txa
    tay
    iny                      ; mixed cells plus the diagonal, no duplicate half
    lda #$a0                 ; inverse spaces: solid swatches
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
    lda phase
    cmp weight
    lda #$8a                 ; TXA: color A is the row number
    bcc set_source
    lda #$98                 ; TYA: color B is the column number
set_source:
    sta color_source         ; decide once per phase instead of once per cell
    lda #<$d880              ; color RAM at row 3, column 8
    sta ptr
    lda #>$d880
    sta ptr+1
    ldx #0
draw_row:
    txa
    tay
skip_diagonal:
    nop                      ; becomes DEY after the initial native-color fill
    bmi next_row             ; row 0 has no mixed cells after initialization
draw_cell:
color_source:
    txa                      ; patched to TXA/TYA by set_source
    sta (ptr),y
    dey
    bpl draw_cell
next_row:
    jsr advance_row
    inx
    cpx #16
    bne draw_row
    lda #$88                 ; DEY excludes the fixed diagonal from later fills
    sta skip_diagonal
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
    sbc #48                  ; CMP #77 left C=0 for numeric keys: A - 49
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
    .text "1-9:1 M:2/4 SPACE"
    .byte 13,13
    .text "        "
hex:
    .text "0123456789ABCDEF"
    .byte 0

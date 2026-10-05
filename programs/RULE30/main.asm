; Rule 30 elementary cellular automaton on a centered 256 x 200 bitmap.
.include "api.inc"
.cpu "6502"
* = $c000
ypos = $02
index = $03
left = $04
cell = $20
current = $c200
next = $c220

reset:
    jsr HIRES
    lda #0
    sta ypos
    ldx #31
clear_rows:
    sta current,x
    sta next,x
    dex
    bpl clear_rows
    lda #$80                   ; one cell in the center of generation zero
    sta current+16
    jsr render

frame:
    jsr POLLKEY
    cmp #32
    beq reset
    lda ypos
    cmp #199
    beq wait_raster            ; leave the completed pattern on screen
    jsr evolve
    inc ypos
    jsr render
wait_raster:
    lda $d012
    bne wait_raster
    jmp frame

; next = left XOR (center OR right), calculated eight cells at a time.
evolve:
    ldx #0
byte:
    stx index
    txa
    sec
    sbc #1
    and #31
    tax
    lda current,x
    lsr                         ; previous byte bit 0 becomes carry
    ldx index
    lda current,x
    ror                         ; left-neighbor vector
    sta left
    txa
    clc
    adc #1
    and #31
    tax
    lda current,x
    asl                         ; next byte bit 7 becomes carry
    ldx index
    lda current,x
    rol                         ; right-neighbor vector
    ora current,x
    eor left
    sta next,x
    inx
    cpx #32
    bne byte
    ldx #31
copy:
    lda next,x
    sta current,x
    dex
    bpl copy
    rts

; Copy the packed logical row into one VIC-II bitmap scanline.
render:
    lda ypos
    lsr
    lsr
    lsr
    tax
    clc
    lda row_lo,x
    adc #32                    ; center the 256-pixel row
    sta cell
    lda row_hi,x
    adc #0
    sta cell+1
    lda ypos
    and #7
    tay
    ldx #0
draw_byte:
    lda current,x
    sta (cell),y
    clc
    lda cell
    adc #8
    sta cell
    bcc byte_drawn
    inc cell+1
byte_drawn:
    inx
    cpx #32
    bne draw_byte
    rts

row_lo: .byte <($6000+range(25)*320)
row_hi: .byte >($6000+range(25)*320)

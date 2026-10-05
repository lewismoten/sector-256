; The chaos game: random triangle vertices converge on a Sierpinski gasket.
.include "api.inc"
.cpu "6502"
* = $c000
xpos = $02
ypos = $03
points = $04
mask = $05
cell = $20

reset:
    jsr HIRES
    lda #128
    sta xpos
    lda #100
    sta ypos

frame:
    jsr POLLKEY
    cmp #32
    beq reset
    lda #64                    ; plot 3,200 points/second on PAL
    sta points
point:
    jsr RANDOM
mod_three:
    cmp #3                     ; RANDOM's 1..255 range divides evenly by three
    bcc vertex_ready
    sbc #3
    bcs mod_three
vertex_ready:
    tax
    lda xpos
    clc
    adc vertex_x,x
    ror                         ; divide the nine-bit sum by two
    sta xpos
    lda ypos
    clc
    adc vertex_y,x
    ror
    sta ypos
    jsr plot
    dec points
    bne point
wait_raster:
    lda $d012
    bne wait_raster
    jmp frame

; Plot logical pixel (x,y) at screen position (x+32,y).
plot:
    lda ypos
    lsr
    lsr
    lsr
    tax
    clc
    lda row_lo,x
    adc #32
    sta cell
    lda row_hi,x
    adc #0
    sta cell+1
    lda xpos
    and #$f8
    clc
    adc cell
    sta cell
    bcc column_ready
    inc cell+1
column_ready:
    lda ypos
    and #7
    tay
    lda xpos
    and #7
    tax
    lda masks,x
    sta mask
    lda (cell),y
    ora mask
    sta (cell),y
    rts

vertex_x: .byte 128,16,240
vertex_y: .byte 8,190,190
masks: .byte $80,$40,$20,$10,8,4,2,1
row_lo: .byte <($6000+range(25)*320)
row_hi: .byte >($6000+range(25)*320)

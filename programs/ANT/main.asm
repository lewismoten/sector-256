; Langton's Ant on a centered 256 x 200 high-resolution, wrapping field.
.include "api.inc"
.cpu "6502"
* = $c000
xpos = $02
ypos = $03
direction = $04               ; 0 up, 1 right, 2 down, 3 left
steps = $05
mask = $06
cell = $20

reset:
    jsr HIRES                  ; clear both bitmaps; display cyan on black
    lda #128
    sta xpos
    lda #100
    sta ypos
    lda #0
    sta direction

frame:
    jsr POLLKEY
    cmp #32
    beq reset
    lda #16                    ; 800 ant steps/second on a PAL C64
    sta steps
step:
    jsr address
    lda (cell),y
    and mask
    beq white
black:
    lda direction             ; black: turn left
    sec
    sbc #1
    jmp turned
white:
    lda direction             ; white: turn right
    clc
    adc #1
turned:
    and #3
    sta direction
    lda (cell),y              ; flip the current high-resolution cell
    eor mask
    sta (cell),y
    jsr move
    dec steps
    bne step
wait_raster:
    lda $d012
    bne wait_raster
    jmp frame

; Locate pixel (x+32,y) in the VIC-II's interleaved $6000 bitmap.
address:
    lda ypos
    lsr
    lsr
    lsr
    tax
    clc
    lda row_lo,x
    adc #32                    ; center the 256-pixel field on the screen
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
    rts

move:
    ldx direction
    beq up
    dex
    beq right
    dex
    beq down
left:
    dec xpos                   ; 8-bit X wraps across all 256 columns
    rts
up:
    dec ypos
    lda ypos
    cmp #$ff
    bne moved
    lda #199
    sta ypos
    rts
right:
    inc xpos                   ; 8-bit X wraps across all 256 columns
    rts
down:
    inc ypos
    lda ypos
    cmp #200
    bcc moved
    lda #0
    sta ypos
moved:
    rts

masks: .byte $80,$40,$20,$10,8,4,2,1
row_lo: .byte <($6000+range(25)*320)
row_hi: .byte >($6000+range(25)*320)

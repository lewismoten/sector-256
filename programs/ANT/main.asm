; Langton's Ant on a wrapping 40 x 25 field, eight ant steps per video frame.
.include "api.inc"
.cpu "6502"
* = $c000
xpos = $02
ypos = $03
direction = $04               ; 0 up, 1 right, 2 down, 3 left
steps = $05
cell = $20
grid = $c400

    lda #0
    sta $d020
    sta $d021
reset:
    jsr CLEAR
    lda #3                     ; cyan trail on black
    ldx #0
color:
.for i in range(4)
    sta $d800+i*$100,x
.endfor
    inx
    bne color
    txa                        ; X and A are both zero here
clear:
.for i in range(4)
    sta grid+i*$100,x
.endfor
    inx
    bne clear
    lda #20
    sta xpos
    lda #12
    sta ypos
    lda #0
    sta direction

frame:
    jsr POLLKEY
    cmp #32
    beq reset
    lda #8
    sta steps
step:
    jsr address
    ldy #0
    lda (cell),y
    beq white
black:
    lda #0                     ; black: turn left and make the cell white
    sta (cell),y
    lda #32
    jsr plot
    lda direction
    sec
    sbc #1
    jmp turned
white:
    lda #1                     ; white: turn right and make the cell black
    sta (cell),y
    lda #$a0
    jsr plot
    lda direction
    clc
    adc #1
turned:
    and #3
    sta direction
    jsr move
    dec steps
    bne step
    jsr address
    lda #42                    ; show the ant over its underlying cell state
    jsr plot
wait_raster:
    lda $d012
    bne wait_raster
    jmp frame

; Form $c400 + y*40 + x. Repeated addition is compact and fast enough here.
address:
    lda xpos
    sta cell
    lda #>grid
    sta cell+1
    ldx ypos
    beq addressed
add_row:
    clc
    lda cell
    adc #40
    sta cell
    bcc row_added
    inc cell+1
row_added:
    dex
    bne add_row
addressed:
    rts

; The grid and screen have matching low bytes; their high bytes differ by $c0.
plot:
    pha
    lda cell+1
    eor #$c0
    sta cell+1
    pla
    sta (cell),y
    lda cell+1
    eor #$c0
    sta cell+1
    rts

move:
    ldx direction
    beq up
    dex
    beq right
    dex
    beq down
left:
    dec xpos
    bpl moved
    lda #39
    sta xpos
    bpl moved
up:
    dec ypos
    bpl moved
    lda #24
    sta ypos
    bpl moved
right:
    inc xpos
    lda xpos
    cmp #40
    bcc moved
    lda #0
    sta xpos
    beq moved
down:
    inc ypos
    lda ypos
    cmp #25
    bcc moved
    lda #0
    sta ypos
moved:
    rts

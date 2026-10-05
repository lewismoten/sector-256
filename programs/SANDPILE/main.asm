; Abelian sandpile: color RAM is both the cell state and the live display.
.include "api.inc"
.cpu "6502"
* = $c000
rows = $02
stack_size = $03
drops = $04
cell = $20
neighbor = $22
center = $d9f4                ; screen row 12, column 20
stack_lo = $c800
stack_hi = $c900

reset:
    jsr CLEAR                 ; spaces form the one-cell absorbing border
    lda #0
    sta $d020
    sta $d021
    ldx #0
clear_colors:
.for i in range(4)
    sta $d800+i*$100,x
.endfor
    inx
    bne clear_colors
    lda #<$0428               ; fill rows 1..23, columns 1..38 with blocks
    sta cell
    lda #>$0428
    sta cell+1
    lda #23
    sta rows
    lda #$a0
fill_row:
    ldy #38
fill_cell:
    sta (cell),y
    dey
    bne fill_cell
    clc
    pha
    lda cell
    adc #40
    sta cell
    bcc row_ready
    inc cell+1
row_ready:
    pla
    dec rows
    bne fill_row
    lda #0
    sta stack_size

frame:
    jsr POLLKEY
    cmp #32
    beq reset
    lda #16                    ; add and completely relax sixteen grains
    sta drops
drop:
    lda center
    and #15
    clc
    adc #1
    sta center
    cmp #4
    bne drop_done
    lda #<center
    sta neighbor
    lda #>center
    sta neighbor+1
    jsr push
relax:
    lda stack_size
    beq drop_done
    dec stack_size
    ldy stack_size
    lda stack_lo,y
    sta cell
    lda stack_hi,y
    sta cell+1
    ldy #0
    lda (cell),y
    and #15
    sec
    sbc #4
    sta (cell),y
    cmp #4
    bcc neighbors
    lda cell
    sta neighbor
    lda cell+1
    sta neighbor+1
    jsr push                    ; a heavily loaded cell may topple again
neighbors:
    ldx #3
neighbor_loop:
    ldy #0                     ; push uses Y as its stack index
    clc
    lda cell
    adc offsets_lo,x
    sta neighbor
    lda cell+1
    adc offsets_hi,x
    sta neighbor+1
    eor #$dc                   ; matching screen cell: spaces are sinks
    sta neighbor+1
    lda (neighbor),y
    pha
    lda neighbor+1
    eor #$dc
    sta neighbor+1
    pla
    cmp #$a0
    bne next_neighbor
    lda (neighbor),y
    and #15
    clc
    adc #1
    sta (neighbor),y
    cmp #4
    bne next_neighbor
    jsr push
next_neighbor:
    dex
    bpl neighbor_loop
    jmp relax
drop_done:
    dec drops
    bne drop
wait_raster:
    lda $d012
    bne wait_raster
    jmp frame

push:
    ldy stack_size
    lda neighbor
    sta stack_lo,y
    lda neighbor+1
    sta stack_hi,y
    inc stack_size
    rts

offsets_lo: .byte $d8,$ff,1,40
offsets_hi: .byte $ff,$ff,0,0

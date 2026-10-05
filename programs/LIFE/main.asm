; Conway's Game of Life on a 38 x 23 text-cell field.
; Screen RAM is the current generation; $c400 is the next generation.
.include "api.inc"
.cpu "6502"
* = $c000
rows = $02
column = $03
neighbors = $04
base = $05
source = $20
target = $22
seed_ptr = $24
next = $c400
live = $a0
dead = 32

    lda #0
    sta $d020
    sta $d021
seed:
    jsr CLEAR
    lda #13                    ; light green cells on black
    ldx #0
color:
.for i in range(4)
    sta $d800+i*$100,x
.endfor
    inx
    bne color
    lda #dead
    ldx #0
clear_next:
.for i in range(4)
    sta next+i*$100,x
.endfor
    inx
    bne clear_next
    ldx #0                     ; scatter 256 cells into the 1 KB screen page
seed_cell:
    jsr RANDOM
    and #3
    ora #4
    sta seed_ptr+1
    jsr RANDOM
    sta seed_ptr
    lda #live
    ldy #0
    sta (seed_ptr),y
    dex
    bne seed_cell

generation:
    lda #<$0400                ; source points at the preceding row
    sta source
    lda #>$0400
    sta source+1
    lda #<(next+40)            ; target points at the row being produced
    sta target
    lda #>(next+40)
    sta target+1
    lda #23
    sta rows
row:
    lda #1
    sta column
cell:
    sec
    sbc #1
    sta base
    lda #0
    sta neighbors
    ldx #7
count:
    lda offsets,x
    clc
    adc base
    tay
    lda (source),y
    cmp #live
    bne empty
    inc neighbors
empty:
    dex
    bpl count
    lda neighbors
    cmp #3
    beq alive
    cmp #2
    bne dead_cell
    lda column
    clc
    adc #40
    tay
    lda (source),y
    cmp #live
    beq store
dead_cell:
    lda #dead
    bne store
alive:
    lda #live
store:
    ldy column
    sta (target),y
    inc column
    lda column
    cmp #39
    bne cell
    clc
    lda source
    adc #40
    sta source
    bcc source_ready
    inc source+1
source_ready:
    clc
    lda target
    adc #40
    sta target
    bcc target_ready
    inc target+1
target_ready:
    dec rows
    bne row

    ldx #0                     ; publish the completed generation at once
copy:
.for i in range(4)
    lda next+i*$100,x
    sta $0400+i*$100,x
.endfor
    inx
    bne copy
    jsr POLLKEY
    cmp #32
    beq seed
    jmp generation

offsets: .byte 0,1,2,40,42,80,81,82

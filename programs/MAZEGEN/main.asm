; Sector 256: a 19 x 10-room perfect maze using the binary-tree algorithm.
; Each room joins north or east. The top-right room is the root, so the
; resulting 189 links connect all 190 rooms without cycles.
; Screen RAM is the maze; no maze-specific generator lives in the launcher.
.include "api.inc"
.cpu "6502"
* = $c000
rowptr = $02
northptr = $04
fillptr = $20
generate:
    jsr CLEAR
    ldx #0
title_loop:
    lda title,x
    beq fill_setup
    jsr PUTCHAR
    inx
    bne title_loop
fill_setup:
    lda #<$0450              ; maze begins at screen row 2, column 0
    sta fillptr
    lda #>$0450
    sta fillptr+1
    ldx #21
fill_row:
    ldy #38                  ; 39 columns; column 39 stays blank
    lda #$a0                 ; inverse space: a solid 8 x 8 wall
fill_cell:
    sta (fillptr),y
    dey
    bpl fill_cell
    clc
    lda fillptr
    adc #40
    sta fillptr
    bcc fill_next
    inc fillptr+1
fill_next:
    dex
    bne fill_row
    lda #<$0479              ; first room: screen row 3, column 1
    sta rowptr
    lda #>$0479
    sta rowptr+1
    ldx #10
room_row:
    sec
    lda rowptr
    sbc #40
    sta northptr
    lda rowptr+1
    sbc #0
    sta northptr+1
    ldy #0
room:
    jsr POLLKEY              ; RUN/STOP is responsive while generating
    lda #32
    sta (rowptr),y            ; open this room
    cpx #10
    beq east                 ; top row can only join east
    cpy #36
    beq north                ; rightmost column can only join north
    jsr RANDOM
    lsr
    bcc north
east:
    cpy #36
    beq next_room            ; top-right root needs no link
    iny
    lda #32
    sta (rowptr),y
    dey
    bpl next_room
north:
    lda #32
    sta (northptr),y
next_room:
    iny
    iny
    cpy #38
    bne room
    clc
    lda rowptr
    adc #80                  ; move down two text rows
    sta rowptr
    bcc next_row
    inc rowptr+1
next_row:
    dex
    bne room_row
    lda #32
    sta $0771                ; entrance: bottom-left boundary
    sta $0475                ; exit: top-right boundary
wait:
    jsr WAITKEY
    cmp #32
    bne wait
    jmp generate
title:
    .text "MAZEGEN  SPACE:NEW  RUN/STOP:EXIT"
    .byte 0

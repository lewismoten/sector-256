; Two-player tic-tac-toe. Screen doubles as the nine-cell board.
; Keys 1-9 place a mark. W=win, D=draw; RETURN restarts, RUN/STOP exits.
.include "api.inc"
.cpu "6502"
* = $c000
turn = $02
moves = $03
key = $04
restart:
    jsr CLEAR
    lda #24                    ; screen code X
    sta turn
    lda #0
    sta moves
    ldx #8
init_board:
    lda positions,x
    tay
    txa
    clc
    adc #49
    sta $0400,y
    dex
    bpl init_board
    ldx #0
print_title:
    lda title,x
    beq input
    jsr PUTCHAR
    inx
    bne print_title
input:
    jsr WAITKEY
    sec
    sbc #49
    cmp #9
    bcs input
    tax
    lda positions,x
    tay
    lda $0400,y
    cmp #49
    bcc input                  ; occupied X/O have screen codes below 49
    lda turn
    sta $0400,y
    inc moves
    ldx #0
check_line:
    lda lines,x
    tay
    lda $0400,y
    cmp turn
    bne next_line
    lda lines+1,x
    tay
    lda $0400,y
    cmp turn
    bne next_line
    lda lines+2,x
    tay
    lda $0400,y
    cmp turn
    beq won
next_line:
    inx
    inx
    inx
    cpx #24
    bne check_line
    lda moves
    cmp #9
    beq draw
    lda turn
    eor #23                    ; screen X (24) <-> O (15)
    sta turn
    jmp input
won:
    lda turn
    ora #64
    jsr PUTCHAR
    lda #87
    bne finished
draw:
    lda #68
finished:
    jsr PUTCHAR
    ldx #0
print_finish:
    lda finish_text,x
    beq wait_restart
    jsr PUTCHAR
    inx
    bne print_finish
wait_restart:
    jsr WAITKEY
    cmp #13
    bne wait_restart
    jmp restart
positions: .byte 82,84,86,122,124,126,162,164,166
lines:
.byte 82,84,86,122,124,126,162,164,166
.byte 82,122,162,84,124,164,86,126,166
.byte 82,124,166,86,124,162
title: .text "TIC-TAC-TOE  1-9",13
.byte 0
finish_text: .text " W=WIN D=DRAW",13,"RETURN=AGAIN STOP=EXIT"
.byte 0

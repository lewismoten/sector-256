; A/D moves the runner. Survive each falling block to raise the score.
.include "api.inc"
.cpu "6502"
* = $c000
block_x = $02
block_y = $03
player = $04
block_ptr = $20
text_ptr = $22

    lda #>title
    sta text_ptr+1
restart:
    jsr CLEAR
    ldx #<title
    jsr print
    lda #15
    sta player
    jsr new_block
draw:
    ldy #0
    lda #$a0
    sta (block_ptr),y
    ldx player
    lda #30
    sta $0798,x
wait_raster:
    lda $d012
    bne wait_raster
frame:
    jsr POLLKEY
    pha
    ldx player
    lda #32
    sta $0798,x
    ldy #0
    sta (block_ptr),y
    pla
    cmp #65
    bne check_right
    ldx player
    beq moved
    dec player
    bne moved
check_right:
    cmp #68
    bne moved
    lda player
    cmp #31
    beq moved
    inc player
moved:
    lda block_y
    cmp #22
    beq landed
    inc block_y
    clc
    lda block_ptr
    adc #40
    sta block_ptr
    bcc draw
    inc block_ptr+1
    bne draw
landed:
    lda block_x
    cmp player
    beq crashed
    inc $040b                  ; S0 becomes S1, S2 ...
    jsr new_block
    jmp draw
crashed:
    jsr CLEAR
    ldx #<over
    jsr print
again:
    jsr WAITKEY
    cmp #13
    bne again
    jmp restart

new_block:
    jsr RANDOM
    and #31
    sta block_x
    sta block_ptr
    lda #4
    sta block_ptr+1
    lda #0
    sta block_y
    rts

print:
    stx text_ptr
    ldy #0
print_loop:
    lda (text_ptr),y
    beq printed
    jsr PUTCHAR
    iny
    bne print_loop
printed:
    rts

title: .text "DODGE A/D S0",13
.byte 0
over: .text "CRASH!",13,"RETURN=AGAIN STOP=EXIT"
.byte 0

; Two drivers hold their line. The first one to swerve loses.
.include "api.inc"
.cpu "6502"
* = $c000
timer = $02
text_ptr = $20

    lda #>title
    sta text_ptr+1
round:
    jsr CLEAR
    ldx #<title
    jsr print
    jsr RANDOM
    and #31
    clc
    adc #10
    sta timer
wait_raster:
    lda $d012
    bne wait_raster
wait:
    jsr POLLKEY
    bne jumped
    dec timer
    bne wait_raster
    ldx #<go
    jsr print
swerve:
    jsr WAITKEY
    cmp #65
    beq p1_swerve
    cmp #76
    bne swerve
    ldx #<p2_lost
    bne result
p1_swerve:
    ldx #<p1_lost
result:
    jsr print
again:
    jsr WAITKEY
    cmp #13
    bne again
    jmp round
jumped:
    ldx #<early
    bne result

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

title: .text "CHICKEN P1=A P2=L",13,"DON'T SWERVE...",13
.byte 0
go: .text "GO!",13
.byte 0
p1_lost: .text "P1 SWERVES! P2 WINS",13
.byte 0
p2_lost: .text "P2 SWERVES! P1 WINS",13
.byte 0
early: .text "JUMPED! BOTH LOSE",13
.byte 0

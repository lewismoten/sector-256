; SNOW: one- and two-pixel flakes settle into uneven pixel-high drifts.
.include "api.inc"
.cpu "6502"
* = $c000
tick = $02
flake = $03
ptr = $20
fx = $c200
fy = $c240
height = $c300

    jsr HIRES
    lda #$10                   ; white pixels on black in the visible bitmap
    ldx #0
white:
.for i in range(4)
    sta $4000+i*$100,x
.endfor
    inx
    bne white
    txa
    ldx #127
clear_heights:
    sta height,x
    dex
    bpl clear_heights
    lda #63
    sta flake
seed:
    ldx flake
    jsr new_x
    jsr RANDOM
    and #$bf
    sta fy,x
    clc
    jsr plot
    dec flake
    bpl seed
frame:
    jsr POLLKEY
    inc tick
    lda #63
    sta flake
snow:
    clc
    jsr plot                    ; erase the previous position
    lda flake
    and #1
    beq fall
    lda tick
    and #1
    bne no_fall
fall:
    inc fy,x
no_fall:
    ldy fx,x
    lda fy,x
    clc
    adc height,y
    cmp #199
    bcc draw_flake
    lda height,y
    cmp #8
    bcs respawn
    lda #199
    sec
    sbc height,y
    sta fy,x
    tya
    tax
    inc height,x
    jsr plot                    ; this flake remains in its stack
respawn:
    jsr new_x
    lda #0
    sta fy,x
draw_flake:
    clc
    jsr plot
    dec flake
    bpl snow
wait_raster:
    lda $d012
    bne wait_raster
    jmp frame

new_x:
    jsr RANDOM
    and #127
    sta fx,x
    rts

; Carry selects the solid two-pixel settled mask; moving flakes use their size.
; X is restored to the flake index before returning.
plot:
    php
    ldx flake
    lda fy,x
    lsr
    lsr
    lsr
    tax
    and #3
    tay
    lda row_lo,y
    sta ptr
    txa
    clc
    adc #$60
    sta ptr+1
    txa
    lsr
    lsr
    clc
    adc ptr+1
    sta ptr+1
    ldx flake
    lda fx,x
    lsr
    lsr
    asl
    asl
    asl
    clc
    adc ptr
    sta ptr
    bcc pixel_addr_ready
    inc ptr+1
pixel_addr_ready:
    lda fy,x
    and #7
    tay
    lda fx,x
    and #3
    asl
    sta $04
    txa
    and #1
    ora $04
    tax
    plp
    bcc moving_mask
    txa
    and #$fe
    tax
moving_mask:
    lda masks,x
    eor (ptr),y
    sta (ptr),y
    ldx flake
    rts
row_lo: .byte $20,$60,$a0,$e0
masks: .byte $c0,$80,$30,$20,$0c,$08,$03,$02

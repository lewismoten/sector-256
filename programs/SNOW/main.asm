; SNOW: twenty-four drifting flakes settle into a growing white snowbank.
.include "api.inc"
.cpu "6502"
* = $c000
depth = $02
row = $03
landings = $04
flake = $05
top = $20
ptr = $21
flake_x = $c200
flake_y = $c218

    jsr HIRES
    ; Both bitmap buffers use white on black, like a winter night.
    lda #$10
    ldx #0
white:
.for i in range(4)
    sta $4000+i*$100,x
    sta $8000+i*$100,x
.endfor
    inx
    bne white
    lda #0
    sta landings
    lda #1
    sta depth
    ldx #23
seed:
    jsr RANDOM
    sta flake_x,x
    jsr RANDOM
    and #$bf
    sta flake_y,x
    dex
    bpl seed
frame:
    jsr POLLKEY
    jsr NEWFRAME
    lda #199
    sec
    sbc depth
    sta top
    lda #23
    sta flake
snow:
    ldx flake
    lda flake_y,x
    clc
    adc #1
    cmp top
    bcc falling
    lda #0
    sta flake_y,x
    jsr RANDOM
    sta flake_x,x
    inc landings
    lda landings
    and #3
    bne next_flake
    lda depth
    cmp #18
    bcs next_flake
    inc depth
    jmp next_flake
falling:
    sta flake_y,x
    sta LINE_Y0
    sta LINE_Y1
    lda flake_x,x
    sta LINE_X0
    clc
    adc #1
    sta LINE_X1
    jsr LINE
next_flake:
    dec flake
    bpl snow
    lda #255
    sta LINE_X1
    lda depth
    sta row
bank:
    lda #0
    sta LINE_X0
    lda #199
    sec
    sbc row
    sta LINE_Y0
    sta LINE_Y1
    jsr LINE
    jsr right_bank
    dec row
    bpl bank
    jsr FLIP
    jmp frame

; The shared LINE routine reaches X=255. Fill X=256..319 directly in the
; hidden bitmap so the bank spans the entire 320-pixel screen.
right_bank:
    lda LINE_Y0
    lsr
    lsr
    lsr
    sec
    sbc #22
    tax
    lda bank_lo,x
    sta ptr
    lda bank_hi,x
    sta ptr+1
    lda $dd00
    and #3
    cmp #1
    bne bank_addr_ready
    lda ptr+1
    eor #$c0
    sta ptr+1
bank_addr_ready:
    lda LINE_Y0
    and #7
    tay
    ldx #8
right_cells:
    lda #$ff
    sta (ptr),y
    tya
    clc
    adc #8
    tay
    dex
    bne right_cells
    rts
bank_lo: .byte $80,$c0,$00
bank_hi: .byte $bc,$bd,$bf

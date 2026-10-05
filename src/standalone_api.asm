; Standalone Sector 256 bootstrap and API. Included by scripts/standalone.py.
; It deliberately contains no catalog or launcher-return code.
.cpu "6502"
* = $0801
.word standalone_basic_end, 10
.byte $9e
.text "2061"
.byte 0
standalone_basic_end: .word 0

standalone_entry:
    cld
    lda #$36
    sta $01
    lda #<api_payload
    sta standalone_src
    lda #>api_payload
    sta standalone_src+1
    lda #<$c000
    sta standalone_dst
    lda #>$c000
    sta standalone_dst+1
    lda #<api_payload_size
    sta standalone_count
    lda #>api_payload_size
    sta standalone_count+1
standalone_copy:
    lda standalone_count
    ora standalone_count+1
    beq standalone_start
    ldy #0
    lda (standalone_src),y
    sta (standalone_dst),y
    inc standalone_src
    bne standalone_src_ready
    inc standalone_src+1
standalone_src_ready:
    inc standalone_dst
    bne standalone_dst_ready
    inc standalone_dst+1
standalone_dst_ready:
    lda standalone_count
    bne standalone_dec
    dec standalone_count+1
standalone_dec:
    dec standalone_count
    jmp standalone_copy
standalone_start:
    jsr standalone_text
    lda #147
    jsr $ffd2
    tsx
    stx standalone_game_stack
    jsr $c000
    jmp standalone_finish
standalone_finish:
    jsr standalone_text
    lda #0
    sta $d015
    sta $d418
    rts

standalone_src = $fb
standalone_dst = $fd
standalone_count: .word 0
standalone_game_stack: .byte 0

.fill $1000-*, 0
; Stable program ABI: these entry points must remain $1000..$101b.
jmp standalone_waitkey          ; $1000
jmp standalone_clear            ; $1003
jmp $ffd2                       ; $1006
jmp standalone_random           ; $1009
jmp standalone_pollkey          ; $100c
jmp standalone_exit             ; $100f
jmp standalone_hires            ; $1012
jmp standalone_newframe         ; $1015
jmp standalone_line             ; $1018
jmp standalone_flip             ; $101b

; Text and input services.
standalone_text:
    lda #$36
    sta $01
    lda $dd00
    ora #3
    sta $dd00
    lda #$14
    sta $d018
    lda #$1b
    sta $d011
    lda #$08
    sta $d016
    lda #4
    sta $0288
    lda #1
    sta $0286
    lda #6
    sta $d020
    sta $d021
    rts
standalone_clear:
    lda #147
    jmp $ffd2
standalone_waitkey:
    jsr standalone_pollkey
    beq standalone_waitkey
    rts
standalone_pollkey:
    jsr $ffe1
    beq standalone_exit
    jmp $ffe4
; Restore the stack captured before JSR $c000, so EXIT and RUN/STOP work
; from any nested program/API call without launcher-specific state.
standalone_exit:
    ldx standalone_game_stack
    txs
    jmp standalone_finish
standalone_random:
    lda standalone_random_state
    asl
    bcc standalone_random_no_feedback
    eor #$1d
standalone_random_no_feedback:
    eor $a2
    bne standalone_random_nonzero
    lda #$a7
standalone_random_nonzero:
    sta standalone_random_state
    rts
standalone_random_state: .byte $a7

; Double-buffered hires graphics compatible with the launcher API.
standalone_hires:
    lda #$36
    sta $01
    lda $dd00
    and #$fc
    ora #2
    sta $dd00
    lda #$08
    sta $d018
    lda #$3b
    sta $d011
    lda #$08
    sta $d016
    lda #0
    sta $d020
    sta $d021
    sta $d015
    jsr standalone_clear_6000
    jsr standalone_clear_a000
    lda #$30
    ldx #0
standalone_colors:
.for i in range(4)
    sta $4000+i*$100,x
    sta $8000+i*$100,x
.endfor
    inx
    bne standalone_colors
    lda #$a0
    sta standalone_back_hi
    lda #$c0
    sta standalone_address_xor
    rts
standalone_newframe:
    lda standalone_back_hi
    cmp #$60
    beq standalone_clear_6000
    jmp standalone_clear_a000
standalone_clear_6000:
    lda #0
    ldx #0
standalone_clear_6000_loop:
.for i in range(32)
    sta $6000+i*$100,x
.endfor
    inx
    bne standalone_clear_6000_loop
    rts
standalone_clear_a000:
    lda #0
    ldx #0
standalone_clear_a000_loop:
.for i in range(32)
    sta $a000+i*$100,x
.endfor
    inx
    bne standalone_clear_a000_loop
    rts
standalone_flip:
standalone_flip_wait_low:
    bit $d011
    bmi standalone_flip_wait_low
standalone_flip_wait_high:
    bit $d011
    bpl standalone_flip_wait_high
    lda $dd00
    and #$fc
    ldx standalone_back_hi
    cpx #$a0
    bne standalone_flip_bank_one
    ora #1
    bne standalone_flip_bank_ready
standalone_flip_bank_one:
    ora #2
standalone_flip_bank_ready:
    sta $dd00
    lda standalone_back_hi
    eor #$c0
    sta standalone_back_hi
    lda standalone_address_xor
    eor #$c0
    sta standalone_address_xor
    rts

; Inclusive Bresenham line. Endpoints are ABI bytes $06-$09.
standalone_line:
    lda $07
    cmp #200
    bcs standalone_line_done
    lda $09
    cmp #200
    bcs standalone_line_done
    lda #1
    sta standalone_sx
    sta standalone_sy
    sec
    lda $08
    sbc $06
    bcs standalone_line_x_positive
    eor #$ff
    clc
    adc #1
    ldx #$ff
    stx standalone_sx
standalone_line_x_positive:
    sta standalone_dx
    sec
    lda $09
    sbc $07
    bcs standalone_line_y_positive
    eor #$ff
    clc
    adc #1
    ldx #$ff
    stx standalone_sy
standalone_line_y_positive:
    sta standalone_dy
    sec
    lda standalone_dx
    sbc standalone_dy
    sta standalone_error
    lda #0
    sbc #0
    sta standalone_error+1
standalone_line_loop:
    jsr standalone_pixel
    lda $06
    cmp $08
    bne standalone_line_not_done
    lda $07
    cmp $09
    beq standalone_line_done
standalone_line_not_done:
    lda standalone_error
    asl
    sta standalone_twice
    lda standalone_error+1
    rol
    sta standalone_twice+1
    clc
    lda standalone_twice
    adc standalone_dy
    sta standalone_compare
    lda standalone_twice+1
    adc #0
    bmi standalone_line_skip_x
    ora standalone_compare
    beq standalone_line_skip_x
    sec
    lda standalone_error
    sbc standalone_dy
    sta standalone_error
    lda standalone_error+1
    sbc #0
    sta standalone_error+1
    clc
    lda $06
    adc standalone_sx
    sta $06
standalone_line_skip_x:
    sec
    lda standalone_twice
    sbc standalone_dx
    lda standalone_twice+1
    sbc #0
    bpl standalone_line_loop
    clc
    lda standalone_error
    adc standalone_dx
    sta standalone_error
    lda standalone_error+1
    adc #0
    sta standalone_error+1
    clc
    lda $07
    adc standalone_sy
    sta $07
    jmp standalone_line_loop
standalone_line_done:
    rts
standalone_pixel:
    lda $07
    lsr
    lsr
    lsr
    tax
    lda standalone_rows_lo,x
    sta standalone_pixel_ptr
    lda standalone_rows_hi,x
    eor standalone_address_xor
    sta standalone_pixel_ptr+1
    lda $06
    and #$f8
    clc
    adc standalone_pixel_ptr
    sta standalone_pixel_ptr
    bcc standalone_pixel_no_carry
    inc standalone_pixel_ptr+1
standalone_pixel_no_carry:
    lda $07
    and #7
    tay
    lda $06
    and #7
    tax
    lda (standalone_pixel_ptr),y
    ora standalone_masks,x
    sta (standalone_pixel_ptr),y
    rts
standalone_rows_lo: .byte 0,64,128,192,0,64,128,192,0,64,128,192,0,64,128,192,0,64,128,192,0,64,128,192,0
standalone_rows_hi: .byte $60,$61,$62,$63,$65,$66,$67,$68,$6a,$6b,$6c,$6d,$6f,$70,$71,$72,$74,$75,$76,$77,$79,$7a,$7b,$7c,$7e
standalone_masks: .byte $80,$40,$20,$10,8,4,2,1
standalone_pixel_ptr = $f9
standalone_back_hi: .byte $a0
standalone_address_xor: .byte $c0
standalone_dx: .byte 0
standalone_dy: .byte 0
standalone_sx: .byte 1
standalone_sy: .byte 1
standalone_error: .word 0
standalone_twice: .word 0
standalone_compare: .byte 0

.if * > $c000
.error "standalone API exceeds payload destination"
.endif

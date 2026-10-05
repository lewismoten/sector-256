; Sector 256 -- 6502 graphical catalog launcher, assembled with 64tass.
; Disk catalogs stream through the KERNAL; only twelve records/icons stay in RAM.
.cpu "6502"
* = $0801
.word basic_end, 10
.byte $9e
.text "2061"
.byte 0
basic_end: .word 0
entry: jmp startup
.fill $1000-*, 0
; Stable ABI used by programs. Keep these addresses unchanged.
jmp wait_key                     ; $1000: blocking key, RUN/STOP exits program
jmp clear_text                   ; $1003: clear text screen
jmp $ffd2                        ; $1006: output PETSCII character in A
jmp random_byte                  ; $1009: pseudo-random byte in A
jmp poll_key                     ; $100c: nonblocking input, RUN/STOP exits
jmp return_from_game             ; $100f: explicit exit
jmp bitmap_begin                 ; $1012: initialize double-buffered bitmap
jmp bitmap_new_frame             ; $1015: clear hidden bitmap
jmp bitmap_line                  ; $1018: inclusive Bresenham line, endpoints $06-$09
jmp bitmap_flip                  ; $101b: show completed frame at raster 256

ptr = $fb
dst = $fd
colorptr = $f9
glyph = $f7
PAGE = $4800
REC = $4700
ICONRAM = $5000
FONT = $5800
SCREEN = $4000
BITMAP = $6000
PACK = $a000
GAME = $c000
SETNAM = $ffbd
SETLFS = $ffba
OPEN = $ffc0
CLOSE = $ffc3
CHKIN = $ffc6
CLRCHN = $ffcc
CHRIN = $ffcf
READST = $ffb7
GETIN = $ffe4
STOP = $ffe1
LOAD = $ffd5

startup:
    cld
    sei
    lda #$33                    ; I/O off: expose character ROM to CPU
    sta $01
    ldx #0
copy_font:
.for i in range(8)
    lda $d000+i*$100,x
    sta FONT+i*$100,x
.endfor
    inx
    bne copy_font
    lda #$36                    ; BASIC off, KERNAL and I/O on
    sta $01
    cli
    lda #1
    sta category_mode
    lda #0
    sta selected
    sta page_skip
    sta page_skip+1
    sta jump_letter
    jsr load_page
    jsr graphics_mode
    jsr draw_page
main_loop:
    jsr animate
    jsr STOP
    beq go_home
    jsr GETIN
    beq main_loop
    cmp #13
    beq activate
    cmp #$1d                    ; cursor right
    beq next_item
    cmp #$11                    ; cursor down
    beq down_item
    cmp #$9d                    ; cursor left
    beq previous_item
    cmp #$91                    ; cursor up
    beq up_item
    cmp #$85                    ; F1
    beq previous_page
    cmp #$86                    ; F3
    beq next_page
    cmp #$87                    ; F5
    beq go_home
    cmp #$14                    ; DEL also returns to categories
    beq go_home
    cmp #65
    bcc main_loop
    cmp #91
    bcs main_loop
    ldx category_mode
    bne main_loop
    sta jump_letter
    jmp reload_page
next_item:
    lda selected
    clc
    adc #1
    cmp page_count
    bcs main_loop
    jmp select_item
previous_item:
    lda selected
    beq main_loop
    sec
    sbc #1
    jmp select_item
down_item:
    lda selected
    clc
    adc #4
    cmp page_count
    bcs main_loop
    jmp select_item
up_item:
    lda selected
    cmp #4
    bcc main_loop
    sec
    sbc #4
select_item:
    sta selected
    jsr draw_names
    jsr draw_details
    jmp main_loop
go_home:
    lda #1
    sta category_mode
    lda #0
    sta page_skip
    sta page_skip+1
    sta jump_letter
release_stop:
    jsr STOP
    beq release_stop
    jmp reload_page
next_page:
    lda category_mode
    bne main_loop
    lda has_next
    beq main_loop
    clc
    lda page_skip
    adc #12
    sta page_skip
    bcc reload_page
    inc page_skip+1
    jmp reload_page
previous_page:
    lda category_mode
    bne main_loop
    lda page_skip
    ora page_skip+1
    beq main_loop
    sec
    lda page_skip
    sbc #12
    sta page_skip
    lda page_skip+1
    sbc #0
    sta page_skip+1
    bcs reload_page
    lda #0
    sta page_skip
    sta page_skip+1
reload_page:
    lda #0
    sta selected
    jsr load_page
    jsr draw_page
    jmp main_loop
activate:
    lda page_count
    beq main_loop
    lda selected
    jsr record_pointer
    lda category_mode
    beq run_program
    ldy #72
    lda (ptr),y
    sta category_id
    lda #0
    sta category_mode
    sta page_skip
    sta page_skip+1
    jmp reload_page

; KERNAL stream helpers. File names include ,S,R for SEQ data files.
open_stream:
    jsr SETNAM                  ; A length, X/Y filename pointer
    lda #2
    ldx #8
    ldy #2
    jsr SETLFS
    jsr OPEN
    bcs disk_error
    ldx #2
    jsr CHKIN
    bcs disk_error
    rts
close_stream:
    jsr CLRCHN
    lda #2
    jsr CLOSE
    rts
stream_byte:
    jsr READST
    bne disk_error              ; reject reading beyond EOF / other errors
    jsr CHRIN
    pha
    jsr READST
    and #$bf                   ; EOF on the final valid byte is allowed
    bne disk_error
    pla
    rts
read_header:
    ldy #0
read_header_loop:
    jsr stream_byte
    sta header,y
    iny
    cpy #8
    bne read_header_loop
    rts
open_records:
    jsr open_stream
    jsr read_header
    ldx #0
check_header:
    lda header,x
    cmp index_magic,x
    bne disk_error
    inx
    cpx #6
    bne check_header
    lda header+6
    sta records_left
    lda header+7
    sta records_left+1
    rts
read_record:
    ldy #0
read_record_loop:
    jsr stream_byte
    sta REC,y
    iny
    cpy #96
    bne read_record_loop
    lda records_left
    bne record_decrement
    dec records_left+1
record_decrement:
    dec records_left
    rts

load_page:
    lda #0
    sta page_count
    sta has_next
    sta matched
    sta matched+1
    lda category_mode
    beq open_program_index
    lda #12
    ldx #<cats_name
    ldy #>cats_name
    bne open_page_index
open_program_index:
    lda #13
    ldx #<index_name
    ldy #>index_name
open_page_index:
    jsr open_records
scan_record:
    lda records_left
    ora records_left+1
    beq page_loaded
    jsr read_record
    lda category_mode
    bne include_record
    lda REC+72
    cmp category_id
    bne scan_record
    lda jump_letter
    beq compare_skip
    cmp REC                    ; skip names with first letter below request
    beq found_letter
    bcc found_letter
    jmp increment_matched
found_letter:
    lda #0
    sta jump_letter
    lda matched
    sta page_skip
    lda matched+1
    sta page_skip+1
compare_skip:
    lda matched+1
    cmp page_skip+1
    bcc increment_matched
    bne include_record
    lda matched
    cmp page_skip
    bcc increment_matched
include_record:
    lda page_count
    cmp #12
    beq another_page
    jsr record_pointer
    ldy #0
copy_record:
    lda REC,y
    sta (ptr),y
    iny
    cpy #96
    bne copy_record
    inc page_count
increment_matched:
    inc matched
    bne scan_record
    inc matched+1
    jmp scan_record
another_page:
    lda #1
    sta has_next
page_loaded:
    jsr close_stream
    lda jump_letter            ; no letter found: keep a useful first page
    beq page_not_empty_check
    lda #0
    sta jump_letter
    sta page_skip
    sta page_skip+1
    jmp load_page
page_not_empty_check:
    lda page_count
    bne load_icons
    lda page_skip
    ora page_skip+1
    beq load_icons
    lda #0
    sta page_skip
    sta page_skip+1
    jmp load_page

; Calculate PAGE + A*96 into ptr.
record_pointer:
    tax
    lda #<PAGE
    sta ptr
    lda #>PAGE
    sta ptr+1
    cpx #0
    beq record_pointer_done
record_pointer_add:
    clc
    lda ptr
    adc #96
    sta ptr
    bcc record_pointer_no_carry
    inc ptr+1
record_pointer_no_carry:
    dex
    bne record_pointer_add
record_pointer_done:
    rts

; ICONS.DAT is a sequence of 36-byte frames. Page records are in icon order.
load_icons:
    lda #0
    sta slot
    sta stream_frame
    sta stream_frame+1
    lda #<ICONRAM
    sta icon_write
    lda #>ICONRAM
    sta icon_write+1
    lda page_count
    beq icons_done
    lda #13
    ldx #<icons_name
    ldy #>icons_name
    jsr open_stream
    jsr read_header
    ldx #0
check_icons_header:
    lda header,x
    cmp icons_magic,x
    bne disk_error
    inx
    cpx #6
    bne check_icons_header
    lda header+6
    sta icon_total
    lda header+7
    sta icon_total+1
load_slot_icons:
    lda slot
    jsr record_pointer
    ldy #79
    lda (ptr),y
    sta wanted_frame
    iny
    lda (ptr),y
    sta wanted_frame+1
    iny
    lda (ptr),y
    lsr
    lsr
    lsr
    lsr
    lsr
    lsr
    clc
    adc #1
    sta frames_left
    ldx slot
    sta frame_counts,x
    lda #0
    sta current_frames,x
    sta elapsed_lo,x
    sta elapsed_hi,x
    lda icon_write
    sta icon_offsets_lo,x
    lda icon_write+1
    sta icon_offsets_hi,x
skip_icon_frames:
    lda stream_frame+1
    cmp wanted_frame+1
    bne skip_one_frame
    lda stream_frame
    cmp wanted_frame
    beq copy_icon_frame
skip_one_frame:
    jsr check_frame_bounds
    ldy #36
skip_frame_bytes:
    jsr stream_byte
    dey
    bne skip_frame_bytes
    jsr increment_stream_frame
    jmp skip_icon_frames
copy_icon_frame:
    jsr check_frame_bounds
    lda icon_write
    sta dst
    lda icon_write+1
    sta dst+1
    ldy #0
copy_frame_bytes:
    jsr stream_byte
    sta (dst),y
    iny
    cpy #36
    bne copy_frame_bytes
    clc
    lda icon_write
    adc #36
    sta icon_write
    bcc icon_write_ready
    inc icon_write+1
icon_write_ready:
    jsr increment_stream_frame
    dec frames_left
    bne copy_icon_frame
    inc slot
    lda slot
    cmp page_count
    bne load_slot_icons
    jsr close_stream
icons_done:
    lda #0
    sta frame_latch
    rts
check_frame_bounds:
    lda stream_frame+1
    cmp icon_total+1
    bcc frame_in_bounds
    bne disk_error
    lda stream_frame
    cmp icon_total
    bcs disk_error
frame_in_bounds:
    rts
increment_stream_frame:
    inc stream_frame
    bne frame_incremented
    inc stream_frame+1
frame_incremented:
    rts

graphics_mode:
    lda $dd00
    and #$fc
    ora #2                     ; VIC bank $4000-$7fff
    sta $dd00
    lda #$08                   ; screen $4000, bitmap $6000
    sta $d018
    lda #$3b
    sta $d011
    lda #$08
    sta $d016
    lda #0
    sta $d020
    sta $d021
    sta $d015                  ; sprites off
    rts
text_mode:
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
    lda #0
    sta $d020
    sta $d021
    rts
clear_text:
    lda #147
    jmp $ffd2
clear_bitmap:
    jsr clear_bitmap_pixels
    lda #$10
    ldx #0
clear_color_loop:
.for i in range(4)
    sta SCREEN+i*$100,x
.endfor
    inx
    bne clear_color_loop
    rts

clear_bitmap_pixels:
    lda #0
    ldx #0
clear_bitmap_loop:
.for i in range(32)
    sta BITMAP+i*$100,x
.endfor
    inx
    bne clear_bitmap_loop
    rts

; Set bitmap/color pointers from text-cell row and column.
cell_pointers:
    ldx row
    lda bitmap_rows_lo,x
    sta dst
    lda bitmap_rows_hi,x
    sta dst+1
    lda color_rows_lo,x
    sta colorptr
    lda color_rows_hi,x
    sta colorptr+1
    clc
    lda colorptr
    adc column
    sta colorptr
    bcc cell_color_ready
    inc colorptr+1
cell_color_ready:
    lda column
    ldx #0
    asl
    asl
    asl
    bcc cell_offset_ready
    inx
cell_offset_ready:
    clc
    adc dst
    sta dst
    txa
    adc dst+1
    sta dst+1
    rts
blit_cell:
    jsr cell_pointers
    ldy #0
blit_cell_loop:
    lda (glyph),y
    sta (dst),y
    iny
    cpy #8
    bne blit_cell_loop
    ldy #0
    lda ink
    sta (colorptr),y
    rts
draw_character:
    cmp #64
    bcc character_code_ready
    and #$3f                   ; uppercase PETSCII -> screen code
character_code_ready:
    ldx #0
    asl
    asl
    asl
    bcc character_pointer_ready
    inx
character_pointer_ready:
    sta glyph
    txa
    clc
    adc #>FONT
    sta glyph+1
    jsr blit_cell
    inc column
    rts
print_string:
    lda #0
    sta text_index
print_string_loop:
    ldy text_index
    lda (ptr),y
    beq print_string_done
    jsr draw_character
    inc text_index
    bne print_string_loop
print_string_done:
    rts

; Draw four 8x8 cells using the current frame's bitmap and per-cell colors.
draw_icon:
    ldx slot
    lda icon_offsets_lo,x
    sta icon_read
    lda icon_offsets_hi,x
    sta icon_read+1
    ldy current_frames,x
    beq icon_frame_ready
icon_frame_advance:
    clc
    lda icon_read
    adc #36
    sta icon_read
    bcc icon_frame_no_carry
    inc icon_read+1
icon_frame_no_carry:
    dey
    bne icon_frame_advance
icon_frame_ready:
    lda #0
    sta quadrant
icon_quadrant:
    ldx slot
    lda slot_rows,x
    ldy quadrant
    cpy #2
    bcc icon_row_ready
    clc
    adc #1
icon_row_ready:
    sta row
    lda slot_columns,x
    clc
    adc #3
    sta column
    tya
    and #1
    clc
    adc column
    sta column
    lda quadrant
    asl
    asl
    asl
    clc
    adc icon_read
    sta glyph
    lda icon_read+1
    adc #0
    sta glyph+1
    lda icon_read
    sta ptr
    lda icon_read+1
    sta ptr+1
    lda quadrant
    clc
    adc #32
    tay
    lda (ptr),y
    sta ink
    jsr blit_cell
    inc quadrant
    lda quadrant
    cmp #4
    bne icon_quadrant
    rts

draw_page:
    jsr graphics_mode
    jsr clear_bitmap
    lda #$30
    sta ink
    lda #0
    sta row
    lda #2
    sta column
    lda #<title_text
    sta ptr
    lda #>title_text
    sta ptr+1
    jsr print_string
    lda #$10
    sta ink
    lda #2
    sta row
    lda #2
    sta column
    lda #<browse_text
    sta ptr
    lda #>browse_text
    sta ptr+1
    lda category_mode
    beq page_header_ready
    lda #<categories_text
    sta ptr
    lda #>categories_text
    sta ptr+1
page_header_ready:
    jsr print_string
    lda #0
    sta slot
page_icon_loop:
    lda slot
    cmp page_count
    beq page_icons_done
    jsr draw_icon
    inc slot
    jmp page_icon_loop
page_icons_done:
    jsr draw_names
    jsr draw_details
    lda #$c0
    sta ink
    lda #18
    sta row
    lda #2
    sta column
    lda #<paging_text
    sta ptr
    lda #>paging_text
    sta ptr+1
    jsr print_string
    lda #24
    sta row
    lda #1
    sta column
    lda #<controls_text
    sta ptr
    lda #>controls_text
    sta ptr+1
    jmp print_string

draw_names:
    lda #0
    sta slot
name_slot_loop:
    lda slot
    cmp page_count
    beq names_done
    jsr record_pointer
    lda #$10
    sta ink
    lda slot
    cmp selected
    bne name_color_ready
    lda #$13
    sta ink
name_color_ready:
    ldx slot
    lda slot_columns,x
    sta column
    lda slot_rows,x
    clc
    adc #2
    sta row
    lda #0
    sta name_index
name_character_loop:
    ldy name_index
    lda (ptr),y
    jsr draw_character
    inc name_index
    lda name_index
    cmp #8
    bne name_character_loop
    ldy #73
    lda (ptr),y
    and #1
    beq name_next_slot
    lda #$20
    sta ink
    lda #33                    ; exclamation marker for oversized program
    jsr draw_character
name_next_slot:
    inc slot
    jmp name_slot_loop
names_done:
    rts

draw_details:
    lda #$10
    sta ink
    lda #20
    sta row
clear_details_row:
    lda #0
    sta column
clear_details_column:
    lda #32
    jsr draw_character
    lda column
    cmp #40
    bne clear_details_column
    inc row
    lda row
    cmp #24
    bne clear_details_row
    lda page_count
    beq empty_details
    lda selected
    jsr record_pointer
    lda #20
    sta row
    lda #4
    sta column
    lda #0
    sta description_index
description_loop:
    lda description_index
    clc
    adc #8
    tay
    lda (ptr),y
    jsr draw_character
    inc description_index
    lda description_index
    cmp #32
    bne description_second_check
    inc row
    lda #4
    sta column
description_second_check:
    lda description_index
    cmp #64
    bne description_loop
    ldy #74
    lda (ptr),y
    sta number
    iny
    lda (ptr),y
    sta number+1
    ldy #73
    lda (ptr),y
    sta selected_flags
    lda #23
    sta row
    lda #4
    sta column
    lda #<bytes_text
    sta ptr
    lda #>bytes_text
    sta ptr+1
    lda category_mode
    beq details_label_ready
    lda #<items_text
    sta ptr
    lda #>items_text
    sta ptr+1
details_label_ready:
    jsr print_string
    jsr print_number
    lda selected_flags
    and #1
    beq details_done
    lda #$20
    sta ink
    lda #20
    sta column
    lda #<oversize_text
    sta ptr
    lda #>oversize_text
    sta ptr+1
    jmp print_string
empty_details:
    lda #20
    sta row
    lda #4
    sta column
    lda #<empty_text
    sta ptr
    lda #>empty_text
    sta ptr+1
    jmp print_string
details_done:
    rts
print_number:
    lda #0
    sta decimal_index
number_digit:
    ldx decimal_index
    lda divisors_lo,x
    sta divisor
    lda divisors_hi,x
    sta divisor+1
    lda #48
    sta digit
number_subtract:
    lda number+1
    cmp divisor+1
    bcc number_output
    bne number_can_subtract
    lda number
    cmp divisor
    bcc number_output
number_can_subtract:
    sec
    lda number
    sbc divisor
    sta number
    lda number+1
    sbc divisor+1
    sta number+1
    inc digit
    jmp number_subtract
number_output:
    lda digit
    jsr draw_character
    inc decimal_index
    lda decimal_index
    cmp #5
    bne number_digit
    rts

; Time is accumulated in thirds of a millisecond: PAL frame=60, NTSC=50.
; Rising raster bit 8 starts each update below the visible bitmap (line 256).
; Speed 0 swaps once per video frame; other speeds request speed*48 units.
animate:
    lda page_count
    beq animation_done
    lda $d011
    bpl animation_reset_latch
    lda frame_latch
    bne animation_done
    lda #1
    sta frame_latch
    lda #0
    sta slot
animate_slot:
    ldx slot
    lda frame_counts,x
    cmp #2
    bcc animation_next_slot
    lda slot
    jsr record_pointer
    ldy #81
    lda (ptr),y
    and #$3f
    beq animation_immediate
    sta speed
    lda #0
    sta animation_changed
    sta deadline+1
    lda speed
    asl
    rol deadline+1
    asl
    rol deadline+1
    asl
    rol deadline+1
    asl
    rol deadline+1
    sta deadline
    sta deadline_base
    lda deadline+1
    sta deadline_base+1
    asl deadline
    rol deadline+1
    clc
    lda deadline
    adc deadline_base
    sta deadline
    lda deadline+1
    adc deadline_base+1
    sta deadline+1             ; speed * 16 * 3
    ldx slot
    lda #50
    ldy $02a6
    beq animation_tick_size
    lda #60
animation_tick_size:
    clc
    adc elapsed_lo,x
    sta elapsed_lo,x
    lda elapsed_hi,x
    adc #0
    sta elapsed_hi,x
animation_check_deadline:
    ldx slot
    lda elapsed_hi,x
    cmp deadline+1
    bcc animation_maybe_draw
    bne animation_deadline_reached
    lda elapsed_lo,x
    cmp deadline
    bcc animation_maybe_draw
animation_deadline_reached:
    sec
    lda elapsed_lo,x
    sbc deadline
    sta elapsed_lo,x
    lda elapsed_hi,x
    sbc deadline+1
    sta elapsed_hi,x
    jsr bump_icon_frame
    lda #1
    sta animation_changed
    jmp animation_check_deadline
animation_maybe_draw:
    lda animation_changed
    beq animation_next_slot
    jsr draw_icon
    jmp animation_next_slot
animation_immediate:
    jsr bump_icon_frame
    jsr draw_icon
animation_next_slot:
    inc slot
    lda slot
    cmp page_count
    bcc animate_slot
animation_done:
    rts
animation_reset_latch:
    lda #0
    sta frame_latch
    rts
bump_icon_frame:
    ldx slot
    inc current_frames,x
    lda current_frames,x
    cmp frame_counts,x
    bcc animation_frame_ready
    lda #0
    sta current_frames,x
animation_frame_ready:
    rts

; Generic graphics services for small demos. Back buffer alternates $6000/$a000.
; The $a000 pack has already been copied to GAME before any graphics call.
bitmap_begin:
    jsr graphics_mode
    jsr clear_bitmap
    lda #$a0
    sta bitmap_back_hi
    lda #$c0
    sta bitmap_address_xor
    lda #0
    sta bitmap_frame_count
    lda #$30                    ; cyan on black, mirrored color matrices
    ldx #0
bitmap_colors:
.for i in range(4)
    sta $4000+i*$100,x
    sta $8000+i*$100,x
.endfor
    inx
    bne bitmap_colors
    rts
bitmap_new_frame:
    lda bitmap_back_hi
    cmp #$60
    beq clear_bitmap_pixels
    lda #0
    ldx #0
bitmap_clear_hidden:
.for i in range(32)
    sta $a000+i*$100,x
.endfor
    inx
    bne bitmap_clear_hidden
    rts
bitmap_flip:
flip_wait_low:
    bit $d011
    bmi flip_wait_low
flip_wait_high:
    bit $d011
    bpl flip_wait_high
    lda $dd00
    and #$fc
    ldx bitmap_back_hi
    cpx #$a0
    bne flip_bank_one
    ora #1                      ; VIC bank $8000: colors $8000, bitmap $a000
    bne flip_bank_ready
flip_bank_one:
    ora #2                      ; VIC bank $4000: colors $4000, bitmap $6000
flip_bank_ready:
    sta $dd00
    lda bitmap_back_hi
    eor #$c0
    sta bitmap_back_hi
    lda bitmap_address_xor
    eor #$c0
    sta bitmap_address_xor
    inc bitmap_frame_count
    rts

; 8-bit endpoint coordinates: X 0..255, Y 0..199; preserves $02-$05.
bitmap_line:
    lda $07
    cmp #200
    bcs line_done
    lda $09
    cmp #200
    bcs line_done
    lda #1
    sta line_sx
    sta line_sy
    sec
    lda $08
    sbc $06
    bcs line_x_positive
    eor #$ff
    clc
    adc #1
    ldx #$ff
    stx line_sx
line_x_positive:
    sta line_dx
    sec
    lda $09
    sbc $07
    bcs line_y_positive
    eor #$ff
    clc
    adc #1
    ldx #$ff
    stx line_sy
line_y_positive:
    sta line_dy
    sec
    lda line_dx
    sbc line_dy
    sta line_error
    lda #0
    sbc #0
    sta line_error+1
line_loop:
    jsr bitmap_pixel
    lda $06
    cmp $08
    bne line_not_done
    lda $07
    cmp $09
    beq line_done
line_not_done:
    lda line_error
    asl
    sta line_twice
    lda line_error+1
    rol
    sta line_twice+1
    ; Compare signed e2 with -dy, by subtracting sixteen-bit -dy.
    clc
    lda line_twice
    adc line_dy
    sta line_compare
    lda line_twice+1
    adc #0
    bmi line_skip_x
    ora line_compare
    beq line_skip_x             ; use strict e2 > -dy
    sec
    lda line_error
    sbc line_dy
    sta line_error
    lda line_error+1
    sbc #0
    sta line_error+1
    clc
    lda $06
    adc line_sx
    sta $06
line_skip_x:
    ; Compare signed e2 with dx, again using a sixteen-bit subtraction.
    sec
    lda line_twice
    sbc line_dx
    lda line_twice+1
    sbc #0
    bpl line_loop              ; use strict e2 < dx
    clc
    lda line_error
    adc line_dx
    sta line_error
    lda line_error+1
    adc #0
    sta line_error+1
    clc
    lda $07
    adc line_sy
    sta $07
    jmp line_loop
line_done:
    rts
bitmap_pixel:
    lda $07
    lsr
    lsr
    lsr
    tax
    lda bitmap_rows_lo,x
    sta dst
    lda bitmap_rows_hi,x
    eor bitmap_address_xor
    sta dst+1
    lda $06
    and #$f8
    clc
    adc dst
    sta dst
    bcc pixel_no_carry
    inc dst+1
pixel_no_carry:
    lda $07
    and #7
    tay
    lda $06
    and #7
    tax
    lda (dst),y
    ora pixel_masks,x
    sta (dst),y
    rts
pixel_masks: .byte $80,$40,$20,$10,8,4,2,1
bitmap_back_hi: .byte $a0
bitmap_address_xor: .byte $c0
bitmap_frame_count: .byte 0
line_dx: .byte 0
line_dy: .byte 0
line_sx: .byte 1
line_sy: .byte 1
line_error: .word 0
line_twice: .word 0
line_compare: .byte 0

run_program:
    ldy #74
    lda (ptr),y
    sta game_length
    iny
    lda (ptr),y
    sta game_length+1
    iny
    lda (ptr),y
    jsr pack_filename_number
    lda selected
    jsr record_pointer
    ldy #77
    lda (ptr),y
    sta game_offset
    iny
    lda (ptr),y
    cmp #$20
    bcs disk_error
    sta game_offset+1
    lda #8
    ldx #<pack_name
    ldy #>pack_name
    jsr SETNAM
    lda #1
    ldx #8
    ldy #0
    jsr SETLFS
    lda #0
    ldx #<PACK
    ldy #>PACK
    jsr LOAD
    bcs disk_error
    ; Validate the selected range against LOAD's returned end address X/Y.
    stx pack_end
    sty pack_end+1
    clc
    lda game_offset
    adc #<PACK
    sta ptr
    lda game_offset+1
    adc #>PACK
    sta ptr+1
    clc
    lda ptr
    adc game_length
    sta game_end
    lda ptr+1
    adc game_length+1
    sta game_end+1
    cmp pack_end+1
    bcc copy_game_setup
    bne disk_error
    lda game_end
    cmp pack_end
    bcc copy_game_setup
    bne disk_error
copy_game_setup:
    lda game_length
    ora game_length+1
    beq disk_error
    lda game_length+1
    cmp #$10
    bcc game_length_valid
    bne disk_error
    lda game_length
    bne disk_error
game_length_valid:
    lda #<GAME
    sta dst
    lda #>GAME
    sta dst+1
    ldy #0
copy_game:
    lda (ptr),y
    sta (dst),y
    inc ptr
    bne game_source_ready
    inc ptr+1
game_source_ready:
    inc dst
    bne game_dest_ready
    inc dst+1
game_dest_ready:
    lda game_length
    bne game_length_decrement
    dec game_length+1
game_length_decrement:
    dec game_length
    lda game_length
    ora game_length+1
    bne copy_game
    jsr text_mode
    jsr clear_text
    tsx
    stx game_stack
    jsr GAME
return_from_game:
    ldx game_stack
    txs
    cld
    lda #$36
    sta $01
    jsr text_mode
    lda #0
    sta $d015
    sta $d418
    jsr release_game_keys
    jsr graphics_mode
    lda #0
    sta frame_latch
    jsr draw_page
    jmp main_loop
release_game_keys:
    jsr STOP
    beq release_game_keys
    jsr GETIN
    bne release_game_keys
    rts
wait_key:
    jsr poll_key
    beq wait_key
    rts
poll_key:
    jsr STOP
    beq abort_game
    jmp GETIN
abort_game:
    jmp return_from_game
random_byte:
    lda random_state
    asl
    bcc random_no_feedback
    eor #$1d
random_no_feedback:
    eor $a2
    bne random_nonzero
    lda #$a7
random_nonzero:
    sta random_state
    rts
pack_filename_number:
    ldx #48
pack_hundreds:
    cmp #100
    bcc pack_tens_setup
    sec
    sbc #100
    inx
    bne pack_hundreds
pack_tens_setup:
    stx pack_name+1
    ldx #48
pack_tens:
    cmp #10
    bcc pack_units
    sec
    sbc #10
    inx
    bne pack_tens
pack_units:
    stx pack_name+2
    clc
    adc #48
    sta pack_name+3
    rts

disk_error:
    jsr CLRCHN
    lda #2
    jsr CLOSE
    jsr text_mode
    jsr clear_text
    ldx #0
print_disk_error:
    lda error_text,x
    beq disk_error_halt
    jsr $ffd2
    inx
    bne print_disk_error
disk_error_halt:
    jmp disk_error_halt

index_magic: .text "S256"
.byte 1,96
icons_magic: .text "SICO"
.byte 1,36
index_name: .text "INDEX.DAT,S,R"
cats_name: .text "CATS.DAT,S,R"
icons_name: .text "ICONS.DAT,S,R"
pack_name: .text "P000.DAT"
title_text: .text "SECTOR 256  ONE BLOCK. MANY WORLDS."
.byte 0
categories_text: .text "CHOOSE A CATEGORY"
.byte 0
browse_text: .text "CHOOSE A PROGRAM"
.byte 0
paging_text: .text "F1 PREV F3 NEXT F5 HOME  A-Z JUMP"
.byte 0
controls_text: .text "CURSORS MOVE  RETURN OPEN  STOP BACK"
.byte 0
bytes_text: .text "BYTES: "
.byte 0
items_text: .text "ITEMS: "
.byte 0
oversize_text: .text "! OVER 256"
.byte 0
empty_text: .text "EMPTY CATEGORY. F5 RETURNS HOME."
.byte 0
error_text: .text "DISK/CATALOG ERROR. RESET AND RELOAD."
.byte 13,0
slot_columns: .byte 1,11,21,31,1,11,21,31,1,11,21,31
slot_rows: .byte 4,4,4,4,9,9,9,9,14,14,14,14
bitmap_rows_lo: .byte <(BITMAP+range(25)*320)
bitmap_rows_hi: .byte >(BITMAP+range(25)*320)
color_rows_lo: .byte <(SCREEN+range(25)*40)
color_rows_hi: .byte >(SCREEN+range(25)*40)
divisors_lo: .byte <[10000,1000,100,10,1]
divisors_hi: .byte >[10000,1000,100,10,1]
header: .fill 8
records_left: .word 0
category_mode: .byte 1
category_id: .byte 0
selected: .byte 0
page_count: .byte 0
has_next: .byte 0
page_skip: .word 0
matched: .word 0
jump_letter: .byte 0
slot: .byte 0
frames_left: .byte 0
stream_frame: .word 0
icon_total: .word 0
wanted_frame: .word 0
icon_write: .word ICONRAM
icon_read: .word ICONRAM
quadrant: .byte 0
row: .byte 0
column: .byte 0
ink: .byte $10
text_index: .byte 0
name_index: .byte 0
description_index: .byte 0
number: .word 0
divisor: .word 0
digit: .byte 0
decimal_index: .byte 0
selected_flags: .byte 0
frame_latch: .byte 0
animation_changed: .byte 0
speed: .byte 0
deadline: .word 0
deadline_base: .word 0
frame_counts: .fill 12
current_frames: .fill 12
elapsed_lo: .fill 12
elapsed_hi: .fill 12
icon_offsets_lo: .fill 12
icon_offsets_hi: .fill 12
game_length: .word 0
game_offset: .word 0
game_end: .word 0
pack_end: .word 0
game_stack: .byte 0
random_state: .byte $a7
.cerror * > $4000, "Launcher overlaps graphics RAM"

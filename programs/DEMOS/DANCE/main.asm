; DANCE: a tiny 1980s-style vector disco loop for the C64.
; The lady's dress and head stay in place while arms and feet strike four poses.
.include "api.inc"
.cpu "6502"
* = $c000
pose = $02
edge = $03
beat = $04
points = $c200

    jsr HIRES
    lda #0
    sta pose
    sta beat
frame:
    jsr POLLKEY
    jsr NEWFRAME
    ldx #29
copy_body:
    lda body,x
    sta points,x
    dex
    bpl copy_body
    ldx pose
    ldy offsets,x
    ldx #0
copy_pose:
    lda moves,y
    sta points+30,x
    iny
    inx
    cpx #12
    bne copy_pose
    lda #0
    sta edge
draw:
    ldx edge
    ldy links,x
    lda points,y
    sta LINE_X0
    lda points+1,y
    sta LINE_Y0
    inx
    ldy links,x
    lda points,y
    sta LINE_X1
    lda points+1,y
    sta LINE_Y1
    jsr LINE
    inc edge
    inc edge
    lda edge
    cmp #50
    bne draw
    jsr FLIP
    inc beat
    lda beat
    cmp #5
    bne frame
    lda #0
    sta beat
    inc pose
    lda pose
    and #3
    sta pose
    jmp frame

; Fixed points 0-14: hair/head, shoulders, fitted waist, flared skirt, knees.
body:
.byte 128,33, 116,42, 118,59, 128,66, 138,59, 140,42
.byte 128,68, 107,79, 149,79, 117,111, 139,111
.byte 101,146, 155,146, 113,162, 143,162
; Moving points 15-20: left elbow/hand, right elbow/hand, left/right shoe.
offsets: .byte 0,12,24,36
moves:
.byte 91,99, 78,75, 164,97, 178,74, 101,184, 157,183
.byte 98,69, 82,49, 158,68, 174,51, 119,185, 164,179
.byte 92,100, 77,75, 163,67, 178,48, 96,178, 152,186
.byte 98,68, 83,48, 166,98, 179,77, 110,185, 159,183
; Links use byte offsets into the interleaved point array.
links:
.byte 0,2, 2,4, 4,6, 6,8, 8,10, 10,0, 2,10
.byte 6,12, 12,14, 12,16, 14,16, 14,18, 16,20, 18,20
.byte 18,22, 20,24, 22,24
.byte 14,30, 30,32, 16,34, 34,36
.byte 22,26, 26,38, 24,28, 28,40

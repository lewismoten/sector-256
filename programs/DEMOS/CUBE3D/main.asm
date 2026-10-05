; Sector 256: a real orthographic 3D cube rotating about its vertical axis.
; Eight projected vertices, twelve edges, integer sine/cosine, double buffering.
; Shared launcher routines draw pixels/lines; all cube geometry lives here.
.include "api.inc"
.cpu "6502"
* = $c000
phase = $02
u = $03
v = $04
edge = $05
vx = $c200
vy = $c208
    jsr HIRES
    lda #0
    sta phase
frame:
    jsr POLLKEY                 ; RUN/STOP returns to the same launcher page
    jsr NEWFRAME                ; clear only the hidden bitmap
    lda phase
    and #63
    tax
    lda sine,x
    sta u
    txa
    clc
    adc #16
    and #63
    tax
    lda sine,x                  ; cos(a) = sin(a + pi/2)
    sec
    sbc u
    sta v                       ; rotated depth diagonal: cos - sin
    lda sine,x
    clc
    adc u
    sta u                       ; rotated horizontal diagonal: cos + sin
    ldx #0
vertices:
    lda u
    clc
    adc #160
    sta vx,x
    sta vx+4,x
    lda v
    cmp #$80
    ror                         ; signed divide by two: fixed camera tilt
    clc
    adc #68
    sta vy,x
    clc
    adc #64
    sta vy+4,x
    lda u
    pha
    lda v
    sta u
    pla
    eor #$ff
    clc
    adc #1
    sta v                       ; next corner: (u,v) -> (v,-u)
    inx
    cpx #4
    bne vertices
    lda #0
    sta edge
edges_loop:
    ldx edge
    ldy edges,x
    lda vx,y
    sta LINE_X0
    lda vy,y
    sta LINE_Y0
    inx
    ldy edges,x
    lda vx,y
    sta LINE_X1
    lda vy,y
    sta LINE_Y1
    jsr LINE
    inc edge
    inc edge
    lda edge
    cmp #24
    bne edges_loop
    jsr FLIP
    inc phase
    jmp frame
edges:
.byte 0,1,1,2,2,3,3,0,4,5,5,6,6,7,7,4,0,4,1,5,2,6,3,7
sine:
.char 0,3,6,9,12,15,18,20,23,25,27,28,30,31,31,32
.char 32,32,31,31,30,28,27,25,23,20,18,15,12,9,6,3
.char 0,-3,-6,-9,-12,-15,-18,-20,-23,-25,-27,-28,-30,-31,-31,-32
.char -32,-32,-31,-31,-30,-28,-27,-25,-23,-20,-18,-15,-12,-9,-6,-3

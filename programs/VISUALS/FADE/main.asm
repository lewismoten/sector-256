; Cycle the VIC border and background through a soft palette ramp.
.include "api.inc"
.cpu "6502"
*=$c000
p=$02
loop:
 ldx p
 lda shades,x
 sta $d021
 eor #$0f
 sta $d020
 inc p
 lda p
 cmp #32
 bcc keys
 lda #0
 sta p
keys:
 jsr POLLKEY
 jmp loop
shades:.byte 0,11,12,15,1,15,12,11,0,6,14,3,1,3,14,6,0,9,8,7,1,7,8,9,0,4,10,2,1,2,10,4

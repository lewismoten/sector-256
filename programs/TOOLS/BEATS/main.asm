; Two close SID frequencies make audible amplitude beats.
.include "api.inc"
.cpu "6502"
*=$c000
p=$20
 lda #15
 sta $d418
 lda #>t
 sta p+1
r:jsr CLEAR
 ldx #<t
 stx p
 jsr z
 lda #$00
 sta $d400
 lda #20
 sta $d401
 lda #$20
 sta $d407
 lda #20
 sta $d408
 lda #17
 sta $d404
 sta $d40b
 jsr WAITKEY
 lda #0
 sta $d404
 sta $d40b
 jmp r
z:ldy #0
l:lda (p),y
 beq e
 jsr PUTCHAR
 iny
 bne l
e:rts
t:.text "SID BEATS",13,"TWO CLOSE PITCHES",13,"KEY=REPEAT",13,0

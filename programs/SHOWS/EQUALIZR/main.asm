; Random-height character bars like an audio equalizer.
.include "api.inc"
.cpu "6502"
*=$c000
c=$02
h=$03
r0=$04
p=$20
 lda #>t
 sta p+1
r:jsr CLEAR
 ldx #<t
 stx p
 jsr z
 lda #0
 sta c
n:jsr RANDOM
 and #15
 sta h
 lda #24
 sta r0
b:lda h
 beq e
 ldx r0
 ldy c
 clc
 jsr PLOT
 lda #42
 jsr PUTCHAR
 dec r0
 dec h
 bne b
e:inc c
 lda c
 cmp #40
 bne n
 jsr WAITKEY
 jmp r
z:ldy #0
q:lda (p),y
 beq d
 jsr PUTCHAR
 iny
 bne q
d:rts
t:.text "RANDOM EQUALIZER",13,0

; Randomly lit windows in a tiny PETSCII skyline.
.include "api.inc"
.cpu "6502"
*=$c000
 lda #>sky
 sta $21
loop:
 jsr CLEAR
 ldx #<sky
 stx $20
 jsr text
 ldx #32
lights:
 jsr RANDOM
 and #1
 beq dark
 lda #'*'
 bne put
dark:lda #'.'
put:jsr PUTCHAR
 dex
 bne lights
 jsr WAITKEY
 jmp loop
text:
 stx $20
 ldy #0
next:lda ($20),y
 beq done
 jsr PUTCHAR
 iny
 bne next
done:rts
sky:.text "CITY LIGHTS",13,13,"  |  |  |  |",13,"  |  |  |  |",13,13,"WINDOWS:",13,0

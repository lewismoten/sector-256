; Verify 3 x 5 x 17 x 257 with compact 16-bit repeated addition.
.include "api.inc"
.cpu "6502"
*=$c000
n=$20
base=$22
p=$24

    lda #0
    sta n
    sta n+1
    ldx #5
by3:clc
    lda n
    adc #3
    sta n
    bcc b3ok
    inc n+1
b3ok:dex
    bne by3
    lda n
    sta base
    lda #0
    sta n
    sta n+1
    ldx #17
by17:clc
    lda n
    adc base
    sta n
    bcc b17ok
    inc n+1
b17ok:dex
    bne by17
    lda n
    sta base
    lda n+1
    sta base+1
    lda #0
    sta n
    sta n+1
    ldx #0
by257:clc
    lda n
    adc base
    sta n
    lda n+1
    adc base+1
    sta n+1
    dex
    bne by257
    clc
    lda n
    adc base
    sta n
    lda n+1
    adc base+1
    sta n+1
    jsr CLEAR
    lda #<text
    sta p
    lda #>text
    sta p+1
    ldy #0
loop:lda (p),y
    beq done
    jsr PUTCHAR
    iny
    bne loop
done:jsr WAITKEY
    jmp done
text:.text "16-BIT FACTOR DEMO",13,13,"65535 = 3 X 5 X 17 X 257",13,13,"ALL FACTORS ARE PRIME.",13,0

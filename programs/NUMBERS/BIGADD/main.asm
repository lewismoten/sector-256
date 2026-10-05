; Add two fixed 40-digit decimal values from right to left.
.include "api.inc"
.cpu "6502"
*=$c000
p=$20
out=$0300

    ldx #39
    clc
add:lda left,x
    adc right,x
    sec
    sbc #$30
    cmp #$3a
    bcc plain
    sbc #10
    sta out+1,x
    sec
    bcs next
plain:sta out+1,x
    clc
next:dex
    bpl add
    lda #$30
    adc #0
    sta out
    jsr CLEAR
    ldx #<title
    ldy #>title
    jsr putz
    ldx #<left
    ldy #>left
    jsr put40
    lda #13
    jsr PUTCHAR
    lda #$2b
    jsr PUTCHAR
    ldx #<right
    ldy #>right
    jsr put40
    lda #13
    jsr PUTCHAR
    lda #$3d
    jsr PUTCHAR
    ldx #<out
    ldy #>out
    jsr put41
wait:jsr WAITKEY
    jmp wait

putz:stx p
    sty p+1
    ldy #0
z:  lda (p),y
    beq zd
    jsr PUTCHAR
    iny
    bne z
zd: rts
put40:stx p
    sty p+1
    ldy #0
p40:lda (p),y
    jsr PUTCHAR
    iny
    cpy #40
    bne p40
    rts
put41:stx p
    sty p+1
    ldy #0
p41:lda (p),y
    jsr PUTCHAR
    iny
    cpy #41
    bne p41
    rts

title:.text "40-DIGIT ADD",13,0
left: .text "1234567890123456789012345678901234567890"
right:.text "1111111111111111111111111111111111111111"

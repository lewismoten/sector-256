; Time SPACE to drop the moving block onto the stack.
.include "api.inc"
.cpu "6502"
* = $c000
width = $02
x = $03
base = $04
level = $05
dir = $20
row = $21
spot = $23
char = $25
text = $26

restart:
    jsr CLEAR
    lda #10
    sta width
    lda #15
    sta base
    lda #8
    sta level
    lda #1
    sta dir
    lda #<$0720
    sta row
    lda #>$0720
    sta row+1
    lda #0
    sta x
    jmp draw

frame:
wait:
    lda $d012
    bne wait
    lda #32
    jsr paint
    jsr POLLKEY
    cmp #32
    beq drop
    clc
    lda x
    adc dir
    sta x
    cmp #31
    bcc draw
    lda dir
    eor #$fe
    sta dir
    clc
    lda x
    adc dir
    sta x
draw:
    lda #160
    jsr paint
    jmp frame

drop:
    lda x
    cmp base
    bcc left
    sec
    sbc base
    cmp width
    bcs lose
    sta spot
    lda width
    sec
    sbc spot
    sta width
    lda x
    sta base
    jmp land
left:
    lda base
    sec
    sbc x
    cmp width
    bcs lose
    sta spot
    lda width
    sec
    sbc spot
    sta width
land:
    lda base
    sta x
    lda #160
    jsr paint
    dec level
    beq win
    sec
    lda row
    sbc #40
    sta row
    lda row+1
    sbc #0
    sta row+1
    lda #0
    sta x
    lda #1
    sta dir
    jmp frame

win:
    ldx #<won
    bne message
lose:
    ldx #<lost
message:
    lda #>won
    sta text+1
    jsr CLEAR
    jsr print
again:
    jsr WAITKEY
    cmp #13
    bne again
    jmp restart

paint:
    sta char
    clc
    lda row
    adc x
    sta spot
    lda row+1
    adc #0
    sta spot+1
    ldy #0
stroke:
    lda char
    sta (spot),y
    iny
    cpy width
    bne stroke
    rts

print:
    stx text
    ldy #0
next:
    lda (text),y
    beq done
    jsr PUTCHAR
    iny
    bne next
done:
    rts

won: .text "WIN",0
lost: .text "MISS",0

; A tiny one-crate warehouse: push the crate right onto the X.
.include "api.inc"
.cpu "6502"
* = $c000
player = $02
crate = $03
text_ptr = $20

    lda #>title
    sta text_ptr+1
round:
    lda #0
    sta player
    lda #2
    sta crate
draw:
    jsr CLEAR
    ldx #<title
    jsr print
    ldy #0
board:
    tya
    cmp player
    beq hero
    cmp crate
    beq box
    cpy #4
    beq target
    lda #46
    bne put
hero: lda #64
    bne put
box: lda #36
    bne put
target: lda #88
put: jsr PUTCHAR
    iny
    cpy #5
    bne board
    lda #13
    jsr PUTCHAR
    ldx #<prompt
    jsr print
key:
    jsr WAITKEY
    cmp #65
    beq left
    cmp #68
    bne key
right:
    lda player
    cmp #4
    beq draw
    inc player
    lda player
    cmp crate
    bne draw
    inc crate
    lda crate
    cmp #4
    bne draw
    jmp won
left:
    lda player
    beq draw
    dec player
    lda player
    cmp crate
    bne draw
    inc player
    jmp draw
won:
    jsr CLEAR
    ldx #<win
    jsr print
again:
    jsr WAITKEY
    cmp #13
    bne again
    jmp round

print:
    stx text_ptr
    ldy #0
loop:
    lda (text_ptr),y
    beq done
    jsr PUTCHAR
    iny
    bne loop
done: rts

title: .text "BOX PUSH: @ PUSH $ TO X",13
.byte 0
prompt: .text "A/D MOVE",13
.byte 0
win: .text "BOX ON TARGET! RETURN=NEW",13
.byte 0

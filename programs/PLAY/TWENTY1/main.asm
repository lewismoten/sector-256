; Take 1-3. The CPU also takes 1-3; whoever reaches 21 loses.
.include "api.inc"
.cpu "6502"
* = $c000
total = $02
text = $20

    lda #>title
    sta text+1
round:
    lda #0
    sta total
turn:
    jsr CLEAR
    ldx #<title
    jsr print
pick:
    jsr WAITKEY
    cmp #49
    bcc pick
    cmp #52
    bcs pick
    sec
    sbc #48
    clc
    adc total
    sta total
    cmp #21
    bcs lose
    clc
    adc #48
    sta player_total
    ldx #<player
    jsr print
    jsr RANDOM
    and #3
    bne cpu_take
    lda #1
cpu_take:
    clc
    adc total
    sta total
    cmp #21
    bcs win
    clc
    adc #48
    sta cpu_total
    ldx #<cpu
    jsr print
    jmp pick
lose:
    ldx #<lost
    bne result
win:
    ldx #<won
result:
    jsr print
again:
    jsr WAITKEY
    cmp #13
    bne again
    jmp round

print:
    stx text
    ldy #0
loop:
    lda (text),y
    beq done
    jsr PUTCHAR
    iny
    bne loop
done:
    rts

title: .text "COUNT TO 21",13,"1-3 THEN CPU",13,0
player: .text "YOU: "
player_total: .byte 48
.byte 13,0
cpu: .text "CPU: "
cpu_total: .byte 48
.byte 13,0
won: .text "CPU SAID 21! RETURN=NEW",13,0
lost: .text "YOU SAID 21! RETURN=NEW",13,0

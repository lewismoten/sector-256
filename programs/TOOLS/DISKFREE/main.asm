; Show the number of free blocks reported by the drive 8 directory.
.include "api.inc"
.cpu "6502"
*=$c000
lo=$20
hi=$21
p=$22

again:
 jsr CLEAR
 lda #1
 ldx #<name
 ldy #>name
 jsr $ffbd
 lda #2
 ldx #8
 ldy #0
 jsr $ffba
 jsr $ffc0
 lda #2
 jsr $ffc6
 jsr $ffcf
 jsr $ffcf
next:
 jsr $ffcf
 sta p
 jsr $ffcf
 ora p
 beq last
 jsr $ffcf
 jsr $ffcf
skip:
 jsr $ffcf
 bne skip
 jmp next
last:
 jsr $ffcf
 sta lo
 jsr $ffcf
 sta hi
 jsr $ffcc
 lda #2
 jsr $ffc3
 lda #>title
 sta p+1
 ldx #<title
 jsr text
 ldx #0
hundreds:
 lda hi
 bne sub100
 lda lo
 cmp #100
 bcc tens
sub100:
 sec
 lda lo
 sbc #100
 sta lo
 lda hi
 sbc #0
 sta hi
 inx
 bne hundreds
tens:
 cpx #0
 beq count10
 txa
 clc
 adc #'0'
 jsr PUTCHAR
count10:
 ldx #0
sub10:
 lda lo
 cmp #10
 bcc ones
 sbc #10
 sta lo
 inx
 bne sub10
ones:
 cpx #0
 beq printone
 txa
 clc
 adc #'0'
 jsr PUTCHAR
printone:
 lda lo
 clc
 adc #'0'
 jsr PUTCHAR
 jsr WAITKEY
 jmp again
text:
 stx p
 ldy #0
out:
 lda (p),y
 beq done
 jsr PUTCHAR
 iny
 bne out
done:
 rts
name:.text "$"
title:.text "DEVICE 8",13,13,"FREE BLOCKS: ",0

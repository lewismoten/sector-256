; Live hex display of two visible VIC-II color registers.
.include "api.inc"
.cpu "6502"
*=$c000
p=$20
 lda #>t
 sta p+1
r:jsr CLEAR
 lda $d020
 and #15
 tax
 lda x,x
 sta border
 lda $d021
 and #15
 tax
 lda x,x
 sta background
 ldx #<t
 stx p
 jsr z
 jsr WAITKEY
 jmp r
z:ldy #0
q:lda (p),y
 beq e
 jsr PUTCHAR
 iny
 bne q
e:rts
t:.text "VIC-II COLOR REGISTERS",13,"BORDER $"
border:.byte 48
 .text 13,"BACKGROUND $"
background:.byte 48,0
x:.text "0123456789ABCDEF"

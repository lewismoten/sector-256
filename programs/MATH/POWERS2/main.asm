; Powers of two through the unsigned 16-bit range.
.include "api.inc"
.cpu "6502"
*=$c000
p=$20
 lda #>s
 sta p+1
r:jsr CLEAR
 ldx #<s
 stx p
 ldy #0
l:lda (p),y
 beq k
 jsr PUTCHAR
 iny
 bne l
k:jsr WAITKEY
 jmp r
s:.text "POWERS OF TWO",13,13
 .text "2^0 = 1     2^1 = 2",13
 .text "2^2 = 4     2^3 = 8",13
 .text "2^4 = 16    2^5 = 32",13
 .text "2^6 = 64    2^7 = 128",13
 .text "2^8 = 256   2^9 = 512",13
 .text "2^10 = 1024 2^11 = 2048",13
 .text "2^12 = 4096 2^13 = 8192",13
 .text "2^14 = 16384 2^15 = 32768",13,0

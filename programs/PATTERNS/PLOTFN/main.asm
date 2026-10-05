; Select a low or high frequency character sine curve.
.include "api.inc"
.cpu "6502"
*=$c000
p=$20
m=$02
 lda #1
 sta m
r:jsr CLEAR
 lda #<h
 sta p
 lda #>h
 sta p+1
 jsr o
 lda m
 cmp #1
 beq low
 lda #<high
 bne setlo
low:lda #<lowtxt
setlo:sta p
 lda m
 cmp #1
 beq sethi
 lda #>high
 bne storehi
sethi:lda #>lowtxt
storehi:sta p+1
 jsr o
k:jsr WAITKEY
 cmp #49
 beq q
 cmp #50
 bne k
 lda #2
 bne s
q:lda #1
s:sta m
 jmp r
o:ldy #0
n:lda (p),y
 beq z
 jsr PUTCHAR
 iny
 bne n
z:rts
h:.text "SINE PLOT 1/2",13,13,0
lowtxt:.text "LOW",13,"    **     **",13,"  **  ** **  **",13,"**      *      **",13,0
high:.text "HIGH",13," ** ** ** **",13,"* ** ** ** **",13," ** ** ** **",13,"* ** ** ** **",13,0

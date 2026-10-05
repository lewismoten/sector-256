; List all twenty-four arrangements of the letters A through D.
.include "api.inc"
.cpu "6502"
*=$c000
p=$20
 lda #>t
 sta p+1
 jsr CLEAR
 ldx #<t
 stx p
 ldy #0
l:lda (p),y
 beq d
 jsr PUTCHAR
 iny
 bne l
d:jsr WAITKEY
 jmp d
t:.text "ABCD PERMUTATIONS",13,13,"ABCD ABDC ACBD ACDB",13,"ADBC ADCB BACD BADC",13,"BCAD BCDA BDAC BDCA",13,"CABD CADB CBAD CBDA",13,"CDAB CDBA DABC DACB",13,"DBAC DBCA DCAB DCBA",13,0

; Prime positions for a centered 11 by 11 Ulam spiral (1 through 121).
.include "api.inc"
.cpu "6502"
*=$c000
p=$20
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
text:.text "ULAM PRIME SPIRAL 1-121",13
 .text "*...*......",13
 .text ".....*.*...",13
 .text "*.*.....*.*",13
 .text ".*.*...*...",13
 .text "....*.*.*..",13
 .text "...*..**.*.",13
 .text "*.*.*......",13
 .text ".*...*.....",13
 .text "*.*...*...*",13
 .text ".*.....*...",13
 .text "..*........",0

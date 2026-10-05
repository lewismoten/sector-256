; Wait for GO, then hit a key.
.include "api.inc"
.cpu "6502"
*=$c000
again:
 jsr CLEAR
 lda #>wait
 sta $21
 ldx #<wait
 jsr text
 jsr RANDOM
 ora #$40
 tax
delay:dex
 bne delay
 jsr CLEAR
 lda #>go
 sta $21
 ldx #<go
 jsr text
 jsr WAITKEY
 lda #>fast
 sta $21
 ldx #<fast
 jsr text
 jsr WAITKEY
 jmp again
text:
 stx $20
 ldy #0
next:lda ($20),y
 beq done
 jsr PUTCHAR
 iny
 bne next
done:rts
wait:.text "REACTION",13,13,"WAIT...",0
go:.text "REACTION",13,13,"GO! HIT A KEY!",0
fast:.text "NICE REACTION!",13,13,"KEY=AGAIN",0

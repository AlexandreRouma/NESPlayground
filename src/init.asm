.segment "ZEROPAGE" ; Just first page
.segment "STARTUP"
.include "ppu.inc"
.include "res.inc"
.include "main.inc"

reset:
    sei ; Disable interrupts
    cld ; Disable decimal mode
    
    ; Disable sound
    ldx #$40
    stx $4017

    ; Setup the stack
    ldx #$FF
    txs 

    inx ; Set x to 0

    ; Clear PPU registers
    stx $2000
    stx $2001

    ; Disable PCM
    stx $4010

    ; Wait for a VBlank
:
    bit $2002
    bpl :-

    ; Clear RAM
clear_ram:
    ; Clear normal RAM
    lda #$00
    sta $0000, x
    sta $0100, x
    sta $0400, x
    sta $0500, x
    sta $0600, x
    sta $0700, x

    ; Clear sprite RAM
    lda #$FF
    sta $0200, x

    inx 
    bne clear_ram

    ; Wait for a VBlank
:
    bit $2002
    bpl :-

    ; Tell PPU where the sprite memory is
    lda #$02
    jsr ppu_set_sprite_ram

    ; Load sprites
    ldx #$00
load_sprites:
    lda sprite_dat, x
    sta $0200, x
    inx 
    cpx #$10
    bne load_sprites

    jsr ppu_load_palette

;     ; Load background
;     lda #$3F
;     sta $2006
;     lda #$00
;     sta $2006

;     ldx #$00
;     stx $0003
; load_bg:
;     lda 
;     sta $2007
;     inx 
;     cpx #$00
;     beq load_bg_inc
;     cpx #$84
;     bne load_bg
;     ldy $0003
;     cpy #$03
;     bne load_bg
;     jmp load_bg_end
; load_bg_inc:
;     ldy $0003
;     iny 
;     sty $0003
;     jmp load_bg

; load_bg_end:



    ; Enable interrupts
    cli 

    ; Enable NMI
    lda #%10010000
    sta $2000
    ; Enable sprites and background
    lda #%00011110
    sta $2001

    jmp main_init

sprite_dat:
    .byte $10, $00, $01, $08
    .byte $10, $01, $01, $10
    .byte $18, $10, $01, $08
    .byte $18, $11, $01, $10

.segment "VECTORS"
.word main_nmi
.word reset
.word $0000
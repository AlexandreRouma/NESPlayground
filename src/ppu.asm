.include "res.inc"

.export ppu_load_palette
ppu_load_palette:
    ; Reset address register
    bit $2007

    ; Load start address
    lda #$3F
    sta $2006
    lda #$00
    sta $2006

    ; Clear X to use as counter
    ldx #$00
    
ppu_load_palette_loop:
    ; Read palette byte and write to PPU
    lda res_palette, x
    sta $2007

    ; Increment and check if end of palette
    inx 
    cpx #$20
    bne ppu_load_palette_loop

    rts 

.export ppu_set_sprite_ram
ppu_set_sprite_ram:
    sta $4014
    nop 
    rts 
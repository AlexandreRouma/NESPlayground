.include "ppu.inc"

.export main_init
main_init:
    jmp main_init

.export main_nmi
main_nmi:
    ; If ball is past x high limit, reverse x speed
    ldx $0203
    cpx #$F0
    bcc :+
    lda #$01
    sta $0000 ; ball_xdir
:

    ; If ball is past y high limit, reverse y speed
    ldx $0200
    cpx #$D8
    bcc :+
    lda #$01
    sta $0001 ; ball_ydir
:

    ; If ball is past x low limit, reverse x speed
    ldx $0203
    cpx #$00
    bne :+
    lda #$00
    sta $0000 ; ball_xdir
:

    ; If ball is past y low limit, reverse y speed
    ldx $0200
    cpx #$08
    bne :+
    lda #$00
    sta $0001 ; ball_ydir
:

    ldx $0000 ; ball_xdir
    cpx #$00
    bne ball_x_backwards
    ldx $0203
    inx 
    stx $0203
    ldx $0207
    inx 
    stx $0207
    ldx $020B
    inx 
    stx $020B
    ldx $020F
    inx 
    stx $020F
    jmp :+
ball_x_backwards:
    ldx $0203
    dex 
    stx $0203
    ldx $0207
    dex 
    stx $0207
    ldx $020B
    dex 
    stx $020B
    ldx $020F
    dex 
    stx $020F
:


    ldx $0001 ; ball_xdir
    cpx #$00
    bne ball_y_backwards
    ldx $0200
    inx 
    stx $0200
    ldx $0204
    inx 
    stx $0204
    ldx $0208
    inx 
    stx $0208
    ldx $020C
    inx 
    stx $020C
    jmp :+
ball_y_backwards:
    ldx $0200
    dex 
    stx $0200
    ldx $0204
    dex 
    stx $0204
    ldx $0208
    dex 
    stx $0208
    ldx $020C
    dex 
    stx $020C
:

    lda #$02
    jsr ppu_set_sprite_ram

    rti 
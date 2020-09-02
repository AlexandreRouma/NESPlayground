.segment "HEADER"
.byte "NES"
.byte $1A
.byte $02 ; Prog rom count
.byte $01 ; Char rom count
.byte %00000000
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00, $00, $00, $00, $00 ; Filler
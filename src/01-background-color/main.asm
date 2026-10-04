    ; Load address for PRG ($0801 = start of BASIC)
    .segment "LOADADDR"
    .word $0801

    .segment "CODE"

    ; BASIC stub: "10 SYS 2061" -> jumps to machine code
    .byte $0B, $08, $0A, $00, $9E
    .byte "2061"
    .byte $00, $00, $00

    background_color = 53281  ; VIC-II background color register ($D021)
    red = 2                   ; color code for red

start:
    LDA #red                  ; load the color value into the accumulator
    STA background_color      ; write it to the background color register
    RTS                       ; return to BASIC

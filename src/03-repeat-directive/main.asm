    ; Load address for PRG ($0801 = start of BASIC)
    .segment "LOADADDR"
    .word $0801

    .segment "CODE"

    ; BASIC stub: "10 SYS 2061" -> jumps to machine code
    .byte $0B, $08, $0A, $00, $9E
    .byte "2061"
    .byte $00, $00, $00

    SCREEN_LAST  = 1984              ; start of the last screen row (row 24)
    SCREEN_COLS  = 40
    SCREEN_ROWS  = 25
    LAST_COL     = SCREEN_COLS - 1
    CHAR_A       = 1                 ; screen code for 'A'
    CHAR_B       = 2                 ; screen code for 'B'

start:
runtime_loop:
    ; writes a horizontal line of 'A' on the last row,
    ; one STA per character, computed at runtime via INX
    LDX #0
    LDA #CHAR_A
h_loop:
    STA SCREEN_LAST, X
    INX
    CPX #SCREEN_COLS
    BNE h_loop

assembly_time_repeat:
    ; writes a vertical line of 'B' in the last column, climbing up from
    ; the last row, one STA per character, unrolled at assembly time
    LDA #CHAR_B
    .repeat SCREEN_ROWS, row
    STA SCREEN_LAST + LAST_COL - (row * SCREEN_COLS)
    .endrepeat

halt:
    JMP *                     ; infinite loop

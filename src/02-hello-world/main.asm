    ; Load address for PRG ($0801 = start of BASIC)
    .segment "LOADADDR"
    .word $0801

    .segment "CODE"

    ; BASIC stub: "10 SYS 2061" -> jumps to machine code
    .byte $0B, $08, $0A, $00, $9E
    .byte "2061"
    .byte $00, $00, $00

start:
    LDA sc_h                  ; load screen code for 'h'
    STA 1514                  ; write to screen memory (row 12, col 10)

    LDA sc_e
    STA 1554

    LDA sc_l
    STA 1594
    STA 1634

    LDA sc_o
    STA 1674

    LDA sc_w
    STA 1516                  ; (row 12, col 12)

    LDA sc_o
    STA 1556

    LDA sc_r
    STA 1596

    LDA sc_l
    STA 1636

    LDA sc_d
    STA 1676

print_string:
    LDX #0                    ; X = index into hello_string

print_loop:
    LDA hello_string, X       ; load char at index X
    BEQ halt                  ; if char == 0, end of string
    STA 1769, X               ; write char at screen offset 1769
    LDA #00                   ; color code for black
    STA $D800 + 745, X        ; write color at color RAM offset 745
    INX                       ; next index
    JMP print_loop            ; repeat

halt:
    JMP *                     ; infinite loop

sc_h:
    .byte $08                 ; screen code for 'h'
sc_e:
    .byte $05
sc_l:
    .byte $0C
sc_o:
    .byte $0F
sc_w:
    .byte $17
sc_r:
    .byte $12
sc_d:
    .byte $04

hello_string:
    .byte $08, $05, $0C, $0C, $0F, $20, $17, $0F, $12, $0C, $04, $00

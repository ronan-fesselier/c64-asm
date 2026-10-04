    ; Load address for PRG ($0801 = start of BASIC)
    .segment "LOADADDR"
    .word $0801

    .segment "CODE"

    ; BASIC stub: "10 SYS 2061" -> jumps to machine code
    .byte $0B, $08, $0A, $00, $9E
    .byte "2061"
    .byte $00, $00, $00

    V = 53248                 ; VIC-II base address ($D000)

start:
    LDA #04                   ; enable sprite 2 (bit 2 = %00000100)
    STA V + 21                ; VIC-II sprite enable register ($D015)
    LDA #13                   ; sprite data at block 13 (13 * 64 = 832)
    STA 2042                  ; sprite 2 pointer ($07FA)
    LDX #00

copy_sprite:
    LDA sprite, X             ; read byte from sprite data
    STA 832, X                ; copy to sprite block at 832
    INX
    CPX #64                   ; sprite is 64 bytes
    BNE copy_sprite

move_sprite:
    LDX #00                   ; X = index into the circular path table

move_loop:
    LDA path_x, X
    STA V + 4                 ; sprite 2 X position ($D004)
    LDA path_y, X
    STA V + 5                 ; sprite 2 Y position ($D005)

    LDY #20                   ; outer delay: bigger = slower movement
delay_outer:
    LDA #00
    STA $FB                   ; inner delay counter (zero page)
delay_inner:
    DEC $FB
    BNE delay_inner
    DEY
    BNE delay_outer

    INX
    CPX #PATH_LEN             ; wrap around after the last table entry
    BNE move_loop
    JMP move_sprite           ; restart from index 0

sprite:
    .byte 0, 127, 0, 1, 255, 192, 3, 255, 224, 3, 231, 224
    .byte 7, 217, 240, 7, 223, 240, 7, 217, 240, 3, 231, 224
    .byte 3, 255, 224, 3, 255, 224, 2, 255, 160, 1, 127, 64
    .byte 1, 62, 64, 0, 156, 128, 0, 156, 128, 0, 73, 0, 0, 73, 0
    .byte 0, 62, 0, 0, 62, 0, 0, 62, 0, 0, 28, 0
    .byte 0

    ; precomputed circular path (64 points), center (160, 120), radius (80, 60)
    PATH_LEN = 64

path_x:
    .byte 240, 240, 238, 237, 234, 231, 227, 222, 217, 211, 204, 198, 191, 183, 176, 168
    .byte 160, 152, 144, 137, 129, 122, 116, 109, 103, 98, 93, 89, 86, 83, 82, 80
    .byte 80, 80, 82, 83, 86, 89, 93, 98, 103, 109, 116, 122, 129, 137, 144, 152
    .byte 160, 168, 176, 183, 191, 198, 204, 211, 217, 222, 227, 231, 234, 237, 238, 240

path_y:
    .byte 120, 126, 132, 137, 143, 148, 153, 158, 162, 166, 170, 173, 175, 177, 179, 180
    .byte 180, 180, 179, 177, 175, 173, 170, 166, 162, 158, 153, 148, 143, 137, 132, 126
    .byte 120, 114, 108, 103, 97, 92, 87, 82, 78, 74, 70, 67, 65, 63, 61, 60
    .byte 60, 60, 61, 63, 65, 67, 70, 74, 78, 82, 87, 92, 97, 103, 108, 114

    ; Load address for PRG ($0801 = start of BASIC)
    .segment "LOADADDR"
    .word $0801

    .segment "CODE"

    ; BASIC stub: "10 SYS 2061" -> jumps to machine code
    .byte $0B, $08, $0A, $00, $9E
    .byte "2061"
    .byte $00, $00, $00

    SCREEN_START = 1024

start:
label_address_demo:
    ; a label is just an address. <label and >label give its low / high byte,
    ; so we can read it like any other number.
    LDA #<label_address_demo  ; low byte of this label's address
    STA SCREEN_START
    LDA #>label_address_demo  ; high byte of this label's address
    STA SCREEN_START + 1

self_modifying_demo:
    ; the LDA immediate below has its operand stored right after the opcode,
    ; at "patch_me + 1". We can write to that address like any other memory
    ; location, changing what the instruction loads before it even runs.
    LDA #4                    ; color code for green
    STA patch_me + 1          ; patch the operand before it executes
patch_me:
    LDA #0                    ; this #0 gets replaced by the STA above
    STA SCREEN_START + 2

halt:
    JMP *                     ; infinite loop

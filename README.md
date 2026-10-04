# C64 Assembly

A collection of small, self-contained Commodore 64 assembly programs, built
with [cc65](https://cc65.github.io/) and run in [VICE](https://vice-emu.sourceforge.io/).

## 📦 Prerequisites

| Tool                                       | Purpose                                     |
| ------------------------------------------ | ------------------------------------------- |
| [`cc65`](https://cc65.github.io/)          | 6502 assembler (`ca65`) and linker (`ld65`) |
| [`VICE`](https://vice-emu.sourceforge.io/) | C64 emulator (`x64sc`)                      |
| [`just`](https://github.com/casey/just)    | Command runner used to build/run programs   |

On Debian:

```sh
sudo apt install cc65 vice just
```

## 🚀 Quick start

Every program is a folder under `src/` containing a `main.asm`. Build and run
one with:

```sh
just run 01-background-color
```

This assembles the program, links it into a `.prg`, and launches VICE with
autostart: the program runs immediately, no typing required inside the
emulator.

To only build (without launching VICE):

```sh
just build 01-background-color
```

## 📚 Programs

| #   | Name                                                   | What it teaches                                                                                                                                                |
| --- | ------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 01  | [`background-color`](src/01-background-color/main.asm) | PRG load headers, the BASIC `SYS` stub, and writing to a VIC-II register                                                                                       |
| 02  | [`hello-world`](src/02-hello-world/main.asm)           | Writing text to screen memory, two ways: one `LDA`/`STA` per letter, and a zero-terminated string table read in a loop. Plus coloring characters via color RAM |
| 03  | [`repeat-directive`](src/03-repeat-directive/main.asm) | A runtime loop vs. the `.repeat` assembler directive: same result (filling screen rows/columns), one computed at runtime, the other unrolled at assembly time  |


## 🧠 How a program boots

A `.prg` file on the C64 starts with a 2-byte load address, followed by the
actual program bytes. Every program here uses the same trick to autorun:

1. The load address is `$0801`, the start of BASIC program memory.
2. The first bytes placed there are a tiny **BASIC stub**, equivalent to
   typing `10 SYS <address>`.
3. `RUN` (typed automatically on autostart) executes that BASIC line, which
   jumps straight into the program's machine code.
4. The machine code does its thing and returns to BASIC with `RTS`.

This is why a `.prg` "just works" when loaded: in VICE, in an online
emulator, or on real hardware.

## 🔗 Acknowledgements

Inspired by Philippe Gianviti's [8bit Retro Programming](https://www.youtube.com/@8bitretroprogramming) YouTube channel.

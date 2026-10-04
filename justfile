target := "c64"
cfg    := "src/c64-min.cfg"

build prog:
    mkdir -p build
    ca65 -v -t {{target}} -l build/{{prog}}.lst -o build/{{prog}}.o src/{{prog}}/main.asm
    ld65 -v -C {{cfg}} -m build/{{prog}}.map -Ln build/{{prog}}.sym -o build/{{prog}}.prg build/{{prog}}.o

run prog: (build prog)
    x64sc -autostartprgmode 1 -autostart build/{{prog}}.prg

vice:
    x64sc

clean:
    rm -rf build

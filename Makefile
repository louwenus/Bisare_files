.PHONY: main submodule rust debug

FEATURES=rich_keyboard,rgba

SOURCES=
SOURCES+=base
SOURCES+=bad_apple
SOURCES+=bad_apple_vid
# SOURCES+=mmio
# SOURCES+=graphic

PIC=

UNSIZED_PIC=
# UNSIZED_PIC+=fontplate

sources_asm = $(patsubst %,asm/%.asm,$(SOURCES))
pic_asm = $(patsubst %,build/pic_%.asm,$(PIC))
unsized_pic_asm = $(patsubst %,build/upic_%.asm,$(UNSIZED_PIC))

main: build/main.bin submodule
	cargo -C bisare_sim_rs -Z unstable-options run --release --features=$(FEATURES) -p simu ../build/main.bin
	

build/main.bin: $(pic_asm) $(unsized_pic_asm) build/prog.asm submodule 
	cat build/prog.asm $(pic_asm) $(unsized_pic_asm) | \
	./bisare_sim_rs/target/release/asm - build/main.bin

build/prog.asm: $(sources_asm) build
	cat $(sources_asm) > build/prog.asm

build:
	mkdir -p build

submodule:
	git submodule update --init --remote bisare_sim_rs
	cargo -C bisare_sim_rs -Z unstable-options build --release -p asm -p bitmap_to_asm

debug: build/main.bin submodule
	cargo -C bisare_sim_rs -Z unstable-options run --release --features=$(FEATURES),debug -p simu ../build/main.bin

build/pic_%.asm: pictures/%.png submodule
	./bisare_sim_rs/target/release/bitmap_to_asm $< > $@ 

build/upic_%.asm: pictures/%.png submodule
	./bisare_sim_rs/target/release/bitmap_to_asm $< --nosize > $@

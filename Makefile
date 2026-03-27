.PHONY: main submodule rust debug

FEATURES=rich_keyboard,rgba,div_mul

SOURCES=
SOURCES+=base
# SOURCES+=bad_apple
# SOURCES+=bad_apple_vid
SOURCES+=main
SOURCES+=mmio
SOURCES+=graphic
SOURCES+=stores
SOURCES+=fonction_plantes

PIC=
PIC+=background
PIC+=game_over
PIC+=tournesol
PIC+=pistopois
PIC+=noix
PIC+=double_pistopois
PIC+=cerise
PIC+=mine_dechargee
PIC+=mine_chargee
PIC+=zombie
PIC+=zombie_casque
PIC+=zombie_rapide

FONTPLATE_PIC=
FONTPLATE_PIC+=fontplate

sources_asm = $(patsubst %,asm/%.asm,$(SOURCES))
pic_asm = $(patsubst %,build/pic_%.asm,$(PIC))
fontplate_pic_asm = $(patsubst %,build/upic_%.asm,$(FONTPLATE_PIC))

main: build/main.bin submodule
	cargo -C bisare_sim_rs -Z unstable-options run --release --features=$(FEATURES) -p simu ../build/main.bin
	

build/main.bin: $(pic_asm) $(fontplate_pic_asm) build/prog.asm submodule 
	cat build/prog.asm $(pic_asm) $(fontplate_pic_asm) | \
	./bisare_sim_rs/target/release/asm - build/main.bin

build/prog.asm: $(sources_asm) build
	cat $(sources_asm) > build/prog.asm

build:
	mkdir -p build

submodule:
	git submodule update --init --remote bisare_sim_rs
	cargo -C bisare_sim_rs -Z unstable-options build --release -p asm
	cargo -C bitmap_to_asm -Z unstable-options build --release

debug: build/main.bin submodule
	cargo -C bisare_sim_rs -Z unstable-options run --release --features=$(FEATURES),debug -p simu ../build/main.bin
	
build/pic_%.asm: pictures/%.png submodule
	./bitmap_to_asm/target/release/bitmap_to_asm $< > $@ 

build/upic_%.asm: pictures/%.png submodule
	./bitmap_to_asm/target/release/bitmap_to_asm $< --fontplate > $@

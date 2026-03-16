.PHONY main submodule rust debug
main: build/main.bin
	cargo -C bisare_sim_rs -Z unstable-options --release --features=rich_keyboard -p simu ../build/main.bin
	

build/main.bin: build asm/base.asm asm/main.asm asm/mmio.asm submodule
	cat src/base.asm src/main.asm src/mmio.asm | \
		cargo -C bisare_sim_rs -Z unstable-options --release -p asm - ../build/main.bin

build:
	mkdir -p build

submodule:
	git submodule update --init bisare_sim_rs

debug: build/main.bin
	cargo -C bisare_sim_rs -Z unstable-options --release --features=rich_keyboard,debug -p simu ../build/main.bin
	

# ----------------------------
# Makefile Options
# ----------------------------

CL65       = cl65
CL65_FLAGS = -t cx16
RM         = rm -f
X16EMU     = x16emu

default: all

all:
	@echo "Building project..."
	mkdir -p bin
	mkdir -p lst
	$(CL65) $(CL65_FLAGS) -o bin/FIRSTPRG.PRG -l lst/firstprg.lst src/main.asm

clean:
	@echo "Cleaning project..."
	rm -rf bin
	rm -rf lst

run:
	@echo "Launching emulator..."
	$(X16EMU) -prg bin/FIRSTPRG.PRG
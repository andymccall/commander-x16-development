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
	$(CL65) $(CL65_FLAGS) -o bin/DISPLAYBMX.PRG -l lst/menu.lst src/main.asm
	cp -r src/ASSETS bin/

clean:
	@echo "Cleaning project..."
	rm -rf bin
	rm -rf lst
	rm -rf *.bin

run:
	@echo "Launching emulator..."
	$(X16EMU) -prg bin/DISPLAYBMX.PRG
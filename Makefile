TOOLCHAIN_SYSROOT = /usr
CC = gcc

DEBUG=1

EXE = worship.bin

CFLAGS = -DLINUX -O2 -fomit-frame-pointer -ffunction-sections -ffast-math
CFLAGS += -D__BUILDDATE=\"$(shell date +%d-%b-%Y)\"
LDFLAGS = -flto
INCLUDE = $(shell pkg-config --cflags sdl2 SDL2_mixer)

ifdef DEBUG
 CFLAGS += -g
else
 CFLAGS += -G0
endif

LIB = $(shell pkg-config --libs sdl2 SDL2_mixer)

CC = $(HOST)gcc
STRIP = $(HOST)strip

SRC = 	gameframe.c \
	gamestate.c \
	initgame.c \
	mapdata.c \
	playeriteraction.c \
	renderobjects.c \
	vars.c \
	gamegui.c \
	gamestep.c \
	main.c \
	mobs.c \
	postrender.c \
	sblit.c \
	vlines.c \
	zmath.c \
	gameloop.c \
	gpu3d.c \
	mainmenu.c \
	palette.c \
	rendermap.c \
	ssystem.c \
	waveai.c
CFLAGS += $(DEFS)

OBJ = $(SRC:.c=.o)

all : $(SRC) $(EXE)

$(EXE): $(OBJ)
	$(CC) $(LDFLAGS) $(OBJ) $(LIB) -o $@
ifndef DEBUG
	$(STRIP) $(EXE)
endif

.c.o:
	$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@

wasm:
	$(MAKE) -f Makefile.wasm

clean:
	rm -rf $(OBJ) $(EXE)

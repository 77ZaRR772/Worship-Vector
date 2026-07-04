TOOLCHAIN_SYSROOT = /usr
CC = gcc
DEBUG = 1


ifeq ($(OS),Windows_NT)
    PLATFORM = WINDOWS
    RM = del /Q
    CP = copy
    EXE_EXT = .exe
else
    PLATFORM = LINUX
    RM = rm -f
    CP = cp
    EXE_EXT =
endif

EXE = worship$(EXE_EXT)

# PKG-CONFIG for LINUX
# Linux: 64-bit path of libs to fix linking
# Windows: default call of pkg-config
ifeq ($(PLATFORM),LINUX)
    INCLUDE = $(shell PKG_CONFIG_PATH=/usr/lib/pkgconfig:/usr/lib64/pkgconfig:/usr/share/pkgconfig pkg-config --cflags sdl2 SDL2_mixer)
    LIB = $(shell PKG_CONFIG_PATH=/usr/lib/pkgconfig:/usr/lib64/pkgconfig:/usr/share/pkgconfig pkg-config --libs sdl2 SDL2_mixer)
else
    INCLUDE = $(shell pkg-config --cflags sdl2 SDL2_mixer)
    LIB = $(shell pkg-config --libs sdl2 SDL2_mixer)
endif

ifneq ($(findstring lib32,$(LIB)),)
    $(warning pkg-config found lib32. Sound might not work!)
    $(warning Try manually: make PKG_CONFIG_PATH="/usr/lib/pkgconfig:/usr/share/pkgconfig")
endif

CFLAGS = -DLINUX -O2 -fomit-frame-pointer -ffunction-sections -ffast-math
CFLAGS += -D__BUILDDATE="\"$(shell LC_ALL=C date +%d-%b-%Y)\""
LDFLAGS = -flto

ifdef DEBUG
 CFLAGS += -g
else
 CFLAGS += -G0
endif

CC = $(HOST)gcc
STRIP = $(HOST)strip

SRC = gameframe.c \
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
	@echo "=== Copying $(EXE) to folder redist/... ==="
	-$(CP) $(EXE) redist/

.c.o:
	$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@

wasm:
	$(MAKE) -f Makefile.wasm

clean:
	-$(RM) $(OBJ) $(EXE)

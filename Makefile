# Basic Makefile for Brain Rot Brawl
TARGET = brb

CC = gcc
# Add SDL2 CFLAGS
SDL_CFLAGS = $(shell sdl2-config --cflags)
CFLAGS = -std=c99 -Wall -Wextra -pedantic -Iinclude $(SDL_CFLAGS)

# Add SDL2 LDFLAGS
SDL_LDFLAGS = $(shell sdl2-config --libs)
LDFLAGS = $(SDL_LDFLAGS)

SRC_DIRS = src/core src/gameplay src/input src/rendering src/physics src/networking src/audio
SRCS = $(wildcard src/*.c) $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.c))
OBJS_DIR = build/obj
OBJS = $(patsubst src/%.c,$(OBJS_DIR)/%.o,$(SRCS))

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $^ -o build/$(TARGET) $(LDFLAGS)

$(OBJS_DIR)/%.o: src/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: all clean

clean:
	rm -rf build/$(TARGET) $(OBJS_DIR)

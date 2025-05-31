# Basic Makefile for Brain Rot Brawl
# Target executable name
TARGET = brb

# Compiler and flags
CC = gcc
CFLAGS = -std=c99 -Wall -Wextra -pedantic -Iinclude
LDFLAGS =

# Source directories
SRC_DIRS = src/core src/gameplay src/input src/rendering src/physics src/networking src/audio

# Find all .c files in source directories
SRCS = $(wildcard src/*.c) $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.c))

# Object files: create a list of .o files in a build directory
OBJS_DIR = build/obj
OBJS = $(patsubst src/%.c,$(OBJS_DIR)/%.o,$(SRCS))

# Default target
all: $(TARGET)

# Linking the target executable
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $^ -o build/$(TARGET) $(LDFLAGS)

# Compiling .c files to .o files
$(OBJS_DIR)/%.o: src/%.c
	@mkdir -p $(@D) # Create directory for .o file if it doesn't exist
	$(CC) $(CFLAGS) -c $< -o $@

# Phony targets
.PHONY: all clean

# Clean build artifacts
clean:
	rm -rf build/$(TARGET) $(OBJS_DIR)

# To explicitly list source files (for debugging Makefile)
list_srcs:
	@echo $(SRCS)
list_objs:
	@echo $(OBJS)

# Compilation Flags
CC 					:= gcc
CFLAGS 			:= -O3 -std=c17
CWARN_FLAGS := -Wall -Wextra
LDFLAGS 		:= -lm

# Project Directories
SRC_DIR := .
BIN_DIR := ../bin

# Terminal Colors
BLUE=\033[1;34m
RED=\033[0;31m
GREEN=\033[0;32m
RESET_COLOR=\033[0m

# Terminal Font Size  
BOLD=$(shell tput bold)
NORM=$(shell tput sgr0)

.PHONY: all clean build

all: build

build: $(BIN_DIR)/code1 $(BIN_DIR)/code2

clean:
	@rm -rf $(BIN_DIR)

$(BIN_DIR)/%: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	@echo -ne " => ${BLUE}COMPILING $< ${RESET_COLOR}"
	@$(CC) $(CFLAGS) $(CWARN_FLAGS) -o $@ $< $(LDFLAGS)
	@echo -e "${GREEN}${BOLD}\t[DONE]${NORM}${RESET_COLOR}"

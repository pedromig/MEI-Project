# Compilation Flags
CC 					:= gcc
CFLAGS 			:= -O3 -std=c17
CWARN_FLAGS := -Wall -Wextra
LDFLAGS 		:= -lm

# Project Directories
SRC_DIR := .
BIN_DIR := ../bin

# Terminal Colors and Fonts Weights
ifneq (,$(findstring xterm,${TERM}))
	RED   := $(shell tput -Txterm setaf 1)
	GREEN := $(shell tput -Txterm setaf 2)
	BLUE  := $(shell tput -Txterm setaf 6)
	RESET := $(shell tput -Txterm sgr0)
	BOLD  := $(shell tput bold)
	NORM  := $(shell tput sgr0)
else
	BLACK := ""
	RED   := ""
	GREEN := ""
	BLUE  := ""
	RESET := ""
	BOLD 	:= ""
	NORM 	:= ""
endif

.PHONY: all clean build

all: build

build: $(BIN_DIR)/code1 $(BIN_DIR)/code2

clean:
	@rm -rf $(BIN_DIR)

$(BIN_DIR)/%: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	@echo -n " => ${BLUE}COMPILING $< ${RESET}"
	@$(CC) $(CFLAGS) $(CWARN_FLAGS) -o $@ $< $(LDFLAGS)
	@echo "${GREEN}${BOLD}\t[DONE]${NORM}${RESET}"

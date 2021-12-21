# Compilation Flags
CC 					:= gcc
CFLAGS 			:= -O3 -std=c17
CWARN_FLAGS := -Wall -Wextra
LDFLAGS 		:= -lm

# Project Directories
PROJECT_ROOT := ..
BUILD_DIR 	 := build

# Solver Directories
SOLVER_SRC_DIR   := .
SOLVER_BUILD_DIR := $(PROJECT_ROOT)/$(BUILD_DIR)

# Terminal Colors and Fonts Weights
ifneq (,$(findstring xterm,${TERM}))
	RED   := $(shell tput -Txterm setaf 1)
	GREEN := $(shell tput -Txterm setaf 2)
	BLUE  := $(shell tput -Txterm setaf 6)
	RESET := $(shell tput -Txterm sgr0)
	BOLD  := $(shell tput bold)
	NORM  := $(shell tput sgr0)
endif

.PHONY: all clean build

all: build

build: $(SOLVER_BUILD_DIR)/code1 $(SOLVER_BUILD_DIR)/code2
	@echo "${BOLD}Build Complete!${NORM}"

clean:
	@echo -n "${BOLD}Removing $(BUILD_DIR) directory... ${NORM}" 
	@rm -rf $(SOLVER_BUILD_DIR)
	@echo "${GREEN}${BOLD}DONE!${NORM}${RESET}"

$(SOLVER_BUILD_DIR)/%: $(SOLVER_SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	@echo -n " => ${BLUE}COMPILING $< ${RESET}"
	@$(CC) $(CFLAGS) $(CWARN_FLAGS) -o $@ $< $(LDFLAGS)
	@echo -e "${GREEN}${BOLD}\t[DONE]${NORM}${RESET}"

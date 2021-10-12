# Project Directories
SRC_DIR 	 	 := src
SCRIPTS_DIR  := scripts
INSTANCE_DIR := instances
OUT_DIR 		 := out

# Generator Parameters
GEN_EXAMS := 10 25 50 100 200 300 
GEN_PROBS := 0.2 0.4 0.6 0.8 1.0
GEN_SEEDS := 0 1 2 3

# Run Paramters
INSTANCES := $(INSTANCE_DIR)/* 
RUNTIME 	:= 60 120 180 240 300 #(seconds)

# Terminal Colors
GREEN=\033[0;32m
RESET_COLOR=\033[0m

# Terminal Font Size  
BOLD=$(shell tput bold)
NORM=$(shell tput sgr0)

.PHONY: all build clean all-clean instances

all: build instances

build:
	@echo -e "${BOLD}Buiding Target... ${NORM}"
	@$(MAKE) --no-print-directory -C $(SRC_DIR) $@
	@echo -e "${BOLD}Build Completed!${NORM}"

clean:
	@echo -e "${BOLD}Cleaning...${NORM}"
	@echo -ne "${BOLD}Removing bin dir... ${NORM}" 
	@$(MAKE) --no-print-directory -C $(SRC_DIR) $@ 
	@echo -e "${GREEN}${BOLD}DONE!${NORM}${RESET_COLOR}"

all-clean: clean
	@echo -ne "${BOLD}Removing instances dir... ${NORM}"
	@rm -rf $(INSTANCE_DIR)
	@echo -e "${GREEN}${BOLD}DONE!${NORM}${RESET_COLOR}"
	@echo -ne "${BOLD}Removing out dir... ${NORM}"
	@rm -rf $(OUT_DIR)
	@echo -e "${GREEN}${BOLD}DONE!${NORM}${RESET_COLOR}"

instances:
	@./$(SCRIPTS_DIR)/generate_instances.sh "$(GEN_EXAMS)" "$(GEN_PROBS)" "$(GEN_SEEDS)"

runs:
	@./$(SCRIPTS_DIR)/run.sh "$(INSTANCES)" "$(RUNTIME)"

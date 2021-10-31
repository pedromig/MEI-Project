# Project Directories
SRC_DIR 	 	 := src
SCRIPTS_DIR  := scripts
INSTANCE_DIR := instances
OUT_DIR 		 := out

# Generator Parameters
GEN_EXAMS := 5 10 12 14 18 20 25 50 
GEN_PROBS := 0.2 0.4 0.6 0.8 1.0
GEN_SEEDS := 0 1 2 3

# Run Paramters
RUN_INSTANCES := $(INSTANCE_DIR)/* 
RUN_TIMES 		:= 60 120 180 240 300#(seconds)
RUN_SEEDS 		:= 0 

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

.PHONY: all build clean all-clean instances

all: build instances runs

build:
	@echo "${BOLD}Buiding Targets... ${NORM}"
	@$(MAKE) --no-print-directory -C $(SRC_DIR) $@
	@echo "${BOLD}Build Completed!${NORM}"

clean:
	@echo "${BOLD}Cleaning...${NORM}"
	@echo -n "${BOLD}Removing bin dir... ${NORM}" 
	@$(MAKE) --no-print-directory -C $(SRC_DIR) $@ 
	@echo "${GREEN}${BOLD}DONE!${NORM}${RESET}"

all-clean: clean
	@echo -n "${BOLD}Removing instances dir... ${NORM}"
	@rm -rf $(INSTANCE_DIR)
	@echo "${GREEN}${BOLD}DONE!${NORM}${RESET}"
	@echo -n "${BOLD}Removing out dir... ${NORM}"
	@rm -rf $(OUT_DIR)
	@echo "${GREEN}${BOLD}DONE!${NORM}${RESET}"

instances:
	@./$(SCRIPTS_DIR)/generate_instances.sh "$(GEN_EXAMS)" "$(GEN_PROBS)" "$(GEN_SEEDS)"

runs:
	@./$(SCRIPTS_DIR)/run.sh "$(RUN_INSTANCES)" "$(RUN_TIMES)" "$(RUN_SEEDS)"

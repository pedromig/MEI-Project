#Project Source Directories
SRC_DIR 		 := src
SCRIPTS_DIR  := scripts
SOLVER_DIR 	 := solver

# Project Output Directories
INSTANCE_DIR := instances
PLOTS_DIR		 := plots
OUT_DIR 		 := out

# Generator Parameters
GEN_EXAMS := 30 31 32 33 34 35
GEN_PROBS := 0.2 0.4 0.6 0.8 1.0
GEN_SEEDS := 0 1 2 3

# Run Paramters
RUN_INSTANCES := $(INSTANCE_DIR)/* 
RUN_TIMES 		:= 60 120 180 240 300#(seconds)
RUN_SEEDS 		:= 0 1 2 3 5 6 7 8 9 10

# Terminal Colors and Fonts Weights
ifneq (,$(findstring xterm,${TERM}))
	RED   := $(shell tput -Txterm setaf 1)
	GREEN := $(shell tput -Txterm setaf 2)
	BLUE  := $(shell tput -Txterm setaf 6)
	RESET := $(shell tput -Txterm sgr0)
	BOLD  := $(shell tput bold)
	NORM  := $(shell tput sgr0)
endif

.PHONY: all build clean all-clean instances plots

all: build instances

build:
	@echo "${BOLD}Buiding Targets... ${NORM}"
	@$(MAKE) --no-print-directory -C $(SOLVER_DIR) $@

clean:
	@echo "${BOLD}Cleaning...${NORM}"
	@$(MAKE) --no-print-directory -C $(SOLVER_DIR) $@ 

all-clean: clean
	@echo -n "${BOLD}Removing $(INSTANCE_DIR) directory... ${NORM}"
	@rm -rf $(INSTANCE_DIR)
	@echo "${GREEN}${BOLD}DONE!${NORM}${RESET}"
	@echo -n "${BOLD}Removing $(OUT_DIR) directory... ${NORM}"
	@rm -rf $(OUT_DIR)
	@echo "${GREEN}${BOLD}DONE!${NORM}${RESET}"
	@echo -n "${BOLD}Removing $(PLOTS_DIR) directory... ${NORM}"
	@rm -rf $(PLOTS_DIR)
	@echo "${GREEN}${BOLD}DONE!${NORM}${RESET}"

instances:
	@./$(SCRIPTS_DIR)/generate_instances.sh "$(GEN_EXAMS)" "$(GEN_PROBS)" "$(GEN_SEEDS)"

runs:
	@./$(SCRIPTS_DIR)/run.sh "$(RUN_INSTANCES)" "$(RUN_TIMES)" "$(RUN_SEEDS)"

plots:
	@./$(SRC_DIR)/esp.R "$(FILE)" "$(PLOTS_DIR)"

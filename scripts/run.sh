#!/usr/bin/env sh

# Project Directories
PROJECT_ROOT="$(dirname "$0")/.."
BIN_DIR="$PROJECT_ROOT/bin"
OUT_DIR="$PROJECT_ROOT/out"


# Master file 
## Contains data for all the runs of the same type
## just having different seeds
MASTER_FILE="data.csv"

# Terminal Colors
if echo "$TERM" | grep -q "xterm"; then
	RED=$(tput -Txterm setaf 1)
	GREEN=$(tput -Txterm setaf 2)
	BLUE=$(tput -Txterm setaf 6)
	RESET=$(tput -Txterm sgr0)
	BOLD=$(tput bold)
	NORM=$(tput sgr0)
fi            

success(){
  printf "  %b${BOLD}[DONE]${NORM}%b\n" "${GREEN}" "${RESET}";
}

fail(){
  printf "  %b${BOLD}[FAILED]${NORM}%b\n" "${RED}" "${RESET}";
}

if [ $# -ne 3 ]; then  
cat<<'EOF'
Exam Scheduling Problem (ESP) instance runner util.

Usage: ${0} "{INSTANCES}" "{MAX_RUNTIME}" "{SEEDS}"

Output: 
 Run Output File: esp_{INSTANCE}_{RUNTIME}_{RUN_SEED}.out

Examples:
  user@computer$ ./run.sh "instances/esp_*_0.2_*.dat" "120 180" "12313"
  user@computer$ ./run.sh "instances/*" "60 180 300" "0 1 2"
EOF
  exit 1;
fi

echo "${BOLD}Running Instance Files...${NORM}"
for i in $1; do
  for t in $2; do
    for s in $3; do
      printf " => %bRUNNING %s %b\n" "${BLUE}" "$i" "${RESET}"
      for exec in "$BIN_DIR"/*; do
        n_exams=$(echo "$i" | cut -d "_" -f 2)
        prob=$(echo "$i" | cut -d "_" -f 3)
        dir="${OUT_DIR}/${n_exams}/${prob}/${t}/$(basename "$exec")"
        out="$(basename "${i%.*}")_${t}_${s}.out"

        mkdir -p "${dir}"
        printf "    -> %bGENERATING %s %b" "${BLUE}" "$out" "${RESET}" 
        (./"$exec" "$s" "$t" "$i" > "${dir}/${out}" && success) || fail  
        cat "${dir}/${out}" >> "${dir}/${MASTER_FILE}"
      done
    done
  done
done  
echo "${BOLD}Instance Runs Completed!${NORM}" && exit 0

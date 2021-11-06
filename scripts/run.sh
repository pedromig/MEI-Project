#!/usr/bin/env sh

# Project Directories
PROJECT_ROOT="$(dirname "$0")/.."
BIN_DIR="$PROJECT_ROOT/bin"
OUT_DIR="$PROJECT_ROOT/out"

# Master file 
## Contains data for all the runs
MASTER_FILE="data_$(date +"%d_%m_%Y").csv"

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
 Run Output File: data_{day}_{month}_{year}.csv

Examples:
  user@computer$ ./run.sh "instances/esp_*_0.2_*.dat" "120 180" "12313"
  user@computer$ ./run.sh "instances/*" "60 180 300" "0 1 2"
EOF
  exit 1;
fi

mkdir -p "$OUT_DIR"
echo "${BOLD}Running Instance Files...${NORM}" && tmp=$(mktemp)

echo "exams,probability,instance_seed,solver_seed,solver,slots,time,max_time" \
  >> "${OUT_DIR}/${MASTER_FILE}"

for i in $1; do
  ne=$(echo "$i" | cut -d "_" -f 2)
  prob=$(echo "$i" | cut -d "_" -f 3)
  is=$(echo "$i" | cut -d "_" -f 4)
  for t in $2; do
    for s in $3; do
      printf " => %bRUNNING %s %b " "${BLUE}" "$i" "${RESET}"
      for exec in "$BIN_DIR"/*; do
        (./"$exec" "$s" "$t" "$i" > "$tmp") || (fail && exit 1)
        solver="$(basename "$exec")"
        slots="$(cut -d " " -f 1 "$tmp")"
        time="$(cut -d " " -f 2 "$tmp")"
        echo "${ne},${prob},${is%.*},${s},${solver},${slots},${time},${t}" \
          >> "${OUT_DIR}/${MASTER_FILE}"
      done && success
    done
  done
done  
echo "${BOLD}Instance Runs Completed!${NORM}" && rm "$tmp" && exit 0 

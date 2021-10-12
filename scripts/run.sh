#!/usr/bin/env sh

# Project Directories
PROJECT_ROOT="$(dirname "$0")/.."
BIN_DIR="$PROJECT_ROOT/bin"
OUT_DIR="$PROJECT_ROOT/out"

# Terminal Colors
BLUE='\033[1;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
RESET_COLOR='\033[0m'

# Terminal Font Size  
BOLD=$(tput bold)
NORM=$(tput sgr0)

help() {
cat<<EOF
Exam Scheduling Problem (ESP) instance runner util.

Usage: ${0} "{INSTANCES}" "{RUNTIME}" 

Output: 
 Run Output File: esp_{INSTANCE}_{RUNTIME}_{RUN_SEED}_{EXEC}.out

Examples:
  user@computer$ ${0} "instances/isp_*_0.2_*.dat" "120 180"
  user@computer$ ${0} "instances/*" "60 180 300"
EOF
}

if [ $# -ne 2 ]; then  
  help && exit 1 
fi

mkdir -p "$OUT_DIR"
echo "${BOLD}Running Instance Files...${NORM}"
for i in $1; do
  for t in $2; do
    s=$RANDOM;
    printf " => %bRUNNING %s\t\t %b\n" "${BLUE}" "$i" "${RESET_COLOR}" 
    for exec in "$BIN_DIR"/*; do
      out="$(basename ${i%.*})_${t}_${s}$(basename $exec).out"
      printf "    -> %bGENERATING %s\t\t %b" "${BLUE}" "$out" "${RESET_COLOR}" 
      ./$exec "$s" "$t" "$i" > "$OUT_DIR/$out" \
        && printf "%b${BOLD}[DONE]${NORM}%b\n" "${GREEN}" "${RESET_COLOR}" \
        || printf "%b${BOLD}[FAILED]${NORM}%b\n" "${RED}" "${RESET_COLOR}"   
    done 
  done
done  
echo "${BOLD}Instance Runs Completed!${NORM}" && exit 0

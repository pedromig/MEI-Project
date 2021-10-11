#!/usr/bin/env sh

# Project Directories
PROJECT_ROOT="$(dirname "$0")/.."
SCRIPTS_DIR="$PROJECT_ROOT/scripts"
INSTANCE_DIR="$PROJECT_ROOT/instances"

# Terminal Colors
BLUE='\033[1;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
RESET_COLOR='\033[0m'

# Terminal Font Size  
BOLD=$(tput bold)
NORM=$(tput sgr0)

function help() {
cat<<EOF
Interval Scheduling Problem (ISP) instance generator helper util.

Usage: ${0} "{N-EXAMS}" "{PROBABILITY}" "{SEED}"

Examples:
  user@computer$ ${0} 20 0.3 123213 
  user@computer$ ${0} "50 100 200" "0.2 0.4 0.8" "012 123 2123"
EOF
}

[ $# -ne 3 ] && help && exit 1 || mkdir -p $INSTANCE_DIR;

echo "${BOLD}Beginning Instance Generation...${NORM}"
for n in $1; do
  for p in $2; do 
    for s in $3; do 
      inst="$INSTANCE_DIR/isp_${n}_${p}_${s}.dat"
      printf " => ${BLUE}GENERATING $inst\t\t${RESET_COLOR}"
        "./$SCRIPTS_DIR/gen.py" -n "$n" -p "$p" -s "$s" -o "$inst" 2> /dev/null \
            && echo -e "${GREEN}${BOLD}[DONE]${NORM}${RESET_COLOR}" \
            || echo -e "${RED}${BOLD}[FAILED]${NORM}${RESET_COLOR}"
    done
  done 
done
echo "${BOLD}Instance Generation Completed!${NORM}" && exit 0


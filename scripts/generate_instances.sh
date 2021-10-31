#!/usr/bin/env sh

# Project Directories
PROJECT_ROOT="$(dirname "$0")/.."
SCRIPTS_DIR="$PROJECT_ROOT/scripts"
INSTANCE_DIR="$PROJECT_ROOT/instances"

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
  printf "%b${BOLD}[DONE]${NORM}%b\n" "${GREEN}" "${RESET}";
}

fail(){
  printf "%b${BOLD}[FAILED]${NORM}%b\n" "${RED}" "${RESET}";
}

if [ $# -ne 3 ]; then  
cat<<'EOF'
Exam Scheduling Problem (ESP) instance generator helper util.

Usage: ./generate_instances.sh "{N-EXAMS}" "{PROBABILITY}" "{SEED}"

Output:
  Instance File: esp_{N-EXAMS}_{PROBABILITY}_{SEED}.dat

Examples:
  user@computer$ ./generate_instances.sh 20 0.3 123213 
  user@computer$ ./generate_instances.sh "50 100 200" "0.2 0.4 0.8" "012 123 2123"
EOF
  exit 1 
fi

mkdir -p "$INSTANCE_DIR";
echo "${BOLD}Beginning Instance Generation...${NORM}"
for n in $1; do
  for p in $2; do 
    for s in $3; do 
      inst="$INSTANCE_DIR/esp_${n}_${p}_${s}.dat"
      if [ ! -f "$inst" ]; then
        printf " => %bGENERATING %s %b" "${BLUE}" "$(basename "$inst")" "${RESET}" 
        ("./$SCRIPTS_DIR/gen.py" -n "$n" -p "$p" -s "$s" -o "$inst" && success) || fail
      fi
    done
  done 
done
echo "${BOLD}Instance Generation Completed!${NORM}" && exit 0


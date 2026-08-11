#!/bin/bash

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[0;36m'
INVERT='\033[7m'
NC='\033[0m' # No Color - Always put in the end of every message

# Filenames specified in Order, so assembled is more readable
filenames=("robohelp.sh")
temppath="/tmp/robohelp"
tempfile="$temppath/robohelp.sh"

temp_file_exists() {
	if [ -e "$tempfile" ]; then
		echo -e "${GREEN}Temp folder and file exist${NC}"
		return 0
	else
		echo -e "${CYAN}Creating...${NC}"
		sleep 2
		if mkdir -p "$temppath" && touch "$tempfile"; then
			echo -e "${GREEN}Creating successful${NC}"
		else
			echo -e "${RED}Creating $tempfile failed${NC}"
		fi
	fi
}

collect_scripts() {
	for file in "${filenames[@]}"; do
		sleep 0.2
		if cat "$file" | tee -a "$tempfile" > /dev/null; then
			echo -e "${GREEN}$file distributed${NC}"
		else
			echo -e "${RED}Error while distributing file:\n $* ${NC}"
		fi
	done
}

main() {
	case "$@" in
		*)
			echo -e "${CYAN}Checking if temp folder exists, else creating${NC}"
			temp_file_exists
			echo
			echo -e "${CYAN}Collecting Scripts${NC}"
			sleep 1
			collect_scripts
			;;
	esac
}

# Call the main function with parameter
main "$@"

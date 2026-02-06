#!/bin/bash

generate_name() {
	local BASE_CHARS=$1
	local BASE_LENGTH=$2
	local NAME=''

	if [[ $BASE_LENGTH -le 4 ]]; then
		local FULL_LENGTH=$((4 + $RANDOM % (10 - 4 + 1)))
	else
		local FULL_LENGTH=$((BASE_LENGTH + $RANDOM % (10 - BASE_LENGTH + 1)))
	fi

	local SPACE_FOR_CHARS=$((FULL_LENGTH - BASE_LENGTH))

	if [[ $SPACE_FOR_CHARS -le 0 ]]; then
		NAME="${BASE_CHARS}"
		while [ ${#NAME} -lt 4 ]; do
			NAME="${NAME}${BASE_CHARS:0:1}"
		done
	else
		for (( i=0; i < $BASE_LENGTH; i++ )); do
			if [ $i -eq $((BASE_LENGTH - 1)) ]; then
				local NUMBER_OF_CHARS=$((1 + SPACE_FOR_CHARS))
			else
				if [ $SPACE_FOR_CHARS -eq 0 ]; then
					local NUMBER_OF_CHARS=1
				else
					local NUMBER_OF_CHARS=$((1 + $RANDOM % ($SPACE_FOR_CHARS + 1)))
					SPACE_FOR_CHARS=$((SPACE_FOR_CHARS - ($NUMBER_OF_CHARS - 1)))
				fi
			fi
			local CHAR="${BASE_CHARS:i:1}"
			NAME+=$(printf "%${NUMBER_OF_CHARS}s" | tr ' ' "$CHAR")
		done
	fi
	echo "$NAME"
}

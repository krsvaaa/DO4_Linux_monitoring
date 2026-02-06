#!/bin/bash

FOLDER=$1
N_SUBF=$2
FOLDER_CHARS=$3
N_FILES=$4
NAME_EXT=$5
FILE_SIZE=$6


source ./check.sh "$FOLDER" "$N_SUBF" "$FOLDER_CHARS" "$N_FILES" "$NAME_EXT" "$FILE_SIZE"
source ./name_generator.sh
source ./write_in_log.sh

FILE_SIZE_NUM=$(echo "$FILE_SIZE" | sed 's/kb//')

NAME_F="$(echo "$NAME_EXT" | cut -f1 -d '.')"
EXT="$(echo "$NAME_EXT" | cut -f2 -d '.')"

DATE="$(date +'%d%m%Y')"
FC_LENGTH=${#FOLDER_CHARS}
FILENAME_LENGTH=${#NAME_F}
FULL_FOLDER_PATH=$(pwd)/$FOLDER

mkdir -p "$FULL_FOLDER_PATH"

COUNTER=0
declare -a NEW_FOLDERS

FREE_SPACE=$(df | grep -w "/" | awk '{print $4}')

while [[ "$COUNTER" != "$N_SUBF" ]] &&  (( "$FREE_SPACE" >= 1048576 ));
do
	NAME=$(generate_name "$FOLDER_CHARS" "$FC_LENGTH")
	FULL_NAME="${NAME}_${DATE}"
	if [[ -d "$FULL_FOLDER_PATH/$FULL_NAME" ]]; then
		continue
	else
		COUNTER=$((COUNTER + 1))
		mkdir "$FULL_FOLDER_PATH/$FULL_NAME"
		write_in_log "$FULL_FOLDER_PATH/$FULL_NAME"
		NEW_FOLDERS+=("$FULL_FOLDER_PATH/$FULL_NAME")
		free_space
    	fi
done

for SUBFOLDER in "${NEW_FOLDERS[@]}"; do
	if [[ -d "$SUBFOLDER" ]]; then
		COUNTER=0
		while [[ "$COUNTER" != "$N_FILES" ]] &&  (( "$FREE_SPACE" >= 1048576 )); do
			NAME=$(generate_name "$NAME_F" "$FILENAME_LENGTH")
			FULL_NAME="${NAME}.${EXT}"
			FULL_FILE_PATH="$SUBFOLDER/$FULL_NAME"

			if [[ -f "$FULL_FILE_PATH" ]]; then
				continue
			else
				COUNTER=$((COUNTER + 1))
				dd if=/dev/zero of="$FULL_FILE_PATH" bs=1K count="$FILE_SIZE_NUM" 2>/dev/null

				write_in_log "$FULL_FILE_PATH"
				free_space
			fi
		done
	fi
done

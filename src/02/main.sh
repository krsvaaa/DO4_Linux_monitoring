#!/bin/bash

START=$(date +%s.%N)
START_NORM=$(date '+%d.%m.%y %H:%M:%S')

time_conclusion() {
END=$(date +%s.%N)
EXEC_TIME=$(echo "$END - $START" | bc)
END_NORM=$(date '+%d.%m.%y %H:%M:%S')
EXEC_TIME_ROUNDED=$(printf "%.1f" "$EXEC_TIME")


echo "Start: $START_NORM"
echo "End: $END_NORM"
echo "Execution time(in seconds): $EXEC_TIME_ROUNDED"
}


FOLDER_CHARS=$1
NAME_EXT=$2
FILE_SIZE=$3

source ./check.sh "$FOLDER_CHARS" "$NAME_EXT" "$FILE_SIZE"
source ./name_generator.sh
source ./write_in_log.sh

FILE_SIZE_NUM=$(echo "$FILE_SIZE" | sed 's/Mb//')

NAME_F="$(echo "$NAME_EXT" | cut -f1 -d '.')"
EXT="$(echo "$NAME_EXT" | cut -f2 -d '.')"

DATE="$(date +'%d%m%Y')"
FC_LENGTH=${#FOLDER_CHARS}
FILENAME_LENGTH=${#NAME_F}

N_FOLDERS=$((1 + $RANDOM % 100))	#число папок на рандоме до 100
#N_FOLDERS=30       #можно выделить определенное количество папок
COUNTER=0

declare -a NEW_FOLDERS

FREE_SPACE=$(df | grep -w "/" | awk '{print $4}')
free_space

while [[ "$COUNTER" != "$N_FOLDERS" ]] &&  (( "$FREE_SPACE" >= 1048576 ));
do
	NAME=$(generate_name "$FOLDER_CHARS" "$FC_LENGTH")
	FULL_NAME="${NAME}_${DATE}"
	ROOT_FOLDERS_NUM=$(find / -mindepth 1 -maxdepth 2 -type d \
	-not -path "/bin*" \
	-not -path "/sbin*" \
	-not -path "/proc*" \
	-not -path "/sys*" \
	-not -path "/run*" \
	-not -path "/dev*" \
	-not -path "/boot*" \
	-not -path "/etc*" \
	-not -path "/lib*" \
	-not -path "/lib64*" \
	-not -path "/usr*" \
	| wc -l)

	ROW=$((1 + $RANDOM % ROOT_FOLDERS_NUM))

	ROOT_FOLDER=$(find / -mindepth 1 -maxdepth 2 -type d \
        -not -path "/bin*" \
        -not -path "/sbin*" \
        -not -path "/proc*" \
        -not -path "/sys*" \
        -not -path "/run*" \
        -not -path "/dev*" \
        -not -path "/boot*" \
        -not -path "/etc*" \
        -not -path "/lib*" \
        -not -path "/lib64*" \
        -not -path "/usr*" \
	 | awk -v r="$ROW" 'NR==r {print $1}')

	if [[ -d "$ROOT_FOLDER/$FULL_NAME" ]]; then
		continue
	else
		COUNTER=$((COUNTER + 1))
		mkdir "$ROOT_FOLDER/$FULL_NAME"
		write_in_log "$ROOT_FOLDER/$FULL_NAME"
		NEW_FOLDERS+=("$ROOT_FOLDER/$FULL_NAME")
		free_space
		if [[ $flag -eq 1 ]]; then
			time_conclusion
			exit 1
		fi
    	fi
done

for SUBFOLDER in "${NEW_FOLDERS[@]}"; do
	if [[ -d "$SUBFOLDER" ]]; then
		COUNTER=0
		N_FILES=$((1 + $RANDOM))	#число файлов на рандоме
		#N_FILES=$((1 + $RANDOM % 50))	#на рандоме с ограничением
		#N_FILES=3	#определенное число файлов
		while [[ "$COUNTER" != "$N_FILES" ]] &&  (( "$FREE_SPACE" >= 1048576 )); do

			NAME=$(generate_name "$NAME_F" "$FILENAME_LENGTH")
			FULL_NAME="${NAME}.${EXT}"
			FULL_FILE_PATH="$SUBFOLDER/$FULL_NAME"

			if [[ -f "$FULL_FILE_PATH" ]]; then
				continue
			else
				COUNTER=$((COUNTER + 1))
				dd if=/dev/zero of="$FULL_FILE_PATH" bs=1M count="$FILE_SIZE_NUM" 2>/dev/null

				write_in_log "$FULL_FILE_PATH"
				free_space
				if [[ $flag -eq 1 ]]; then
                        		time_conclusion
                        		exit 1
				fi
                	fi
		done
	fi
done

time_conclusion
time_conclusion >> changes.log

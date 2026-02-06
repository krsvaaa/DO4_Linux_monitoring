#!/bin/bash

FOLDER=$1
N_SUBF=$2
FOLDER_CHARS=$3
N_FILES=$4
NAME_EXT=$5
FILE_SIZE=$6

LOG=error.log

free_space() {
	FREE_SPACE=$(df | grep -w "/" | awk '{print $4}')
	if (( "$FREE_SPACE" < 1048576 )); then
		echo "Only 1GB of space left"
		exit 1
	fi
}


if [[ "$NAME_EXT" != *.* ]]; then
	echo "Filename (5th parameter) must have an extension (have a dot)" >> $LOG
else
	NAME_F="$(echo "$NAME_EXT" | cut -f1 -d '.')"
	EXT="$(echo "$NAME_EXT" | cut -f2 -d '.')"

	FILENAME_LENGTH=${#NAME_F}
	FILEEXT_LENGTH=${#EXT}
	if ! [[ $NAME_F =~ $chars ]] || ! [[ $EXT =~ $chars ]]; then
		echo "The 5th parameter (file name and extension) must have letters only" >> $LOG
	fi

fi

FC_LENGTH=${#FOLDER_CHARS}

num='^[0-9]+$'
chars='^[a-zA-Z]+$'

if ! [[ $N_SUBF =~ $num ]]; then
	echo "The 2nd parameter (number of folders) must be a number" >> $LOG
fi

if ! [[ $FOLDER_CHARS =~ $chars ]]; then
	echo "The 3rd parameter (list of chars for folder names) must only contain letters" >> $LOG
fi

if (( FC_LENGTH > 7 )); then
	echo "Character list for folder name must be 7 chars max" >> $LOG
fi

if ! [[ $N_FILES =~ $num ]]; then
	echo "The 4th parameter (number of files) must be a number" >> $LOG
fi


if [[ $FILENAME_LENGTH > 7 ]]; then
	echo "Character list for file name must be 7 chars max" >> $LOG
fi

if [[ $FILEEXT_LENGTH > 3 ]]; then
	echo "File extension must be 3 characters max" >> $LOG
fi

if [[ ! "$FILE_SIZE" =~ ^[0-9]+kb$ ]]; then
	echo "The 6th parameter (file size) must be a number followed by 'kb'" >> $LOG
fi

FILE_SIZE_NUM=$(echo "$FILE_SIZE" | sed 's/kb//')
if (( FILE_SIZE_NUM > 100 )); then
	echo "The 6th parameter (file size) must be 100kb max" >> $LOG
fi

if [[ -f $LOG ]]; then
	cat $LOG
	rm $LOG
	exit 1
fi

if ! [[ -d "$FOLDER" ]]; then
	read -p "This folder doesn't exist. Create a new folder? Y/n  " answer
	if [ "$answer" = "Y" ] || [ "$answer" = "y" ]; then
		mkdir -p "$FOLDER"
	else
		echo "Folder won't be created and the script will stop"
		exit 1
	fi
fi

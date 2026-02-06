#!/bin/bash

FOLDER_CHARS=$1
NAME_EXT=$2
FILE_SIZE=$3

LOG=error.log

free_space() {
	FREE_SPACE=$(df | grep -w "/" | awk '{print $4}')
	if (( "$FREE_SPACE" < 1048576 )); then
		flag=1
		echo "Only 1GB of space left"
	fi
}

num='^[0-9]+$'
chars='^[a-zA-Z]+$'

if [[ "$NAME_EXT" != *.* ]]; then
	echo "Filename (2nd parameter) must have an extension (have a dot)" >> $LOG
else
	NAME_F="$(echo "$NAME_EXT" | cut -f1 -d '.')"
	EXT="$(echo "$NAME_EXT" | cut -f2 -d '.')"

	FILENAME_LENGTH=${#NAME_F}
	FILEEXT_LENGTH=${#EXT}
	if ! [[ $NAME_F =~ $chars ]] || ! [[ $EXT =~ $chars ]]; then
		echo "The 2nd parameter (file name and extension) must have letters only" >> $LOG
	fi

fi

FC_LENGTH=${#FOLDER_CHARS}

if ! [[ $FOLDER_CHARS =~ $chars ]]; then
	echo "The 1st parameter (list of chars for folder names) must only contain letters" >> $LOG
fi


if [[ $FILENAME_LENGTH > 7 ]]; then
	echo "Character list for file name must be 7 chars max" >> $LOG
fi

if [[ $FILEEXT_LENGTH > 3 ]]; then
	echo "File extension must be 3 characters max" >> $LOG
fi

if [[ ! "$FILE_SIZE" =~ ^[0-9]+Mb$ ]]; then
	echo "The 3d parameter (file size) must be a number followed by 'Mb'" >> $LOG
fi

if [[ -f $LOG ]]; then
	cat $LOG
	rm $LOG
	exit 1
fi

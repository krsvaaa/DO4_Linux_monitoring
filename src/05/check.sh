#!/bin/bash

LOG="error.log"
rm $LOG

if ! ls ../04/log_file_*.log 1> /dev/null 2>&1; then
    echo "No log files found" >> $LOG

fi

if [[ "$#" -ne 1 ]]; then
        echo "Need only 1 parameter" >> $LOG

fi

if [[ -s $LOG ]]; then
	cat $LOG
	exit 1
fi

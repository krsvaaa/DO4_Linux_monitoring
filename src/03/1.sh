#!/bin/bash

LOG="../02/changes.log"
if ! [ -f $LOG ]; then
	echo "No log file found"
	exit 1
fi

awk '{print $1}' $LOG | while read path; do
	if [ -f $path ] || [ -d $path ]; then
	echo "Deleting: $path"
        rm -rf $path
	else
        	echo "Not found: $path"
	fi
done

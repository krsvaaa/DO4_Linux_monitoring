#!/bin/bash

TOOL=$1
if [[ $# != 1 ]]; then
	echo "Need 1 parameter"
	exit 1
fi

if ! [[ $TOOL =~ ^[1-3]$ ]]; then
	echo "Wrong number"
	echo "1 - deleting files by log file"
	echo "2 - deleting files by date and time"
	echo "3 - deleting files by name mask"
	echo "Try again"
	exit 1
fi

case $TOOL in
	1)
		./1.sh
	;;
	2)
		./2.sh
	;;
	3)
		./3.sh
	;;
esac

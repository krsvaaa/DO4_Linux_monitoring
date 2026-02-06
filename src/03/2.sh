#!/bin/bash

LOG="../02/changes.log"
if ! [ -f $LOG ]; then
        echo "No log file found"
        exit 1
fi

check_time() {
	if [[ $1 =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}\ [0-9]{2}:[0-9]{2}$ ]]; then
		return 0
	else
		return 1
	fi
}


while true; do
	read -p "Enter start time (YYYY-MM-DD HH:MM): " start
	if check_time "$start"; then
		break
	else
		echo "Invalid format. Try again"
	fi
done

while true; do
	read -p "Enter end time (YYYY-MM-DD HH:MM): " end
	if check_time "$end"; then
		break
	else
		echo "Invalid format. Try again"
	fi
done


START=$(date -d "$start" +%s)
END=$(date -d "$end" +%s)

awk '{print $1, $2, $3}' "$LOG" | while read path date time; do
	TS=$(date -d "$date $time" +%s 2>/dev/null)
	if [[ $TS -ge $START && $TS -le $END ]]; then
		if [ -f "$path" ] || [ -d "$path" ]; then
			echo "Deleting: $path"
			rm -rf "$path"
		else
			echo "Not found: $path"
		fi
	fi
done

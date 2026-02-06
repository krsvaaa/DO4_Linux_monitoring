#!/bin/bash

log_files="../04/log_file_*.log"

./check.sh "$@" || exit 1

tool=$1

case $tool in
	1)
		awk '{print $0}' $log_files | sort -k9n
	;;

	2)
		awk '{print $1}' $log_files | sort -u
	;;

	3)

		awk '{code=$9; if(code ~ /^[45]/) print $0}' $log_files
        ;;

	4)
		awk '{code=$9; if(code ~ /^[45]/) print $1}' $log_files | sort -u
	;;

	*)
		echo "Parameter must be 1 - 4"
		exit 1
        ;;
esac

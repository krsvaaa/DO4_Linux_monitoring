#!/bin/bash

LOG="changes.log"

write_in_log() {
	local NAME=$1
	local REALPATH=$(realpath $NAME)
	local TIME=$(stat $NAME | grep "Birth" | awk '{print $2 " " $3}' | cut -d . -f1)
	local SIZE=$(stat -c%s $NAME | awk '{print $1/1024}')
	echo "$REALPATH           $TIME     $SIZE" >> changes.log

}

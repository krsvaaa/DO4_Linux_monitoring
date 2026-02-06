#!/bin/bash

read -p "Enter name mask (e.g. abbb_13082025): " mask
if [[ ! "$mask" =~ ^[a-zA-Z0-9]+_[0-9]{8}$ ]]; then
    echo "Wrong format. Use name_DDMMYYYY"
    exit 1
fi

found=$(find / -type d -name "$mask" 2>/dev/null)

if [[ -z "$found" ]]; then
    echo "No folders found"
    exit 1
fi

echo "These folders will be deleted: "$found""

read -p "Continue? (y/n): " confirm
if [[ "$confirm" =~ ^[yY]$ ]]; then
    echo "$found" | xargs rm -rf
    echo "The folders have been deleted"
else
    echo "Deletion cancelled"
fi


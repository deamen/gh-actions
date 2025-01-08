#!/bin/bash

# Validate folder existence
if [ ! -d "$1" ]; then
  echo "Folder $1 does not exist."
  exit 1
fi

# Check each subfolder name against the regex
for subfolder in "$1"/*; do
  if [ -d "$subfolder" ]; then
    folder_name=$(basename "$subfolder")
    if [[ ! "$folder_name" =~ $2 ]]; then
      echo "Folder name $folder_name does not match the regex pattern."
      exit 1
    fi
  fi
done

echo "All folder names match the regex pattern."

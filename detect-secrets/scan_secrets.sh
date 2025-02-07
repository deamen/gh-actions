#!/bin/bash

# Script to check for secrets using detect-secrets

# Check if baseline file is provided
if [ $# -lt 1 ]; then
  echo "Usage: $0 <baseline_file>"
  exit 1
fi

BASELINE_FILE=$1

# Check if the baseline file exists
if [ ! -f "$BASELINE_FILE" ]; then
  echo "Error: Baseline file '$BASELINE_FILE' not found. Please create one first."
  exit 1
fi

TMP_BASELINE_FILE=".secrets.tmp"

# Backup the baseline file to a temporary file
cp "$BASELINE_FILE" "$TMP_BASELINE_FILE"

# Perform the detect-secrets scan
detect-secrets scan --baseline "$TMP_BASELINE_FILE" --exclude-files '.secrets.*' --exclude-files '.git*'

# Function to compare secrets between baseline and temporary file
compare_secrets() {
  diff <(
    jq -r '.results | keys[] as $key | "\($key),\(.[$key] | .[] | .hashed_secret),\(.[$key] | .[] | .line_number)"' "$1" | sort
  ) <(
    jq -r '.results | keys[] as $key | "\($key),\(.[$key] | .[] | .hashed_secret),\(.[$key] | .[] | .line_number)"' "$2" | sort
  ) | grep '^>'
}

# Capture output of the comparison
SCAN_OUTPUT=$(compare_secrets "$BASELINE_FILE" "$TMP_BASELINE_FILE")
# Clean up temporary files
rm "$TMP_BASELINE_FILE"

# Check the results of the scan and handle errors
if [ -n "$SCAN_OUTPUT" ]; then
  echo "Error: Secrets detected:"
  echo "$SCAN_OUTPUT"
  exit 1
else
  echo "No secrets detected."
  exit 0
fi

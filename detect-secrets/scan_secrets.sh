#!/bin/bash

# Check for the existence of the .baseline file
BASELINE_FILE=$1
if [ ! -f "$BASELINE_FILE" ]; then
  echo "Error: .baseline file not found. Please create a baseline file first."
  exit 1
fi

# Run detect-secrets scan with the .baseline file
SCAN_OUTPUT=$(detect-secrets scan --baseline "$BASELINE_FILE")
SCAN_EXIT_CODE=$?

# Handle errors and exit codes as specified
if [ $SCAN_EXIT_CODE -ne 0 ]; then
  echo "Error: Secrets detected by detect-secrets."
  echo "$SCAN_OUTPUT"
  exit 1
fi

echo "No secrets detected."

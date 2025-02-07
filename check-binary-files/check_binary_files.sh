#!/bin/bash

set -euo pipefail

##########################################
## ADVANCED USAGE                       ##
## Scan by BASE & HEAD user inputs      ##
## If BASE == HEAD, exit with error     ##
##########################################
git status >/dev/null  # ensure we are in a git repository
if [ -n "$BASE" ] || [ -n "$HEAD" ]; then
  base_commit=""
  head_commit=""

  if [ -n "$BASE" ]; then
    base_commit=$(git rev-parse "$BASE" 2>/dev/null) || true
  fi
  if [ -n "$HEAD" ]; then
    head_commit=$(git rev-parse "$HEAD" 2>/dev/null) || true
  fi
  if [ "$base_commit" == "$head_commit" ]; then
    echo "::error::BASE and HEAD commits are the same."
    exit 1
  fi
##########################################
## Scan commits based on event type     ##
##########################################
else
  if [ "${GITHUB_EVENT_NAME}" == "push" ]; then
    COMMIT_LENGTH=$(printenv COMMITS | jq length)
    if [ "$COMMIT_LENGTH" == "0" ]; then
      echo "No commits to scan"
      exit 0
    fi
    HEAD=${GITHUB_EVENT_AFTER}
    if [ "${GITHUB_EVENT_BEFORE}" == "0000000000000000000000000000000000000000" ]; then
      BASE=$(git rev-parse "$HEAD~$COMMIT_LENGTH")
    else
      BASE=${GITHUB_EVENT_BEFORE}
    fi
  elif [ "${GITHUB_EVENT_NAME}" == "workflow_dispatch" ] || [ "${GITHUB_EVENT_NAME}" == "schedule" ]; then
    BASE=""
    HEAD=""
  elif [ "${GITHUB_EVENT_NAME}" == "pull_request" ]; then
    BASE=${GITHUB_EVENT_PULL_REQUEST_BASE_SHA}
    HEAD=${GITHUB_EVENT_PULL_REQUEST_HEAD_SHA}
  fi
fi

# Get the list of commits in the push
commits=$(git rev-list "$HEAD" ^"$BASE")

# Check each commit for binary files
binary_files=""
for commit in $commits; do
  files=$(git diff-tree --no-commit-id --name-only --diff-filter=AM -r "$commit")

  if [ -n "$files" ]; then
    for file in $files; do
      if file "$file" | grep -q 'ELF\|PE32\|Mach-O'; then
        binary_files+="$file (in commit $commit)\n"
      fi
    done
  else
    echo "No files detected in commit $commit"
    continue
  fi
done

# Output results
if [ -n "$binary_files" ]; then
  echo "Binary files detected:"
  echo -e "$binary_files"
  echo "binary_files=$binary_files" >> $GITHUB_OUTPUT
  exit 1
else
  echo "No binary files detected."
fi

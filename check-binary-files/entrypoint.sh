#!/bin/sh -l

# Trust the GitHub Actions workspace directory
git config --global --add safe.directory /github/workspace

# Initialize an empty variable to store binary file names
binary_files=""

# Get the list of commits in the push
commits=$(git rev-list "$2" ^"$1")

# Check each commit for binary files
for commit in $commits; do
  files=$(git diff-tree --no-commit-id --name-only --diff-filter=AM -r $commit)
  
  if [ -n "$files" ]; then
    for file in $files; do
      if file "$file" | grep -q 'ELF\|PE32\|Mach-O'; then
        binary_files="$binary_files$file (in commit $commit)\n"
      fi
    done
  else
    echo "No files detected in commit $commit"
    exit 1
  fi
done

# Set the output variable if binary files were detected
if [ -n "$binary_files" ]; then
  echo "Binary files detected:"
  echo -e "$binary_files"
  echo "::set-output name=binary_files::$binary_files"
  exit 1
else
  echo "No binary files detected."
fi

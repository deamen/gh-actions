# Check Folder Name Action

This action validates folder names against a regex pattern.

## Inputs

### `folder`

**Required** The directory containing subfolders to validate.

### `regex`

**Required** The regex pattern to match folder names against.

## Example usage

```yaml
name: Validate Folder Names

on: [push]

jobs:
  validate-folders:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Run check-folder-name action
      uses: ./check-folder-name
      with:
        folder: 'path/to/folder'
        regex: '^[a-zA-Z0-9_-]+$'
```

## Validation

- Ensures the folder exists.
- Checks each subfolder name against the regex.

## Failure

- If any folder name doesn’t match, the action exits with code 1 and outputs an appropriate message.

# Detect Secrets Action

This action runs yelp/detect-secrets to scan for secrets in the repository.

## Inputs

### `baseline-file`

**Required** The path to the .baseline file.

## Example usage

```yaml
name: Detect Secrets

on: [push, pull_request]

jobs:
  detect-secrets:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Run detect-secrets action
      uses: deamen/gh-actions/detect-secrets@master # or sha of the commitzs
      with:
        baseline-file: '.secrets.baseline'
```

## Outputs

None

## Error Handling

- If the .baseline file does not exist, the action exits with code 1 and outputs an error message.
- If secrets are detected, the action exits with code 1 and outputs the sorted detect-secrets message in format `> filename,hashed_secret,line_number`.

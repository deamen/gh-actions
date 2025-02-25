# setup-qemu-static Action

This action installs qemu-static related packages and enables targets based on the `targets` input variable.

## Inputs

### `targets`

**Optional** A list of targets to enable. Default is an empty string.

## Example usage

```yaml
name: Setup QEMU Static

on: [push, pull_request]

jobs:
  setup-qemu-static:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Run setup-qemu-static action
      uses: deamen/gh-actions/setup-qemu-static@main
      with:
        targets: 'aarch64 arm'
```

## Functionality

- Installs qemu-static related packages.
- Enables the specified targets based on the `targets` input variable.

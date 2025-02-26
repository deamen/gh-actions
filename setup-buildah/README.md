# setup-buildah Action

This action installs buildah related packages based on the operating system.

## Inputs

### `os`

**Required** The operating system for which to install buildah. Possible values are `ubuntu`, `fedora`, and `rhel`.

## Example usage

```yaml
name: Setup Buildah

on: [push, pull_request]

jobs:
  setup-buildah:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Run setup-buildah action
      uses: ./setup-buildah
      with:
        os: 'ubuntu'
```

## Functionality

- Installs buildah related packages based on the specified operating system.
- For Ubuntu and Fedora, installs `buildah` and `qemu-user-static`.
- For RHEL, installs only `buildah`.

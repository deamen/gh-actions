Example:
```yaml
  name: Check for Binary Files

  on:
    push:
      branches:
        - master
    pull_request:
      branches:
        - master

  jobs:
    check-binary-files:
      runs-on: ubuntu-latest

      steps:
      - name: Checkout code
        uses: actions/checkout@v4.1.7

      - name: Run check-binary-files action
        uses: deamen/gh-actions/check-binary-files@v1.0.0
        with:
          base-ref: ${{ github.event.before }}
          head-ref: ${{ github.sha }}

      - name: Report result
        if: success() || failure()
        run: |
          if [ -n "${{ steps.check-binary-files.outputs.binary_files }}" ]; then
            echo "Workflow failed due to binary files in the commit history:"
            echo "${{ steps.check-binary-files.outputs.binary_files }}"
          else
            echo "No binary files detected."
          fi
```


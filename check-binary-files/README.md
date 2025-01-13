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
        uses: actions/checkout@v3

      - name: Set environment variables
        shell: bash
        run: |
          if [ "${{ github.event_name }}" == "push" ]; then
            echo "depth=$(($(jq length <<< '${{ toJson(github.event.commits) }}') + 2))" >> $GITHUB_ENV
            echo "branch=${{ github.ref_name }}" >> $GITHUB_ENV
          fi
          if [ "${{ github.event_name }}" == "pull_request" ]; then
            echo "depth=$((${{ github.event.pull_request.commits }}+2))" >> $GITHUB_ENV
            echo "branch=${{ github.event.pull_request.head.ref }}" >> $GITHUB_ENV
          fi

      - name: Checkout code with specified depth
        uses: actions/checkout@v3
        with:
          ref: ${{env.branch}}
          fetch-depth: ${{env.depth}}

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

## Inputs

### `base-ref`

**Required** The base reference to compare with.

### `head-ref`

**Required** The head reference to compare with.

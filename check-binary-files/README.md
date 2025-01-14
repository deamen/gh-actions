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
        uses: actions/checkout@v4
        fetch-depth: 0

      - name: Run check-binary-files action
        uses: deamen/gh-actions/check-binary-files@main


```

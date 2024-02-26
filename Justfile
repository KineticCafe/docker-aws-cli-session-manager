AWS_CLI_VERSION := '2.15.23'

# Build the image
build:
  #!/usr/bin/env bash

  set -euo pipefail

  docker buildx build \
    --tag kineticcafe/aws-cli-session-manager:{{ AWS_CLI_VERSION }} \
    .

update-base-image:
  @ruby support/version_update.rb {{ AWS_CLI_VERSION }}

tag:
  @git tag {{ AWS_CLI_VERSION }}

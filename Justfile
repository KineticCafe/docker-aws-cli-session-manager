AWS_CLI_VERSION := '2.17.42'

# Build the image
build:
    #!/usr/bin/env bash

    set -euo pipefail

    docker buildx build \
      --tag kineticcafe/aws-cli-session-manager:{{ AWS_CLI_VERSION }} \
      .

# Show the current AWS CLI version
current-version:
    @echo {{ AWS_CLI_VERSION }}

# Update the AWS CLI version to the latest base image available
update-base-image:
    @ruby support/version_update.rb {{ AWS_CLI_VERSION }}

# Tag the repo with the current AWS CLI version
tag:
    @git tag {{ AWS_CLI_VERSION }}

# syntax=docker/dockerfile:1

ARG AWS_CLI_VERSION=2.15.23

FROM amazon/aws-cli:${AWS_CLI_VERSION}

ARG BUILDPLATFORM
ARG TARGETPLATFORM

RUN <<SCRIPT
case "${TARGETPLATFORM}" in
linux/amd64)
  yum install -y https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm
  ;;
linux/arm64)
  yum install -y https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_arm64/session-manager-plugin.rpm
  ;;
esac
SCRIPT

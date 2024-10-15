# [ghcr.io/]kineticcafe/aws-cli-session-manager: AWS CLI v2 with Session Manager

This is a minimal extension to [amazon/aws-cli][] that includes the [Session
Manager plugin][] for AWS CLI. If Amazon starts including image versions with
the session manager plugin included, this image will be discontinued.

These images can be pulled either from Docker Hub
(`kineticcafe/aws-cli-session-manager:2.18.6`) or GitHub Container Registry
(`ghcr.io/kineticcafe/aws-cli-session-manager:2.18.6`).

## `aws-cli-session-manager` script

The `aws-cli-session-manager` script is recommended to be installed in your
`$PATH` as `aws` and `aws_completer`, allowing you to run the AWS CLI as if you
had the native installation on your system, including the use of the AWS command
completer.

It will pull from `ghcr.io/kineticcafe/aws-cli-session-manager:2.18.6` by
default. The version can be overridden by specifying `AWS_CLI_VERSION` and the
image can be overridden entirely by specifying `IMAGE`:

```sh
$ AWS_CLI_VERSION=2.18.6 ./aws-cli-session-manager --version
$ IMAGE=kineticcafe/aws-cli-session-manager:latest ./aws-cli-session-manager --version
```

This script attempts to be intelligent about enabling TTY and interactive
support for the image run, but non-interactive mode can be forced with
`--non-interactive`. Interactive mode with TTY support can be forced with
`--force-tty`, which will fail if standard input is not attached to a TTY.

A bash shell inside the Docker container will be started with the special
command `aws shell` or `aws sh`.

By default, `~/.aws`, `${AWS_CONFIG_FILE}`, and `${AWS_SHARED_CREDENTIALS_FILE}`
will be mounted `readonly` unless the `configure` command is used or unless
`--read-write` is passed.

Certain features such as `--ca-bundle` and `AWS_WEB_IDENTITY_TOKEN_FILE` may not
work correctly because of the interaction between Docker and the host file
system. Pull requests will be considered for issues relating to these files.

### Installing `aws-cli-session-manager`

`aws-cli-session-manager` can be installed with symlinks using the `install`
script:

```sh
curl -sSL --fail \
  https://raw.githubusercontent.com/KineticCafe/docker-aws-cli-session-manager/main/install |
  bash -s -- ~/.local/bin
```

Replace `~/.local/bin` with your preferred binary directory.

By default, it will download `aws-cli-session-manager` from GitHub and install
it in the provided `TARGET` and make symbolic links for `aws` and
`aws_completer`. Symbolic link creation will not overwrite files or symbolic
links to locations _other_ than `TARGET/aws-cli-session-manager`.

`--no-symlinks` (`-S`) may be specified to skip symbolic link creation entirely.

`--force` (`-f`) may be specified to install `kinetic-ansible` even if it already
exists, and to overwrite files and non-`TARGET/kinetic-ansible` symbolic links.

`--verbose` (`-v`) will turn on trace output of commands.

[amazon/aws-cli]: https://hub.docker.com/r/amazon/aws-cli
[session manager plugin]: https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html

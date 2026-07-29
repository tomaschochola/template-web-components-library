# syntax=docker/dockerfile:1

FROM mcr.microsoft.com/devcontainers/typescript-node:24-trixie AS versioneddevcontainer

FROM versioneddevcontainer AS devcontainer
WORKDIR /workspaces
RUN <<EOF
  set -euo pipefail
  export DEBIAN_FRONTEND=noninteractive
  apt-get update -y
  apt-get upgrade -y --no-install-recommends
  apt-get install -y --no-install-recommends ca-certificates curl wget build-essential git zip unzip
  install -d -o node -g node /home/node/.npm
  apt-get autoremove -y
  apt-get autoclean -y
  apt-get clean -y
  rm -rf /var/lib/apt/lists/*
EOF

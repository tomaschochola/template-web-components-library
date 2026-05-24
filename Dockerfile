# syntax=docker/dockerfile:1

FROM mcr.microsoft.com/devcontainers/typescript-node:24-trixie AS versioneddevcontainer

FROM versioneddevcontainer AS devcontainer
WORKDIR /workspaces
ENV APP_ENV=local
ENV APP_VERSION=dev
ENV NODE_ENV=development
ADD --chmod=755 https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 /usr/local/bin/yq
RUN <<EOF
  set -euo pipefail
  apt-get update -y
  apt-get upgrade -y --no-install-recommends
  apt-get install -y --no-install-recommends ca-certificates curl wget build-essential git zip unzip icoutils
  npm install -g svgo@latest sharp-cli@latest
  install -d -o node -g node /home/node/.npm
  wget https://github.com/linebender/resvg/releases/latest/download/resvg-linux-x86_64.tar.gz -O /tmp/resvg.tar.gz
  tar -xf /tmp/resvg.tar.gz -C /usr/local/bin resvg
  rm /tmp/resvg.tar.gz
  chmod +x /usr/local/bin/resvg
  apt-get autoremove -y
  apt-get autoclean -y
  apt-get clean -y
  rm -rf /var/lib/apt/lists/*
EOF
USER node
RUN <<EOF
  set -euo pipefail
  npm exec --ignore-scripts -- playwright install --with-deps
EOF

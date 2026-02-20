#!/usr/bin/env bash
set -euo pipefail

USER_NAME=$(whoami);
HOST_NAME=$(uname -n);
NYXTRA_ROOT_DIR=$(cd "$(dirname "$0")" && pwd)

export NYXTRA_ROOT_DIR USER_NAME HOST_NAME
export PATH="$NYXTRA_ROOT_DIR/bin:$PATH"

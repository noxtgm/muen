#!/bin/bash

export REPO_AUTHOR="${REPO_AUTHOR:-noxtgm}"
export REPO_NAME="${REPO_NAME:-muen}"
export REPO_BRANCH="${REPO_BRANCH:-main}"
export REPO_URL="https://github.com/${REPO_AUTHOR}/${REPO_NAME}.git"
export REPO_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export REPO_LIB="${REPO_PATH}/lib"

export STATE_PATH="${XDG_STATE_HOME:-$HOME/.local/state}/${REPO_NAME}"
export LOG_FILE="${STATE_PATH}/${REPO_NAME}.log"

source "${REPO_LIB}/colors.sh"
source "${REPO_LIB}/logging.sh"
source "${REPO_LIB}/preflight.sh"
source "${REPO_LIB}/sudo.sh"
source "${REPO_LIB}/packages.sh"

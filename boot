#! /usr/bin/env bash
set -e
# Script to set up straight from git repository

NYXTRA_HOME="$HOME/.local/share/nyxtra"
REPO_URL="https://github.com/gintsperkons/nyxtra.git"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


echo "🧠 Nyxtra boot starting from $SCRIPT_DIR"

# ------------------------------------------------
# Determine environment type
# ------------------------------------------------

if [[ -L "$NYXTRA_HOME" ]]; then
    # Case ① Symlink → Dev
    NYXTRA_MODE="dev"
elif [[ -d "$NYXTRA_HOME/.git" ]]; then
    # Case ② Installed
    NYXTRA_MODE="installed"
elif [[  "$NYXTRA_HOME" != "$SCRIPT_DIR"  && -d "$SCRIPT_DIR/.git" ]]; then
    # Case ④ Detached Dev (has git repo, no symlink)
    NYXTRA_MODE="detached"
else
    # Case ③ Fresh (wget or first run)
    NYXTRA_MODE="clean"
fi

echo "🔍 Detected nyxtra mode: $NYXTRA_MODE"
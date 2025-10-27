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



sudo pacman -Syu git --noconfirm --needed

# ------------------------------------------------
# Act based on environment
# ------------------------------------------------

case "$NYXTRA_MODE" in
    dev)
        echo "🔗 Developer symlink active: $NYXTRA_HOME → $(readlink "$NYXTRA_HOME")"
        bash "$NYXTRA_HOME/setup" $@
        ;;

    installed)
        echo "📦 Pulling updates..."
        git -C "$NYXTRA_HOME" pull --ff-only || echo "⚠️ Git pull failed, continuing..."
        bash "$NYXTRA_HOME/setup" $@
        ;;

    detached)
        echo "🧰 Detached development repo detected."
        echo "→ Linking $SCRIPT_DIR to $NYXTRA_HOME"
        ln -sf "$SCRIPT_DIR" "$NYXTRA_HOME"
        echo "✅ Symlink created."
        bash "$NYXTRA_HOME/setup" $@
        ;;

    clean)
        echo "🌱 Cloning Nyxtra fresh into $NYXTRA_HOME..."
        git clone "$REPO_URL" "$NYXTRA_HOME"
        bash "$NYXTRA_HOME/setup" $@
        ;;
esac

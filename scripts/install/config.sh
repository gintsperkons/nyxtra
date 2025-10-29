
#!/usr/bin/env bash
set -e

# Directory containing all PKGBUILD subdirectories
NYXTRA_CONFIG="$NYXTRA_HOME/configs"

declare -a CONFIG_FOLDERS=(
    "hypr"
    "ly"
    "nvim"
    "zsh"
    "BraveSoftware"
    "quickshell"
)


#Cpy folders
for folder in "${CONFIG_FOLDERS[@]}"; do
    SRC="$NYXTRA_CONFIG/$folder/"
    DEST="$HOME/.config/$folder/"

    echo "📁 Copying $SRC to $DEST"
    mkdir -p "$DEST"
    cp -r  "$SRC"* "$DEST"
done

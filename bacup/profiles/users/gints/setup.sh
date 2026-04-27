#!/usr/bin/env bash
set -euo pipefail



case "$1" in
    pre)
        source "$NYXTRA_ROOT_DIR/lib/functions/copy_configs.sh"
        copy_file "$NYXTRA_ROOT_DIR/profiles/users/defaults/.zshrc" "$HOME/.zshrc"
        copy_file "$NYXTRA_ROOT_DIR/profiles/users/defaults/pacman.conf" "/etc/pacman.conf" "sudo"

        ;;
    install)
                ;;
    post)
        echo "post setup"



        NYXTRA_CONFIG="$NYXTRA_ROOT_DIR/dotfiles"

        declare -a CONFIG_FOLDERS=(
            "hypr"
            "ly"
            "nvim"
            "zsh"
            "fish"
            "niri"
            "waybar"
        )
        source "$NYXTRA_ROOT_DIR/lib/functions/copy_configs.sh"

        # Perform layered per-file copy for each config folder.
        device="$HOST_NAME"
        for folder in "${CONFIG_FOLDERS[@]}"; do
            echo "→ Processing folder: $folder"
            copy_config_folder_layered "$NYXTRA_CONFIG" "$HOME/.config" "$device" "gints" "$folder"
        done

        ;;
esac
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



        NYXTRA_CONFIG="$NYXTRA_ROOT_DIR/configs"

        declare -a CONFIG_FOLDERS=(
            "hypr"
            "ly"
            "nvim"
            "zsh"
            "fish"
            "niri"
        )
        source "$NYXTRA_ROOT_DIR/lib/functions/copy_configs.sh"
        copy_config_folders "$NYXTRA_CONFIG/gints" "$HOME/.config" "${CONFIG_FOLDERS[@]}"

        ;;
esac
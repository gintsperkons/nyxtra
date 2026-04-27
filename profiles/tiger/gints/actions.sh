#!/usr/bin/env bash
set -euo pipefail

task_post_configs_copy() {
    echo "Copying config folders..."

        NYXTRA_CONFIG="$NYXTRA_ROOT_DIR/dotfiles"

        declare -a CONFIG_FOLDERS=(
            "hypr"
            "ly"
            "nvim"
            "zsh"
            "fish"
            "niri"
            "waybar"
            "wireplumber"
        )
        source "$NYXTRA_ROOT_DIR/lib/functions/copy_configs.sh"

        # Perform layered per-file copy for each config folder.
        device="$HOST_NAME"
        for folder in "${CONFIG_FOLDERS[@]}"; do
            echo "→ Processing folder: $folder"
            copy_config_folder_layered "$NYXTRA_CONFIG" "$HOME/.config" "$device" "gints" "$folder"
        done

        
}

task_post_services_start() {
    echo "Starting services..."
}
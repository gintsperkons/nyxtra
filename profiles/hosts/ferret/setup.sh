#!/usr/bin/env bash
set -euo pipefail



case "$1" in
    pre)
        source "$NYXTRA_ROOT_DIR/lib/functions/copy_configs.sh"
        copy_file "$NYXTRA_ROOT_DIR/profiles/users/defaults/.zshrc" "$HOME/.zshrc"
        copy_file "$NYXTRA_ROOT_DIR/profiles/users/defaults/pacman.conf" "/etc/pacman.conf" "sudo"


        source "$NYXTRA_ROOT_DIR/lib/install/paru.sh"
        if command -v paru &> /dev/null; then
            echo "Paru already installed, skipping"
        else
            install_paru
        fi
        ;;
    install)
        # Ensure NYXTRA_HOME defaults to repository root if not set
        : "${NYXTRA_HOME:=${NYXTRA_ROOT_DIR}}"

        # Location of local PKGBUILDs
        PKG_DIR="$NYXTRA_HOME/profiles/pkgbuilds"

        # Ordered list of local packages to build/install
        ORDER=(
            "nyxtra-basic"
            "nyxtra-login"
            "nyxtra-niri"
            "nyxtra-terminal"
            "nyxtra-network"
            "nyxtra-nvim"
            "nyxtra-audio"
            "nyxtra-gaming"
            "nyxtra-gamedev"
            "nyxtra-filemanager"
            "nyxtra-webdev"
        )

        # Detect GPU and append appropriate package
        gpu_info=$(lspci | grep -i VGA || true)
        if [[ $gpu_info == *"NVIDIA"* ]]; then
                ORDER+=("nyxtra-gpu-nvidia")
        elif [[ $gpu_info == *"AMD/ATI"* ]]; then
                ORDER+=("nyxtra-gpu-amd")
        elif [[ $gpu_info == *"Intel"* ]]; then
                ORDER+=("nyxtra-gpu-intel")
        fi

        # AUR packages
        AUR_PKG=(
            "brave-bin"
            "zen-browser-bin"
            "visual-studio-code-bin"
            "sourcegit-bin"
            "elephant-all-bin"
            "walker-bin"
            "eww"
        )

        # Web apps to install
        declare -A WEB_APPS=(
            ["YouTube"]="https://www.youtube.com"
            ["ClickUp"]="https://app.clickup.com"
            ["Twitch"]="https://www.twitch.tv"
        )

        # Source the phase implementations and run them in order
        source "$NYXTRA_ROOT_DIR/lib/install/install_phases.sh"

        phase_build_local_packages "$PKG_DIR" ORDER PKG_FILES
        phase_install_local_packages PKG_FILES
        phase_install_aur_packages AUR_PKG
        phase_install_webapps "$NYXTRA_HOME" WEB_APPS




        source "$NYXTRA_ROOT_DIR/lib/install/vulkanSDK.sh"
        if command -v vulkaninfo &> /dev/null; then
            echo "Vulkan SDK already installed, skipping"
        else
            install_vulkansdk
        fi

        ;;
    post)
        echo "post setup"


        ;;
esac
#!/usr/bin/env bash
set -e


PKG_DIR="$NYXTRA_HOME/scripts/install/pkgbuilds"

# Ordered list of local packages
ORDER=(
  "nyxtra-basic" 
  "nyxtra-login" 
  "nyxtra-hyprland" 
  "nyxtra-terminal" 
  "nyxtra-network" 
  "nyxtra-nvim"
  "nyxtra-audio"
  "nyxtra-gaming"
  "nyxtra-gamedev"
)


# Detect GPU
gpu_info=$(lspci | grep -i VGA)

if [[ $gpu_info == *"[NVIDIA]"* ]]; then
    ORDER+=("nyxtra-gpu-nvidia")
elif [[ $gpu_info == *"[AMD/ATI]"* ]]; then
    ORDER+=("nyxtra-gpu-amd")
elif [[ $gpu_info == *"[Intel]"* ]]; then
    ORDER+=("nyxtra-gpu-intel")
fi


AUR_PKG=(
  "brave-bin"
  "visual-studio-code-bin"
  "quickshell-git"
)

declare -A WEB_APPS=(
  ["YouTube"]="https://www.youtube.com"
  ["ClickUp"]="https://app.clickup.com"
  ["Twitch"]="https://www.twitch.tv"
)

# -------------------------
# Phase functions
# -------------------------

phase_paru() {
    echo "🛠 Installing base-devel, git, and paru..."
    sudo pacman -S --noconfirm --needed git base-devel
    bash "$NYXTRA_HOME/scripts/data/packages/paru/install.sh"
}

phase_build_local_packages() {
    echo "🔧 Building local packages..."
    PKG_FILES=()
    for pkg in "${ORDER[@]}"; do
        dir="$PKG_DIR/$pkg"
        if [[ -f "$dir/PKGBUILD" ]]; then
            echo "  - Building package: $pkg"
            (cd "$dir" && makepkg -sf --noconfirm)
            PKG_FILES+=("$dir"/*.pkg.tar.zst)
        else
            echo "  ⚠️ PKGBUILD not found in $dir, skipping"
        fi
    done
}

phase_install_local_packages() {
    if [[ ${#PKG_FILES[@]} -gt 0 ]]; then
        echo "🚀 Installing local packages..."
        sudo pacman -U "${PKG_FILES[@]}" --noconfirm
    fi
}

phase_install_aur_packages() {
    if [[ ${#AUR_PKG[@]} -gt 0 ]]; then
        echo "🚀 Installing AUR packages..."
        paru -S "${AUR_PKG[@]}" --needed --noconfirm
    fi
}

phase_install_webapps() {
    echo "🌐 Installing WebApps..."
    for name in "${!WEB_APPS[@]}"; do
        url="${WEB_APPS[$name]}"
        "$NYXTRA_HOME/bin/nyxtra-webapp-install" "$name" "$url"
    done
    update-desktop-database ~/.local/share/applications
}

# -------------------------
# Main script
# -------------------------

if [[ $1 == "webapps" ]]; then
    phase_install_webapps
    exit 0
fi


if [[ $1 == "paru" ]]; then
    phase_paru
    exit 0
fi


if [[ $1 == "build" ]]; then
    phase_build_local_packages
    exit 0
fi


if [[ $1 == "local" ]]; then
    phase_install_local_packages
    exit 0
fi


if [[ $1 == "aur" ]]; then
    phase_install_aur_packages
    exit 0
fi

phase_paru
phase_build_local_packages
phase_install_local_packages
phase_install_aur_packages
phase_install_webapps

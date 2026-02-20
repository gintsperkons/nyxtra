#!/usr/bin/env bash

set -euo pipefail


phase_build_local_packages() {
    # Usage: phase_build_local_packages PKG_DIR ORDER_ARRAY_NAME PKG_FILES_ARRAY_NAME
    # Falls back to PKG_DIR, ORDER and PKG_FILES globals when args omitted.
    local pkg_dir="${1:-${PKG_DIR:-}}"
    local order_name="${2:-ORDER}"
    local pkg_files_name="${3:-PKG_FILES}"

    declare -n order_ref="$order_name"
    declare -g -a "$pkg_files_name"
    declare -n pkg_files_ref="$pkg_files_name"
    echo "🔧 Building local packages..."
    pkg_files_ref=()

    for pkg in "${order_ref[@]}"; do
        dir="$pkg_dir/$pkg"
        if [[ -f "$dir/PKGBUILD" ]]; then
            echo "  - Building package: $pkg"
            (cd "$dir" && makepkg -sf --noconfirm)
            pkg_files_ref+=("$dir"/*.pkg.tar.zst)
        else
            echo "  ⚠️ PKGBUILD not found in $dir, skipping"
        fi
    done
}

phase_install_local_packages() {
    # Usage: phase_install_local_packages PKG_FILES_ARRAY_NAME
    local pkg_files_name="${1:-PKG_FILES}"
    declare -n pkg_files_ref="$pkg_files_name"
    if [[ ${#pkg_files_ref[@]} -gt 0 ]]; then
        echo "🚀 Installing local packages..."
        sudo pacman -U "${pkg_files_ref[@]}" --noconfirm
    else
        echo "No local packages to install"
    fi
}

phase_install_aur_packages() {
    # Usage: phase_install_aur_packages AUR_ARRAY_NAME
    local aur_name="${1:-AUR_PKG}"
    declare -n aur_ref="$aur_name"
    if [[ ${#aur_ref[@]} -gt 0 ]]; then
        echo "🚀 Installing AUR packages..."
        paru -S "${aur_ref[@]}" --needed --noconfirm
    else
        echo "No AUR packages configured"
    fi
}

phase_install_webapps() {
    # Usage: phase_install_webapps NYXTRA_HOME WEB_APPS_ASSOC_NAME
    local nyxtra_home="${1:-${NYXTRA_HOME:-}}"
    local webapps_name="${2:-WEB_APPS}"
    declare -n webapps_ref="$webapps_name"

    echo "🌐 Installing WebApps..."
    mkdir -p "$HOME/.local/share/applications"
    if declare -p "$webapps_name" >/dev/null 2>&1; then
        for name in "${!webapps_ref[@]}"; do
            url="${webapps_ref[$name]}"
            "$nyxtra_home/bin/nyxtra-webapp-install" "$name" "$url"
        done
        update-desktop-database ~/.local/share/applications || true
    else
        echo "No WEB_APPS associative array found; skipping webapps"
    fi
}

export -f phase_paru phase_build_local_packages phase_install_local_packages phase_install_aur_packages phase_install_webapps 2>/dev/null || true

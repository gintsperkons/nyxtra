#!/usr/bin/env bash

set -euo pipefail


install_paru() {
    if command -v paru &>/dev/null; then
        echo "paru is already installed"
        return 0
    fi

    echo "paru not found — installing..."
    sudo pacman -S --needed --noconfirm base-devel git

    local tempdir
    tempdir="$(mktemp -d)"

    # Ensure we clean up the tempdir on exit/error
    trap 'rm -rf "${tempdir}"' EXIT

    git clone https://aur.archlinux.org/paru.git "${tempdir}"
    pushd "${tempdir}" >/dev/null
    makepkg -si --noconfirm
    popd >/dev/null

    # Cleanup done by trap
    trap - EXIT

    echo "paru installed successfully!"
}

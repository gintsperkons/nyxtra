
#!/usr/bin/env bash
set -e

# Directory containing all PKGBUILD subdirectories
PKG_DIR="$NYXTRA_HOME/scripts/install/pkgbuilds"

# List packages in the order you want to build/install
ORDER=(
    "nyxtra-basic"
    "nyxtra-login"
    "nyxtra-hyprland"
    "nyxtra-terminal"
    "nyxtra-network"
)

# Ensure makepkg exists
if ! command -v makepkg >/dev/null 2>&1; then
    sudo pacman -S --noconfirm --needed base-devel
fi

# Build and install packages in order
for pkg in "${ORDER[@]}"; do
    dir="$PKG_DIR/$pkg"
    if [[ -f "$dir/PKGBUILD" ]]; then
        echo "🔧 Building and installing package: $pkg"
        (cd "$dir" && makepkg -sfi --noconfirm)
    else
        echo "⚠️ PKGBUILD not found in $dir, skipping"
    fi
done

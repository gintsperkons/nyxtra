#!/usr/bin/env bash
set -e



# Step 0: Paru
sudo pacman -S --noconfirm --needed git base-devel
bash $NYXTRA_HOME/scripts/data/packages/paru/install.sh



PKG_DIR="$NYXTRA_HOME/scripts/install/pkgbuilds"
ORDER=(
  "nyxtra-basic" 
  "nyxtra-login" 
  "nyxtra-hyprland" 
  "nyxtra-terminal" 
  "nyxtra-network" 
  "nyxtra-nvim"
)



# Step 1: Build packages in order (no install)
PKG_FILES=()
for pkg in "${ORDER[@]}"; do
    dir="$PKG_DIR/$pkg"
    if [[ -f "$dir/PKGBUILD" ]]; then
        echo "🔧 Building package: $pkg"
        (cd "$dir" && makepkg -sf --noconfirm)
        PKG_FILES+=("$dir"/*.pkg.tar.zst)  # store built package path
    else
        echo "⚠️ PKGBUILD not found in $dir, skipping"
    fi
done

# Step 2: Install all built packages in one transaction
if [[ ${#PKG_FILES[@]} -gt 0 ]]; then
    echo "🚀 Installing all packages in order..."
    sudo pacman -U "${PKG_FILES[@]}" --noconfirm
fi


AUR_PKG=(
  "brave-bin"
)
# Step 3: Install all built packages in one transaction
if [[ ${#AUR_PKG[@]} -gt 0 ]]; then
    echo "🚀 Installing all aur packages in order..."
    paru -S "${AUR_PKG[@]}" --needed --noconfirm
fi

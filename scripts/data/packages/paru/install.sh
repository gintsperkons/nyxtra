#!/bin/bash

set -e

if command -v paru &>/dev/null; then
  echo "paru is alrea installed"
  exit 0
fi
echo "paru not found Installing ..."
 sudo pacman -S --needed base-devel git

 tempdir="$(mktemp -d)"
 git clone https://aur.archlinux.org/paru.git "$tempdir"
 cd "$tempdir" 
 makepkg -si --noconfirm

 cd -
 rm -rf "$tempdir"

 echo "paru installed successfully!"

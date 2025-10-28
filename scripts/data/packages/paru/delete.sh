#!/bin/bash

set -e

if ! command -v paru &>/dev/null; then
  exit 0
fi

sudo pacman -Rns paru --noconfirm

rm -rf ~/.config/paru
rm -rf ~/.cache/paru

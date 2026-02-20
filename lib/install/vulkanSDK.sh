#!/usr/bin/env bash
set -euo pipefail

# Minimal helper to install the Vulkan SDK. This file exports a function
# `install_vulkansdk` when sourced. When executed directly it will call the
# function with any provided arguments.

# Defaults
VULKAN_VERSION_DEFAULT="1.4.341.1"
INSTALL_DIR_DEFAULT="$HOME/.local/share/tools/vulkan/"

install_vulkansdk() {
	local version="${1:-$VULKAN_VERSION_DEFAULT}"
	local install_dir="${2:-$INSTALL_DIR_DEFAULT}"
	local archive="vulkansdk-linux-x86_64-${version}.tar.xz"
	local url="https://sdk.lunarg.com/sdk/download/${version}/linux/${archive}"

	echo "Downloading Vulkan SDK ${version}..."
	wget -q --show-progress -O "${archive}" "${url}"

	echo "Extracting..."
	mkdir -p "${install_dir}"
	tar -xf "${archive}" -C "${install_dir}" --strip-components=1

	echo "Cleaning up..."
	rm -f "${archive}"

	echo "Vulkan SDK ${version} installed to ${install_dir}"
}

# If the script is executed directly, call the function with CLI args.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	install_vulkansdk "$@"
fi

#!/usr/bin/env bash
set -e

# ---- Configuration ----
VULKAN_VERSION="1.4.335.0"
INSTALL_DIR="$HOME/.local/share/tools/vulkan/"
ARCHIVE="vulkansdk-linux-x86_64-${VULKAN_VERSION}.tar.xz"
URL="https://sdk.lunarg.com/sdk/download/${VULKAN_VERSION}/linux/${ARCHIVE}"

# ---- Download ----
echo "Downloading Vulkan SDK ${VULKAN_VERSION}..."
wget -q --show-progress -O "${ARCHIVE}" "${URL}"

# ---- Extract ----
echo "Extracting..."
mkdir -p "${INSTALL_DIR}"
tar -xf "${ARCHIVE}" -C "${INSTALL_DIR}" --strip-components=1

# ---- Cleanup ----
echo "Cleaning up..."
rm -f "${ARCHIVE}"

echo "Vulkan SDK ${VULKAN_VERSION} installed to ${INSTALL_DIR}"

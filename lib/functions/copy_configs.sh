#!/usr/bin/env bash
set -euo pipefail

# copy_config_folders SRC DEST FOLDER...
# Copies configuration subfolders from SRC to DEST. If `rsync` is available
# it will be used for a safer sync; otherwise falls back to `cp -a`.
# Example:
#   copy_config_folders "$NYXTRA_ROOT_DIR/configs" "$HOME/.config" "hypr" "nvim"
copy_config_folders() {
    if [ "$#" -lt 3 ]; then
        echo "Usage: copy_config_folders SRC DEST FOLDER..." >&2
        return 2
    fi

    local src="$1"
    local dest="$2"
    shift 2

    if [ ! -d "$src" ]; then
        echo "Source directory '$src' does not exist" >&2
        return 1
    fi

    mkdir -p "$dest"

    local folder
    if command -v rsync >/dev/null 2>&1; then
        for folder in "$@"; do
            local s="$src/$folder/"
            local d="$dest/$folder/"
            echo "📁 Copying $s to $d"
            mkdir -p "$d"
            rsync -a --delete --exclude='.git' "${s}" "${d}"
        done
    else
        for folder in "$@"; do
            local s="$src/$folder/"
            local d="$dest/$folder/"
            echo "📁 Copying $s to $d"
            mkdir -p "$d"
            cp -a "${s}"* "${d}" 2>/dev/null || true
        done
    fi
}

export -f copy_config_folders 2>/dev/null || true

# copy_file SRC DEST
# Copies a single file to DEST (path to destination file). Creates parent
# directories as needed. Uses `rsync` when available to preserve metadata.
copy_file() {
    if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
        echo "Usage: copy_file SRC DEST [sudo]" >&2
        return 2
    fi
    local src="$1"
    local dest="$2"

    if [ ! -e "$src" ]; then
        echo "Source file '$src' does not exist" >&2
        return 1
    fi

    mkdir -p "$(dirname "$dest")"

    # Normal copy
    if [ "${3-}" != "sudo" ]; then
        if command -v rsync >/dev/null 2>&1; then
            rsync -a --exclude='.git' "$src" "$dest"
        else
            cp -a "$src" "$dest"
        fi
        return 0
    fi

    # Copy with sudo to write to privileged locations
    if ! command -v sudo >/dev/null 2>&1; then
        echo "sudo requested but sudo is not available" >&2
        return 1
    fi

    sudo mkdir -p "$(dirname "$dest")"
    # Use sudo+tee to write the file content as root, then set ownership/mode
    if sudo tee "$dest" >/dev/null < "$src"; then
        sudo chown root:root "$dest" || true
        sudo chmod --reference="$src" "$dest" || true
        return 0
    else
        echo "failed to write $dest with sudo" >&2
        return 1
    fi
}

# copy_files SRC_DIR DEST_DIR FILE1 [FILE2 ...]
# Copies specific files from SRC_DIR to DEST_DIR preserving relative names.
copy_files() {
    if [ "$#" -lt 3 ]; then
        echo "Usage: copy_files SRC_DIR DEST_DIR FILE..." >&2
        return 2
    fi

    local src_dir="$1"
    local dest_dir="$2"
    shift 2

    if [ ! -d "$src_dir" ]; then
        echo "Source directory '$src_dir' does not exist" >&2
        return 1
    fi

    local use_sudo=0
    local files=("$@")
    # Detect trailing 'sudo' flag
    if [ "${files[$((${#files[@]}-1))]}" = "sudo" ]; then
        use_sudo=1
        unset 'files[$((${#files[@]}-1))]'
    fi

    local file
    for file in "${files[@]}"; do
        local s="$src_dir/$file"
        local d="$dest_dir/$file"
        echo "📄 Copying $s to $d"
        if [ $use_sudo -eq 1 ]; then
            copy_file "$s" "$d" sudo || true
        else
            copy_file "$s" "$d" || true
        fi
    done
}

export -f copy_file copy_files 2>/dev/null || true

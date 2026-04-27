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

# pick_layered_configs CONFIG_ROOT DEST_ROOT DEVICE USER FOLDER FILE...
# For each FILE, copy the file from CONFIG_ROOT/<DEVICE>/<USER>/<FOLDER>/FILE
# if it exists; otherwise copy CONFIG_ROOT/default/<FOLDER>/FILE. The result
# is written into DEST_ROOT/<FOLDER>/FILE, creating directories as needed.
pick_layered_configs() {
    if [ "$#" -lt 6 ]; then
        echo "Usage: pick_layered_configs CONFIG_ROOT DEST_ROOT DEVICE USER FOLDER FILE..." >&2
        return 2
    fi

    local cfg_root="$1"; shift
    local dest_root="$1"; shift
    local device="$1"; shift
    local user="$1"; shift
    local folder="$1"; shift

    local out_dir="$dest_root/$folder"
    mkdir -p "$out_dir"

    local file
    for file in "$@"; do
        local src_dev_user="$cfg_root/$device/$user/$folder/$file"
        local src_default="$cfg_root/default/$folder/$file"
        local dest="$out_dir/$file"

        if [ -f "$src_dev_user" ]; then
            echo "Using device/user file: $src_dev_user -> $dest" >&2
            copy_file "$src_dev_user" "$dest" || true
        elif [ -f "$src_default" ]; then
            echo "Using default file: $src_default -> $dest" >&2
            copy_file "$src_default" "$dest" || true
        else
            echo "No file found for $file (checked $src_dev_user and $src_default), skipping" >&2
        fi
    done
}

export -f pick_layered_configs 2>/dev/null || true

# copy_config_folder_layered CONFIG_ROOT DEST_ROOT DEVICE USER FOLDER
# Recursively enumerates all files under the default and device/user and
# user folder sources, then picks per-file (device/user -> default) into DEST.
copy_config_folder_layered() {
    if [ "$#" -ne 5 ]; then
        echo "Usage: copy_config_folder_layered CONFIG_ROOT DEST_ROOT DEVICE USER FOLDER" >&2
        return 2
    fi

    local cfg_root="$1"
    local dest_root="$2"
    local device="$3"
    local user="$4"
    local folder="$5"

    #echo "Processing config folder '$folder' with layering ($device/$user) in $cfg_root to $dest_root ."

    local src_default="$cfg_root/default/$folder"
    local src_dev_user="$cfg_root/$device/$user/$folder"
    local src_user="$cfg_root/$user/$folder"

    # collect unique relative file paths from the three locations
    local tmp
    tmp=$(mktemp)
    trap "rm -f '$tmp'" RETURN

    if [ -d "$src_default" ]; then
        (cd "$src_default" && find . -type f | sed 's|^./||') >> "$tmp" || true
    fi
    if [ -d "$src_dev_user" ]; then
        (cd "$src_dev_user" && find . -type f | sed 's|^./||') >> "$tmp" || true
    fi
    if [ -d "$src_user" ]; then
        (cd "$src_user" && find . -type f | sed 's|^./||') >> "$tmp" || true
    fi

    # dedupe and build array
    local files
    mapfile -t files < <(sort -u "$tmp")

    if [ ${#files[@]} -eq 0 ]; then
        echo "No files found for folder '$folder' in default/device/user locations, skipping." >&2
        return 0
    fi

    # Use pick_layered_configs to copy each file choosing device/user over default
    pick_layered_configs "$cfg_root" "$dest_root" "$device" "$user" "$folder" "${files[@]}"
}

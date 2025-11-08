#!/bin/bash
set -e

install_packages() {
    echo "📦 Installing packages...."

    # Navigate to script directory
    cd "$(dirname "$0")"

    # Install required packages
    if [[ -f ./packages.txt ]]; then
        mapfile -t packages < ./packages.txt
        yay -S --needed --noconfirm "${packages[@]}"
    else
        echo "packages.txt not found"
        exit 1
    fi

    echo "✅ Packages installed successfully!"
}

stow_dotfiles() {
    echo "🔗 Stowing dotfiles..."

    # Navigate to the parent directory (dotfiles root)
    cd "$(dirname "$0")/.."

    # Create backup directory if it doesn't exist
    BACKUP_DIR="$HOME/cfg-backup"
    if [[ ! -d "$BACKUP_DIR" ]]; then
        echo "📁 Creating backup directory: $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
    fi

    # Loop through all directories except 'install'
    for dir in */; do
        # Remove trailing slash
        dir=${dir%/}

        # Skip the install directory
        if [[ "$dir" == "install" ]]; then
            echo "⏭️  Skipping $dir"
            continue
        fi

        # Check for conflicting files/directories in .config
        if [[ -d "$dir/.config" ]]; then
            for config_dir in "$dir/.config"/*; do
                if [[ -e "$config_dir" ]]; then
                    config_name=$(basename "$config_dir")
                    target="$HOME/.config/$config_name"

                    # If target exists, is not a symlink, and is a directory
                    if [[ -e "$target" && ! -L "$target" ]]; then
                        echo "⚠️  Backing up existing $target to $BACKUP_DIR/$config_name"
                        mv "$target" "$BACKUP_DIR/$config_name"
                    fi
                fi
            done
        fi

        echo "📌 Stowing $dir..."
        stow -S "$dir"
    done

    echo "✅ All dotfiles stowed successfully!"
}

# Parse arguments
case "$1" in
    -p)
        install_packages
        ;;
    -s)
        stow_dotfiles
        ;;
    "")
        install_packages
        stow_dotfiles
        ;;
    *)
        echo "Usage: $0 [-p|-s]"
        echo "  -p  Install packages only"
        echo "  -s  Stow dotfiles only"
        echo "      No argument: do both"
        exit 1
        ;;
esac
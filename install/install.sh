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

    backup_conflicts() {
        local package_dir=$1

        while IFS= read -r source_path; do
            local relative_path=${source_path#"$package_dir"/}
            local target_path="$HOME/$relative_path"
            local backup_path="$BACKUP_DIR/$relative_path"

            if [[ -e "$target_path" && ! -L "$target_path" ]]; then
                echo "⚠️  Backing up existing $target_path to $backup_path"
                mkdir -p "$(dirname "$backup_path")"
                mv "$target_path" "$backup_path"
            fi
        done < <(find "$package_dir" \( -type f -o -type l \) | sort)
    }

    # Loop through all directories except 'install'
    for dir in */; do
        # Remove trailing slash
        dir=${dir%/}

        # Skip the install directory
        if [[ "$dir" == "install" ]]; then
            echo "⏭️  Skipping $dir"
            continue
        fi

        backup_conflicts "$dir"

        echo "📌 Stowing $dir..."
        stow -t "$HOME" -S "$dir"
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

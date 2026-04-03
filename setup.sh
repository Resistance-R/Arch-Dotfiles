#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="${HOME}/.dotfiles"
CONFIG_SRC_DIR="${DOTFILES_DIR}/config"
CONFIG_DST_DIR="${HOME}/.config"
SCRIPT_SRC_DIR="${DOTFILES_DIR}/scripts"
SCRIPT_DST_DIR="${HOME}/.scripts"
DEPENDENCIES_FILE="${DOTFILES_DIR}/dependencies.txt"
BACKUP_DIR="${HOME}/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

log() {
    printf '[INFO] %s\n' "$1"
}

warn() {
    printf '[WARN] %s\n' "$1"
}

error() {
    printf '[ERROR] %s\n' "$1" >&2
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

install_package() {
    local pkg="$1"

    # Ignore comments and blank lines
    [[ -z "$pkg" || "$pkg" =~ ^[[:space:]]*# ]] && return 0

    if pacman -Q "$pkg" >/dev/null 2>&1; then
        log "Already Installed: $pkg"
        return 0
    fi

    if pacman -Si "$pkg" >/dev/null 2>&1; then
        log "Install Official Repo: $pkg"
        sudo pacman -S --needed --noconfirm "$pkg"
        return 0
    fi

    if command_exists yay; then
        log "Install AUR (yay): $pkg"
        yay -S --needed --noconfirm "$pkg"
        return 0
    fi

    warn "Package is not found or yay is not exist: $pkg"
    return 1
}

install_dependencies() {
    if [[ ! -f "$DEPENDENCIES_FILE" ]]; then
        warn "dependencies.txt is NOT found: $DEPENDENCIES_FILE"
        return 0
    fi

    log "Start package install"
    while IFS= read -r line || [[ -n "$line" ]]; do
        install_package "$line"
    done < "$DEPENDENCIES_FILE"
}

backup_target() {
    local target="$1"

    mkdir -p "$BACKUP_DIR"
    local rel="${target#$HOME/}"
    local backup_path="${BACKUP_DIR}/${rel}"

    mkdir -p "$(dirname "$backup_path")"
    mv "$target" "$backup_path"
    warn "Backup existing file: $target -> $backup_path"
}

link_config_items() {
    if [[ ! -d "$CONFIG_SRC_DIR" ]]; then
        warn "config is NOT found: $CONFIG_SRC_DIR"
        return 0
    fi

    mkdir -p "$CONFIG_DST_DIR"

    log "Start Symbolic link"

    for src in "$CONFIG_SRC_DIR"/*; do
        [[ -e "$src" ]] || continue

        local name
        name="$(basename "$src")"
        local dst="${CONFIG_DST_DIR}/${name}"

        if [[ -L "$dst" ]]; then
            local current_target
            current_target="$(readlink -f "$dst" || true)"
            local desired_target
            desired_target="$(readlink -f "$src")"

            if [[ "$current_target" == "$desired_target" ]]; then
                log "Already Linked Correctly: $dst"
                continue
            else
                backup_target "$dst"
            fi
        elif [[ -e "$dst" ]]; then
            backup_target "$dst"
        fi

        ln -sfn "$src" "$dst"
        log "Generate Link: $dst -> $src"
    done
}

main() {
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        error "dotfiles derectory is NOT found: $DOTFILES_DIR"
        exit 1
    fi

    if ! command_exists pacman; then
        error "This script assumes a pacman environment"
        exit 1
    fi

    mkdir -p "${HOME}/Pictures/Screenshots"

    install_dependencies
    link_config_items

    ln -sfn "$SCRIPT_SRC_DIR" "$SCRIPT_DST_DIR"

    log "Installation Complete."
}

main "$@"

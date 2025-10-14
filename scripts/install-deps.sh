#!/usr/bin/env bash
# Simple, best-effort dependency installer for dotfiles
# - Prefers distro default repos (apt, dnf, pacman)
# - Attempts minimal AUR handling if a helper (yay/paru) is present
# - Clones oh-my-zsh if missing
#
# Design goals:
# - Simple is better than complex
# - Safe, idempotent, and transparent (prints actions)
# - Complex flows (COPR, building from source, adding new repos) are left as TODOs
#
# Usage:
#   ./install-deps.sh                # install default set
#   ./install-deps.sh pkg1 pkg2 ... # install specified packages instead
#
# NOTE: This script may prompt for sudo when installing packages.

set -euo pipefail

# Default packages (best-effort list that may exist in distro repos)
DEFAULT_PACKAGES=(lazygit nodejs npm luarocks tree-sitter-cli uv stow neovim dunst picom tmux wget curl git)
# Packages commonly available only via AUR / COPR (handled specially below)
AUR_PACKAGES=(starship qtile-extras)
COPR_PACKAGES=(starship qtile-extras)

# Helpers
log() { printf '%s\n' "[+] $*"; }
warn() { printf '%s\n' "[!] $*"; }
err() {
  printf '%s\n' "[✖] $*" >&2
  exit 1
}

detect_package_manager() {
  if command -v apt >/dev/null 2>&1; then
    echo "apt"
  elif command -v dnf >/dev/null 2>&1; then
    echo "dnf"
  elif command -v pacman >/dev/null 2>&1; then
    echo "pacman"
  else
    echo "unknown"
  fi
}

install_with_apt() {
  # Arguments: package names
  if [ "$#" -eq 0 ]; then return 0; fi
  log "Updating apt cache..."
  sudo apt update
  log "Installing via apt: $*"
  sudo apt install -y "$@"
}

install_with_dnf() {
  if [ "$#" -eq 0 ]; then return 0; fi
  log "Installing via dnf: $*"
  sudo dnf install -y "$@"
}

install_with_pacman() {
  if [ "$#" -eq 0 ]; then return 0; fi
  log "Installing via pacman: $*"
  # Keep it non-interactive; refresh databases first
  sudo pacman -Syu --noconfirm "$@"
}

# Try installing starship via an AUR helper if available (yay or paru)
install_via_aur_helper() {
  local pkg="$1"
  if command -v yay >/dev/null 2>&1; then
    log "Installing $pkg via yay (AUR)..."
    yay -S --noconfirm "$pkg"
    return $?
  fi
  if command -v paru >/dev/null 2>&1; then
    log "Installing $pkg via paru (AUR)..."
    paru -S --noconfirm "$pkg"
    return $?
  fi
  return 1
}

# COPR placeholder: Fedora-specific repos may require enabling copr repos.
# This is intentionally simple; more complex flows should be implemented when needed.
install_via_copr_placeholder() {
  local pkg="$1"
  warn "Package '$pkg' may be available in COPR or other third-party repos on Fedora."
  warn "TODO: Add automated COPR handling (e.g. 'dnf copr enable <user>/<repo>' then 'dnf install')."
  return 1
}

install_oh_my_zsh() {
  if [ -d "$HOME/.oh-my-zsh" ]; then
    log "oh-my-zsh already installed at $HOME/.oh-my-zsh"
    return 0
  fi
  # Prefer using the official installer script (download + run).
  # Use wget (already a requested dependency) and run the installer non-interactively
  # to avoid automatically changing the user's shell or starting zsh.
  if ! command -v wget >/dev/null 2>&1; then
    warn "wget not found; cannot download oh-my-zsh installer. Please install wget and re-run this script."
    return 1
  fi

  log "Downloading and running oh-my-zsh installer (non-interactive)."

  tmpdir="$(mktemp -d)" || { warn "Failed to create temp dir for installer"; return 1; }
  installer="$tmpdir/install-oh-my-zsh.sh"

  # Try raw.githubusercontent first, fall back to the official mirror if needed.
  if wget -qO "$installer" "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"; then
    log "Downloaded installer from raw.githubusercontent.com"
  else
    warn "raw.githubusercontent.com unavailable, trying https://install.ohmyz.sh"
    if ! wget -qO "$installer" "https://install.ohmyz.sh"; then
      warn "Failed to download oh-my-zsh installer from both sources"
      rm -rf "$tmpdir"
      return 1
    fi
  fi

  # Run installer with environment variables to disable auto-starting zsh and changing the shell.
  # RUNZSH=no prevents running zsh after install, CHSH=no prevents changing the login shell.
  RUNZSH=no CHSH=no sh "$installer" && log "oh-my-zsh installer finished" || warn "oh-my-zsh installer failed"

  # Clean up temporary files
  rm -rf "$tmpdir"
}

# Main high-level installer. Accepts list of requested packages as arguments.
main() {
  local requested=()
  if [ "$#" -gt 0 ]; then
    requested=("$@")
  else
    requested=("${DEFAULT_PACKAGES[@]}")
  fi

  local pm
  pm=$(detect_package_manager)
  log "Detected package manager: $pm"

  case "$pm" in
  apt)
    install_with_apt "${requested[@]}"
    ;;
  dnf)
    install_with_dnf "${requested[@]}"
    ;;
  pacman)
    install_with_pacman "${requested[@]}"
    ;;
  *)
    warn "Unsupported or unknown package manager. Please install the following manually: ${requested[*]}"
    ;;
  esac

  # Handle packages that often live in AUR/COPR: try simple fallbacks.
  # We treat 'starship' as an example: prefer AUR on Arch, COPR on Fedora, otherwise suggest manual install.
  for pkg in "${AUR_PACKAGES[@]}"; do
    case "$pm" in
    pacman)
      if command -v "$pkg" >/dev/null 2>&1; then
        log "$pkg already installed"
      else
        if install_via_aur_helper "$pkg"; then
          log "$pkg installed via AUR helper"
        else
          warn "Could not install $pkg via AUR helper automatically. Please install it manually or add an AUR helper (yay/paru)."
        fi
      fi
      ;;
    dnf)
      # Try COPR placeholder for Fedora
      if command -v "$pkg" >/dev/null 2>&1; then
        log "$pkg already installed"
      else
        if install_via_copr_placeholder "$pkg"; then
          log "$pkg installed via COPR"
        else
          warn "Please install $pkg manually on Fedora (COPR or official repo)."
        fi
      fi
      ;;
    apt | unknown)
      if command -v "$pkg" >/dev/null 2>&1; then
        log "$pkg already installed"
      else
        warn "$pkg may not be available in default repos. Consider installing via release packages, prebuilt binaries, or building from source."
      fi
      ;;
    esac
  done

  # Install oh-my-zsh via git (simple)
  install_oh_my_zsh

  log "Dependency installation complete. Review the output above for any warnings or TODOs."
  log "If something failed, re-run the script with sudo available and inspect the messages."
}

# Entrypoint: accept packages as args; otherwise use defaults.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  if [ "$#" -gt 0 ]; then
    main "$@"
  else
    main
  fi
fi

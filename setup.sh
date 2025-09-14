#!/bin/bash
# setup.sh - Unified setup, deploy, and init script for GNU Stow dotfiles

set -euo pipefail

# Variables
DOTFILES_DIR="$HOME/dotfiles"
REMOTE_URL="https://github.com/Cyber-Syntax/dotfiles.git"
TARGET_DIR="$HOME"
CONFIG_DIRS=(nvim zsh kitty tmux autotarcompress fedora-setup alacritty hypr i3 polybar dunst picom waybar qtile awesome auto-cpufreq gammastep starship MangoHud)
CONFIG_FILES=(bashrc zshenv)

# Help message
show_help() {
  cat <<EOF
Usage: setup.sh [OPTION]

Options:
  --setup       Run setup: preview and move files to dotfiles structure
  --deploy      Run deployment: preview and apply stow symlinks
  --init-git    (Experimental) Initialize the dotfiles Git repository
  --help        Show this help message
EOF
}

# Dry-move preview function
preview_move() {
  echo "[+] Preview of files to be moved during setup:"
  echo "[+] Dotfiles directory: $DOTFILES_DIR"

  for dir in "${CONFIG_DIRS[@]}"; do
    SRC="$HOME/.config/$dir"
    DEST="$DOTFILES_DIR/dot-config/$dir"
    if [ -d "$SRC" ]; then
      echo "  ✓ $SRC -> $DEST"
    else
      echo "  ✗ $SRC -> $DEST (source not found)"
    fi
  done

  for file in "${CONFIG_FILES[@]}"; do
    SRC="$HOME/.$file"
    DEST="$DOTFILES_DIR/dot-$file"
    if [ -f "$SRC" ]; then
      echo "  ✓ $SRC -> $DEST"
    else
      echo "  ✗ $SRC -> $DEST (source not found)"
    fi
  done
}

# Confirm before setup
confirm_setup() {
  printf "Do you want to proceed with setting up dotfiles structure and moving files? [y/N]: "
  read -r answer
  case "$answer" in
  [Yy]*)
    setup
    ;;
  *)
    echo "[!] Setup aborted by user."
    exit 1
    ;;
  esac
}

# Setup function: move user configs into dotfiles repo structure
setup() {
  echo "[+] Setting up dotfiles directory structure..."

  # Create dotfiles directory if it doesn't exist
  if [ ! -d "$DOTFILES_DIR" ]; then
    echo "[+] Creating dotfiles directory $DOTFILES_DIR"
    mkdir -p "$DOTFILES_DIR"
  fi

  mkdir -p "$DOTFILES_DIR/dot-config"

  for dir in "${CONFIG_DIRS[@]}"; do
    SRC="$HOME/.config/$dir"
    DEST="$DOTFILES_DIR/dot-config/$dir"
    if [ -d "$SRC" ]; then
      echo "[+] moving $SRC to $DEST"
      mv "$SRC" "$DEST"
    else
      echo "[!] Skipping $SRC (not found)"
    fi
  done

  for file in "${CONFIG_FILES[@]}"; do
    SRC="$HOME/.$file"
    DEST="$DOTFILES_DIR/dot-$file"
    if [ -f "$SRC" ]; then
      echo "[+] moving $SRC to $DEST"
      mv "$SRC" "$DEST"
    else
      echo "[!] Skipping $SRC (not found)"
    fi
  done

  echo "[+] Writing .stowrc"
  cat >"$DOTFILES_DIR/.stowrc" <<EOF
--dotfiles
--target=$HOME
--ignore=.stowrc
--ignore=setup.sh
EOF
}

# Dry-run function: Shows what will be symlinked
dry_run() {
  echo "[+] Running dry-run..."
  cd "$DOTFILES_DIR"
  stow -n -v .
}

# Deploy function: Actually perform symlinking
deploy() {
  echo "[+] Deploying dotfiles..."
  cd "$DOTFILES_DIR"
  stow .
  echo "[+] Deployment complete."
}

# Confirm before deploy
confirm_deploy() {
  printf "Do you want to proceed with actual deployment? [y/N]: "
  read -r answer
  case "$answer" in
  [Yy]*)
    deploy
    ;;
  *)
    echo "[!] Deployment aborted by user."
    exit 1
    ;;
  esac
}

# Git init function: Initializes dotfiles repo
init_git() {
  echo "[+] Initializing Git repo in $DOTFILES_DIR"
  cd "$DOTFILES_DIR"
  if [ ! -d .git ]; then
    echo "# dotfiles" >README.md
    git init
    git add README.md
    git commit -m "first commit"
    git branch -M main
    git remote add origin "$REMOTE_URL"
    git push -u origin main || echo "[!] Push failed (repo may already exist)"
  else
    echo "[+] Git repo already initialized."
  fi
}

# Main logic: parse arguments
if [ $# -eq 0 ]; then
  show_help
  exit 0
fi

case "$1" in
--setup)
  preview_move
  confirm_setup
  ;;
--deploy)
  dry_run
  confirm_deploy
  ;;
--init-git)
  init_git
  ;;
--help)
  show_help
  ;;
*)
  echo "[!] Unknown option: $1"
  show_help
  exit 1
  ;;
esac

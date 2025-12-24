#!/bin/bash
# setup.sh - Unified setup, deploy, and init script for GNU Stow dotfiles

set -euo pipefail

# Variables
DOTFILES_DIR="$HOME/dotfiles"
REMOTE_URL="https://github.com/Cyber-Syntax/dotfiles.git"
CONFIG_DIRS=(nvim zsh kitty tmux autotarcompress auto-penguin-setup alacritty hypr i3 polybar dunst picom waybar qtile auto-cpufreq gammastep starship MangoHud gtk-2.0 gtk-3.0 gtk-4.0)
CONFIG_FILES=(bashrc zshenv gitconfig)

# Help message
show_help() {
  cat <<EOF
Usage: setup.sh [OPTION]

Options:
  --setup             Run setup: preview and move files to dotfiles structure
  --deploy            Run deployment: preview and apply stow symlinks
  --clean             Clean up backup files
  --init-git          (Experimental) Initialize the dotfiles Git repository
  --help              Show this help message
EOF
}

# Dry-move preview function
preview_move() {
  echo "[+] Preview of files to be moved during setup:"
  echo "[+] Dotfiles directory: $DOTFILES_DIR"

  for dir in "${CONFIG_DIRS[@]}"; do
    SRC="$HOME/.config/$dir"
    DEST="$DOTFILES_DIR/dot-config/$dir"
    if [ -L "$SRC" ]; then
      echo "  ✗ $SRC -> $DEST (already a symlink, likely stowed)"
    elif [ -d "$SRC" ]; then
      echo "  ✓ $SRC -> $DEST"
    else
      echo "  ✗ $SRC -> $DEST (source not found)"
    fi
  done

  for file in "${CONFIG_FILES[@]}"; do
    SRC="$HOME/.$file"
    DEST="$DOTFILES_DIR/dot-$file"
    if [ -L "$SRC" ]; then
      echo "  ✗ $SRC -> $DEST (already a symlink, likely stowed)"
    elif [ -f "$SRC" ]; then
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
    if [ -L "$SRC" ]; then
      echo "[!] Skipping $SRC (already a symlink, likely stowed—unstow first.)"
    elif [ -d "$SRC" ]; then
      echo "[+] backing up $SRC"
      cp -r "$SRC" "$SRC.backup"
      echo "[+] moving $SRC to $DEST"
      mv "$SRC" "$DEST"
    else
      echo "[!] Skipping $SRC (not found)"
    fi
  done

  for file in "${CONFIG_FILES[@]}"; do
    SRC="$HOME/.$file"
    DEST="$DOTFILES_DIR/dot-$file"
    if [ -L "$SRC" ]; then
      echo "[!] Skipping $SRC (already a symlink, likely stowed—unstow first.)"
    elif [ -f "$SRC" ]; then
      echo "[+] backing up $SRC"
      cp "$SRC" "$SRC.backup"
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
--ignore=.stfolder
--ignore=stversions
--ignore=docs
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

# Cleanup backups function
cleanup_backups() {
  echo "[+] Removing backup files..."
  for dir in "${CONFIG_DIRS[@]}"; do
    BACKUP="$HOME/.config/$dir.backup"
    if [ -e "$BACKUP" ]; then
      echo "[+] Removing $BACKUP"
      rm -rf "$BACKUP"
    fi
  done
  for file in "${CONFIG_FILES[@]}"; do
    BACKUP="$HOME/.$file.backup"
    if [ -e "$BACKUP" ]; then
      echo "[+] Removing $BACKUP"
      rm -f "$BACKUP"
    fi
  done
  echo "[+] Cleanup complete."
}

# Dry-cleanup preview function
preview_cleanup() {
  echo "[+] Preview of backup files to be removed:"
  echo "[+] Checking for backups in $HOME"

  for dir in "${CONFIG_DIRS[@]}"; do
    BACKUP="$HOME/.config/$dir.backup"
    if [ -e "$BACKUP" ]; then
      echo "  ✓ $BACKUP"
    fi
  done

  for file in "${CONFIG_FILES[@]}"; do
    BACKUP="$HOME/.$file.backup"
    if [ -e "$BACKUP" ]; then
      echo "  ✓ $BACKUP"
    fi
  done
}

# Confirm before cleanup
confirm_cleanup() {
  preview_cleanup
  printf "Do you want to proceed with removing backup files? [y/N]: "
  read -r answer
  case "$answer" in
  [Yy]*)
    cleanup_backups
    ;;
  *)
    echo "[!] Cleanup aborted by user."
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
--clean)
  confirm_cleanup
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

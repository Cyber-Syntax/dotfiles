#!/bin/sh
# This script deploys the configs GNU Stow

STOW_DIR="$HOME/dotfiles"
TARGET_DIR="$HOME"

# Go to dotfiles directory
cd "$STOW_DIR" || {
  echo "Directory $STOW_DIR not found!"
  exit 1
}

# Function to run dry-run
dry_run() {
  echo "Running dry-run (no changes will be made)..."
  stow -n -v --dotfiles --target="$TARGET_DIR" --ignore=.stowrc --ignore=deploy.sh .
}

# Function to run actual deployment
deploy() {
  echo "Deploying configs..."
  stow --dotfiles --target="$TARGET_DIR" --ignore=.stowrc --ignore=deploy.sh .
}

# Function to prompt user for confirmation
confirm() {
  printf "Do you want to proceed with actual deployment? [y/N]: "
  read -r answer
  case "$answer" in
  [Yy]*)
    deploy
    ;;
  *)
    echo "[!] Aborted by user."
    exit 0
    ;;
  esac
}

dry_run

# Ask user for confirmation before proceeding
confirm

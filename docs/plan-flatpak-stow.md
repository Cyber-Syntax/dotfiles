# Plan: Integrating Flatpak App Config Stowing into Dotfiles Setup

## Overview

The goal is to extend the existing `setup.sh` script to support stowing Flatpak application configurations using GNU Stow, similar to how it handles `~/.config` directories and `~` files. This will allow managing Flatpak app configs (e.g., `~/.var/app/dev.zed.Zed/config/zed`) in the dotfiles repository for version control and easy deployment across systems.

Flatpak applications store their configurations in `~/.var/app/<app-id>/config/` or `~/.var/app/<app-id>/data/`. For this plan, we'll focus on config directories, as exemplified by the Zed editor's config at `~/.var/app/dev.zed.Zed/config/zed`.

## Current Setup Analysis

The `setup.sh` script currently handles:

- **CONFIG_DIRS**: Array of directories under `~/.config/` (e.g., `nvim`, `zsh`, `kitty`).
- **CONFIG_FILES**: Array of files in `~` (e.g., `bashrc`, `zshenv`).

It performs:

- **Move**: Moves configs from user dirs to `dotfiles/dot-config/` or `dotfiles/dot-*`.
- **Stow**: Symlinks them back using `stow .` with target `$HOME`.
- **Cleanup**: Removes backup files.

The dotfiles structure mirrors the target paths (e.g., `dotfiles/dot-config/nvim` stows to `~/.config/nvim`).

## Proposed Solution

Introduce a new category for Flatpak configs:

- **FLATPAK_CONFIGS**: Array of relative paths under `~/.var/app/` (e.g., `dev.zed.Zed/config/zed`).
- Store them in `dotfiles/var/app/` (e.g., `dotfiles/var/app/dev.zed.Zed/config/zed`).
- Stow will create symlinks like `~/.var/app/dev.zed.Zed/config/zed -> dotfiles/var/app/dev.zed.Zed/config/zed`.

This maintains consistency with the existing structure.

## Implementation Steps

### 1. Update Variables in `setup.sh`

Add a new array for Flatpak configs:

```sh
FLATPAK_CONFIGS=(dev.zed.Zed/config/zed)  # Add more as needed, e.g., org.mozilla.firefox/config/user.js
```

### 2. Modify `preview_move()` Function

Add a section to preview Flatpak config moves:

```sh
for config in "${FLATPAK_CONFIGS[@]}"; do
  SRC="$HOME/.var/app/$config"
  DEST="$DOTFILES_DIR/var/app/$config"
  if [ -L "$SRC" ]; then
    echo "  ✗ $SRC -> $DEST (already a symlink, likely stowed)"
  elif [ -d "$SRC" ]; then
    echo "  ✓ $SRC -> $DEST"
  else
    echo "  ✗ $SRC -> $DEST (source not found)"
  fi
done
```

### 3. Modify `setup()` Function

Add moving logic for Flatpak configs:

- Create `dotfiles/dot-var-app` if needed.
- Move and backup Flatpak configs similarly to CONFIG_DIRS.

```sh
mkdir -p "$DOTFILES_DIR/var"

for config in "${FLATPAK_CONFIGS[@]}"; do
  SRC="$HOME/.var/app/$config"
  DEST="$DOTFILES_DIR/var/app/$config"
  if [ -L "$SRC" ]; then
    echo "[!] Skipping $SRC (already a symlink, likely stowed—unstow first.)"
  elif [ -d "$SRC" ]; then
    echo "[+] backing up $SRC"
    cp -r "$SRC" "$SRC.backup"
    echo "[+] moving $SRC to $DEST"
    mkdir -p "$(dirname "$DEST")"  # Ensure parent dirs exist
    mv "$SRC" "$DEST"
  else
    echo "[!] Skipping $SRC (not found)"
  fi
done
```

### 4. Modify `preview_cleanup()` and `cleanup_backups()` Functions

Add Flatpak backup handling:

- In `preview_cleanup()`, check for `~/.var/app/$config.backup`.
- In `cleanup_backups()`, remove them.

```sh
# In preview_cleanup()
for config in "${FLATPAK_CONFIGS[@]}"; do
  BACKUP="$HOME/.var/app/$config.backup"
  if [ -e "$BACKUP" ]; then
    echo "  ✓ $BACKUP"
  fi
done

# In cleanup_backups()
for config in "${FLATPAK_CONFIGS[@]}"; do
  BACKUP="$HOME/.var/app/$config.backup"
  if [ -e "$BACKUP" ]; then
    echo "[+] Removing $BACKUP"
    rm -rf "$BACKUP"
  fi
done
```

### 5. Ensure Stow Works

- The existing `dry_run()` and `deploy()` use `stow .`, which will automatically handle new packages under `dot-var-app`.
- No changes needed here, as Stow will symlink based on the directory structure.

### 6. Update `.stowrc` if Needed

- The current `.stowrc` ignores certain files but allows stowing subdirs. It should work as-is.
- If issues arise, consider adding `--ignore` for Flatpak-specific patterns, but unlikely needed.

### 7. Add to Git Repository

- After moving, the new `dot-var-app` dirs can be added to Git: `git add dot-var-app/`.
- Ensure `.gitignore` doesn't exclude them (check if it ignores `.var` or similar).

## Considerations and Edge Cases

- **Flatpak Installation**: The target `~/.var/app/<app-id>/config` must exist for symlinks to work. Install the Flatpak app before stowing. If not, symlinks may be broken until the app creates the dirs.
- **Parent Directory Creation**: When moving, ensure parent dirs in `dotfiles/dot-var-app` are created.
- **Data vs. Config**: This plan focuses on configs. If data dirs (e.g., `~/.var/app/<app-id>/data`) need stowing, add a separate array like `FLATPAK_DATA`.
- **Permissions**: Flatpak dirs may have specific permissions; ensure backups and moves preserve them.
- **Multiple Apps**: Easily extend `FLATPAK_CONFIGS` with more entries.
- **Unstowing**: Use `stow -D var` to unstow if needed.
- **Testing**: After changes, test with `--move`, `--stow`, and `--clean` on a single config first.

## Testing Plan

1. **Backup Current Setup**: Ensure no data loss.
2. **Add One Config**: Start with `dev.zed.Zed/config/zed`.
3. **Run Preview**: Use `--move` to preview.
4. **Move and Stow**: Execute move, then stow, verify symlinks.
5. **Check Functionality**: Open the app and confirm config is used.
6. **Cleanup**: Test backup removal.
7. **Git Integration**: Add to repo and commit.

## Next Steps

- Implement the changes in `setup.sh`.
- Test thoroughly.
- Document in `README.md` or a docs file.
- Consider automating Flatpak app installation in the script if desired.

This plan integrates seamlessly with the existing dotfiles management, providing a clean way to version control Flatpak configs.

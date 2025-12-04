
# My personal dotfiles
>
> I've moved to using GNU Stow for my personal dotfiles maintenance instead of a bare repository.

## How to setup GNU Stow for your dotfiles?
>
> [!CAUTION]
> Backup your files!
>
> Always `cd ~/dotfiles` dir before any stow command
>

## My current setup

### Window managers

- i3wm (Currently using)
    - Polybar
- Qtile
- Hyprland
    - Waybar

#### General apps used with window managers

- Rofi      : for application launcher
- Dunst     : for notification
- Flameshot : for screenshot
- Picom     : for compositor
- Pcmanfm   : for file management
- gammastep : for blue light filter

### Terminal Emulators

- Ghostty   : Currently using because support images and tabs well.
- Alacritty : Previously used for better performance but lack of tabs support.
- Kitty     : Previously used for good features but performance is not as good as Alacritty.

### Shells

- Zsh (Currently using)
    - oh-my-zsh
- Bash

### Other tools

- Tmux               : Currently using for terminal multiplexer.
- Starship           : Powerlevel10k alternative written in Rust for prompt for any shell.
- MangoHud           : For monitoring system performance in games.
- containers         : Podman config for setting custom directory for containers and images.
- mimeapps.list      : For setting default applications for file types and protocols.

- [autocpufreq](https://github.com/AdnanHodzic/auto-cpufreq)
    - For automatic CPU frequency scaling.
- [autotarcompress](https://github.com/Cyber-Syntax/AutoTarCompress)
    - My Script config to automatically compress tar files after creation.
- [auto-penguin-setup](https://github.com/Cyber-Syntax/auto-penguin-setup)
    - My script config to automate setup for linux distros.

## Dependencies

### neovim dependencies, add to dotfiles

- lazygit nodejs npm laurocks tree-sitter-cli

### Other dependencies

- uv oh-my-zsh stow zsh

## Automatic setup with shell script
>
> [!NOTE]
> setup option:
>
> This would move your dotfiles to `~/dotfiles`
> It would show preview of changes before applying them
>
> - For .config files:  `~/.config/nvim` to `~/dotfiles/dot-config/nvim`
> - For dot files: `~/.vim` to `~/dotfiles/dot-vim`
> - For dot files: `~/.zshrc` to `~/dotfiles/dot-zshrc`

> [!NOTE]
> deploy option:
>
> This would deploy your dotfiles to your home directory
> It would show preview of changes before applying them
>
> - This using stow to deploy your files.
> - Command used for preview: `stow -n -v --dotfiles --target="$HOME" .`
> - Command used for deploy: `stow -v --dotfiles --target="$HOME" .`

```bash
# Make the setup script executable
chmod +x setup.sh

# Run the setup script
./setup.sh --setup

# This would deploy your dotfiles to your home directory
./setup.sh --deploy

# This would initialize git repository in your dotfiles directory
./setup.sh --init-git
```

## Manual Setup

1. Create folder ~/dotfiles
2. initialize git repo

```bash
echo "# dotfiles" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/Cyber-Syntax/dotfiles.git
git push -u origin main
```

3. Make folder for ~/.config

```bash
mkdir -p ~/dotfiles/dot-config/
```

4. Copy your configs

```bash
cp -r ~/.config/nvim ~/dotfiles/dot-config/
```

5. test stow dry without change anything to make sure about changes correct

```bash
cd ~/dotfiles &
stow -n -v --dotfiles --target="$HOME" .
```

6. If everythings work perfect, stow your files

```bash
cd ~/dotfiles &
stow --dotfiles --target="$HOME" .
```

7. Alias for stow `~/dotfiles/.stowrc`:

```bash
--dotfiles
--target="$HOME"
--ignore=.stowrc
```

8. stow files to symlink

```bash
cd ~/dotfiles &
stow .
```

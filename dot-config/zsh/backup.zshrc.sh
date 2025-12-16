#### TMUX
# Enable tmux all the time when zsh starts
# if [ "$TMUX" = "" ]; then tmux; fi

# This fixes colors on tmux but cause issue on zsh
# shell echoing the commands as they executed
#NOTE: this cause cursor to beam all the time even on normal and visual mode
# TERM=screen-256color

#TERM=tmux-256color
# TERM=tmux

#### ./TMUX



# alias badd-all='git --git-dir=$HOME/dotfiles --work-tree=$HOME add ~/Documents/scripts ~/.config/nvim ~/.config/qtile/ ~/.config/kitty/ ~/.config/dunst/ ~/.config/hypr/ ~/.config/waybar/ ~/.config/tmux/ ~/.config/alacritty/ ~/.config/zsh/ ~/.config/mimeapps.list .zshenv .gitignore'
# bare repo functions:
# badd-all() {
#   git --git-dir="$HOME/dotfiles" --work-tree="$HOME" add \
#     "$HOME/Documents/scripts" \
#     "$HOME/.config/nvim"     \
#     "$HOME/.config/qtile"    \
#     "$HOME/.config/kitty"    \
#     "$HOME/.config/dunst"    \
#     "$HOME/.config/hypr" \
#     "$HOME/.config/waybar" \
#     "$HOME/.config/tmux" \
#     "$HOME/.config/alacritty" \
#     "$HOME/.config/zsh" \
#     "$HOME/.config/mimeapps.list" \
#     "$HOME/.zshenv" \
#     "$HOME/.gitignore"
# }



# # NixOS related aliases
# alias stable-flu="sudo nix flake update home-manager nixvim nixpkgs firefox-addons nixos-hardware"
# alias all-flu="sudo nix flake update"
# alias boot-nixos="sudo nixos-rebuild boot --flake .#nixos"
# alias boot-laptop="sudo nixos-rebuild boot --flake .#laptop"
# alias switch-nixos="sudo nixos-rebuild switch --flake .#nixos"
# alias upgrade-nixos="sudo nixos-rebuild switch --recreate-lock-file --flake .#nixos"
# alias switch-laptop="sudo nixos-rebuild switch --flake .#laptop"
# alias upgrade-laptop="sudo nixos-rebuild switch --recreate-lock-file --flake .#laptop"
# alias ll-nix="ll /nix/var/nix/profiles"
# alias switch-gen="sudo nix-env --profile /nix/var/nix/profiles/system --switch-generation"
# alias del-gen="sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations"



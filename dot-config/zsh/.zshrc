# Path to your Oh My Zsh installation.
export ZSH="$HOME/.config/oh-my-zsh"
ZSH_CUSTOM="$HOME/.config/oh-my-zsh/custom"

# Switched to starship because powerlevel10k stop maintenance
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

#TODO: Search proper path export and handle them correctly
# If you must add user paths, better add them as last in the PATH.
#
# Or if you want to replace a system command with your own version, add it to /usr/local/bin. It works because /usr/local/bin is in PATH before /usr/bin:
# `export PATH="$PATH:$HOME/.local/bin"`
#
# Anyway, you really have to know what you are doing. Otherwise you may even compromise the security of your system.

# # If you come from bash you might have to change your $PATH.
export PATH=$HOME/.local/bin:/usr/local/bin:$PATH
# export cargo
export PATH="$HOME/.local/share/cargo/bin:$PATH"

# -------------------------------------------------------------------
# Added by AutoTarCompress to enable shell completion
fpath=($HOME/.config/zsh/completions $fpath)
# Completion and compinit: autoload and initialize completion.
# -------------------------------------------------------------------
autoload -Uz compinit && compinit

# -------------------------------------------------------------------
# History
# -------------------------------------------------------------------
# Set history file path and limits.
HISTFILE="$HOME/.config/zsh/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000

# zsh options
setopt HIST_IGNORE_ALL_DUPS # remove older duplicate entries from history
setopt HIST_SAVE_NO_DUPS    # Do not write a duplicate event to the history file.
setopt HIST_REDUCE_BLANKS   # remove superfluous blanks from history items
setopt INC_APPEND_HISTORY   # save history entries as soon as they are entered
setopt SHARE_HISTORY        # share history between different instances of the shell
setopt AUTO_CD              # cd by typing directory name if it's not a command
setopt CORRECT_ALL          # autocorrect commands
setopt AUTO_LIST            # automatically list choices on ambiguous completion
setopt AUTO_MENU            # automatically use menu completion
setopt ALWAYS_TO_END        # move cursor to end if word had one match

zstyle ':completion:*' menu select                                          # select completions with arrow keys
zstyle ':completion:*' group-name ''                                        # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate #enable approximate matches for completion

# Add wisely, as too many plugins slow down shell startup.
plugins=(
  zsh-autosuggestions
  dirhistory
  zsh-navigation-tools
  git
  ssh
  npm
  pip
  python
  copyfile
  copypath
  copybuffer
  uv
  # vi-mode #NOTE: this cause issue with dirhistory
)

# oh-my-zsh auto update, check updates in 7 days
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 7

source $ZSH/oh-my-zsh.sh

## Export git user for Docusaurus deployment
## with this, you don't need SSH keys to deploy
## this would be use your git username and your github_pat
## paste your github personal access token when github prompts for password
export GIT_USER=Cyber-Syntax

# -------------------------------------------------------------------
# Aliases
# -------------------------------------------------------------------

# My personal script aliases
alias copytovm="~/.local/share/linux-system-utils/automation/copy-repos-to-vm.sh"
alias fsmodmove="~/.local/share/linux-system-utils/games/fs_mod_move.sh"

# Tmux
alias t="tmux"
alias ta="tmux attach-session"
alias tkill="tmux kill-server"

# systemctl
alias systemctlnop="systemctl --no-pager -l"

# journalctl
alias journalctl_verbose="SYSTEMD_COLORS=1 journalctl --reverse --no-hostname | less -R"
alias journalctl_today="SYSTEMD_COLORS=1 journalctl --since=today --reverse --no-hostname | less -R"
alias journalctl_follow="SYSTEMD_COLORS=1 journalctl -f --no-hostname | less -R"
alias journalctl_boot="SYSTEMD_COLORS=1 journalctl -b --reverse --no-hostname | less -R"
alias journalctl_boot_follow="SYSTEMD_COLORS=1 journalctl -b -f --no-hostname | less -R"

# Docusaurus deployment alias
alias dinodeploy="yarn build & yarn deploy"
alias dinolocal="npm run start"

# Python project related aliases
alias va='source .venv/bin/activate'

# Standard Git aliases
alias gst="git status"
alias gb="git branch"
alias gco="git checkout"
alias gcmt="git commit -am"
alias gpl="git pull"
alias gp="git push"
alias gf="git fetch"
alias gfa='gf --all'
alias gdf="git diff"
alias adog="log --all --decorate --oneline --graph"

# advancade git aliases for my own repos
alias grebase="git fetch && git rebase"

# more advanced Git aliases
alias grebasemaster="git fetch upstream && git rebase upstream/master"
alias grebasemain="git fetch upstream && git rebase upstream/main"
alias gpushmain="git push origin main"
alias gpushmaster="git push origin master"
alias gpush_master_force_no_verify="git push origin master --no-verify --force"

# Other aliases
alias icat="kitten icat" # Kitty terminal image preview

# Neovim related aliases
alias n="nvim"

# General utility aliases
alias tp="trash-put"
alias c="clear"
alias h="history"
alias ff="fastfetch"
alias grep="grep --color=auto"
alias sudov="sudo -v"
alias e="eza -F --all"
alias e2="eza -F --all --long --sort=size --total-size --tree --level=2"
alias e2p="eza -F --all --long --sort=size --total-size --tree --level=2 --no-user"
alias e2_tree="eza -F --all --long --sort=size --total-size --tree --level=2 --no-user --no-permissions --no-filesize --no-time"
alias e3="eza -F --all --long --sort=size --total-size --tree --level=3"
alias e4="eza -F --all --long --sort=size --total-size --tree --level=4"
alias e5="eza -F --all --long --sort=size --total-size --tree --level=5"
alias ecl5="eza --no-user --no-time --no-permissions --no-filesize --no-git --tree --git-ignore --level=5"
alias ee="eza -F --all --long --sort=size --total-size --smart-group"
alias ez="eza -Tlahmo -L1 --sort=size --total-size --no-user --smart-group"
alias duh="du -sh * | sort -h"
alias duhdot="du -sh .[^.]* | sort -h"

# command auto-correction.
ENABLE_CORRECTION="true"

# -------------------------------------------------------------------
# USER CONFIGURATION
# -------------------------------------------------------------------
# XDG Base Directory Specification
export XDG_STATE_HOME="$HOME/.local/state"

# Default Apps
export EDITOR="nvim"
export VISUAL="nvim"
# Use neovim with `sudoedit` command
export SUDO_EDITOR="nvim"

# NVIDIA VAAPI Driver configuration
# https://github.com/elFarto/nvidia-vaapi-driver#direct-backend
export NVD_LOG=1
export NVD_BACKEND=direct # default

# NVIDIA CUDA Path
export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}

# Export this for development purposes
export CHROME_BIN="/usr/bin/brave-browser-stable"

# Disable % eof, prevent % print output when
# there is no newline on program output
unsetopt PROMPT_SP

# Additional keybindings
# Bind Ctrl+Space to accept autosuggestion (the escape sequence here may need adjustments depending on terminal emulator)
bindkey '^@' autosuggest-accept

# this is for home and end keys
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# Home
bindkey '\e[H' beginning-of-line
bindkey '\eOH' beginning-of-line
# End
bindkey '\e[F' end-of-line
bindkey '\eOF' end-of-line

# this is for ctrl+arrow keys
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# this is undo tab completion with ctrl+z
bindkey '^Z' undo

# -------------------------------------------------------------------
# Extra shell initialization
# -------------------------------------------------------------------

# Initialize zoxide for fast directory navigation.
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# uv auto completions
eval "$(uv generate-shell-completion zsh)"

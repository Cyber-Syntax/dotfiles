# Path to your Oh My Zsh installation.
export ZSH="$HOME/.config/oh-my-zsh"
ZSH_CUSTOM="$HOME/.config/oh-my-zsh/custom"

# Switched to starship because powerlevel10k stop maintenance
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

# # If you come from bash you might have to change your $PATH.
export PATH=$HOME/.local/bin:/usr/local/bin:$PATH
# export cargo
export PATH="$HOME/.local/share/cargo/bin:$PATH"

# -------------------------------------------------------------------
# Added by AutoTarCompress to enable shell completion
fpath=(/home/developer/.config/zsh/completions $fpath)
# Completion and compinit: autoload and initialize completion.
# -------------------------------------------------------------------
autoload -Uz compinit && compinit
# -------------------------------------------------------------------
# History
# -------------------------------------------------------------------
# Set history file path and limits.
# HISTFILE="$HOME/.histfile" # This already in .zshenv
HISTFILE="$HOME/.config/zsh/.zsh_history"
HISTSIZE=20000
SAVEHIST=10000

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

zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate #enable approximate matches for completion

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
# -------------------------------------------------------------------
# Aliases
# -------------------------------------------------------------------

# Tmux
alias t="tmux"

## journalctl
alias journalctl_verbose="SYSTEMD_COLORS=1 journalctl --reverse --no-hostname | less -R"
alias journalctl_today="SYSTEMD_COLORS=1 journalctl --since=today --reverse --no-hostname | less -R"
alias journalctl_follow="SYSTEMD_COLORS=1 journalctl -f --no-hostname | less -R"
alias journalctl_boot="SYSTEMD_COLORS=1 journalctl -b --reverse --no-hostname | less -R"
alias journalctl_boot_follow="SYSTEMD_COLORS=1 journalctl -b -f --no-hostname | less -R"

## Export git user for Docusaurus deployment
## with this, you don't need SSH keys to deploy
## this would be use your git username and your github_pat
## paste your github personal access token when github prompts for password
export GIT_USER=Cyber-Syntax

# linutil aliases
alias copytovm="~/Documents/my-repos/linux-system-utils/automation/copy-repos-to-vm.sh"
alias fsmodmove="~/Documents/my-repos/linux-system-utils/games/fs_mod_move.sh"

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
alias icat="kitten icat"  # Kitty terminal image preview

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
alias e3="eza -F --all --long --sort=size --total-size --tree --level=3"
alias ee="eza -F --all --long --sort=size --total-size --smart-group"
alias ez="eza -Tlahmo -L1 --sort=size --total-size --no-user --smart-group"
alias duh="du -sh * | sort -h"
alias duhdot="du -sh .[^.]* | sort -h"


# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 7

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# ~/.config/oh-my-zsh/custom/plugins/

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate $HOME/.config/oh-my-zsh"

# -------------------------------------------------------------------
# Extra shell initialization
# -------------------------------------------------------------------

# Bind Ctrl+Space to accept autosuggestion (the escape sequence here may need adjustments depending on terminal emulator)
bindkey '^@' autosuggest-accept

# Enable wayland on kitty if running on wayland
if [ "$WAYLAND_DISPLAY" ]; then
  export KITTY_ENABLE_WAYLAND=1
fi
# force x11 kitty -o "linux_display_server=x11"

# Additional keybindings

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

# delete last word with ctrl+w(seems like default?)
# bindkey '^W' backward-kill-word
# bindkey '^[[Z' reverse-menu-complete

# environment variables
# https://github.com/elFarto/nvidia-vaapi-driver#direct-backend
export NVD_LOG=1
export NVD_BACKEND=direct # default

# CUDA path
export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}

export SUDO_EDITOR="nvim"

# Export this for development purposes
export CHROME_BIN="/usr/bin/brave-browser-stable"

# # Add custom Rofi scripts directory to PATH.
# export PATH="$HOME/.config/rofi/scripts:$PATH"
#
# # Add the user's local bin directory (as defined by xdg-user-dir) to PATH.
# export PATH="$PATH:$(xdg-user-dir USER)/.local/bin"

# Initialize zoxide for fast directory navigation.
if command -v zoxide > /dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# uv auto completions
eval "$(uv generate-shell-completion zsh)"

# Load Angular CLI autocompletion.
# source <(ng completion script)

# Added by my-unicorn installer
export PATH="$HOME/.local/bin:$PATH"

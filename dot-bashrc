#Auto start with xinitrc
#export PATH="/home/developer/.local/bin:$PATH"
# export GTK_PATH=$GTK_PATH:/usr/lib64/gtk-3.0
# export GTK_PATH=$GTK_PATH:/usr/lib64/gtk-2.0
#
# export .local/bin to PATH for appman script
#TODO: testing them in .zshrc
#export PATH=$PATH:$(xdg-user-dir USER)/.local/bin
#export PATH=$(echo $PATH | tr ":" "\n" | grep -v "/.local/bin" | tr "\n" ":" | sed s/.$//)

# Vimix-white-cursors
# export XCURSOR_PATH=${XCURSOR_PATH}:~/.local/share/icons
# export PATH=$(echo $PATH | tr ":" "\n" | grep -v "/.local/bin" | tr "\n" ":" | sed s/.$//)

# Use zsh as default shell, fallback to bash if zsh not available
if [[ $(ps --no-header --pid=$PPID --format=cmd) != "zsh" ]]; then
  if command -v zsh >/dev/null 2>&1; then
    exec zsh
  else
    echo "zsh not found, using bash instead"
  fi
fi

# exec zsh

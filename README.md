
# My personal dotfiles
>
> This is my personal dotfiles maintainent with GNU Stow.
> I switch from bare repository.

## How to use it?

```bash
# below represent stow --dotfiles --target="$HOME" --ignore=.stowrc
stow .
# This would send the qtile, nvim to ~/.config/qtile etc.
# Also it send the dot files like dot-bashrc etc to $HOME/.bashrc
```

## Ignore Files

Currently I use .gitignore for the not important files.

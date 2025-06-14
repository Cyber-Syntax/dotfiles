
# My personal dotfiles
>
> This is my personal dotfiles maintainent with GNU Stow.
> I switch from bare repository.

## How to use it?

### Use script to deploy
>
> Written a basic script to automate deploying for gnu stow
> This would dry-run stow first to show what would change
> than it would ask confirmation to deploy the configs

```bash
sh deploy.sh
```

### Older manual version with .stowrc

```bash
# below represent stow --dotfiles --target="$HOME" --ignore=.stowrc
stow .
# This would send the qtile, nvim to ~/.config/qtile etc.
# Also it send the dot files like dot-bashrc etc to $HOME/.bashrc
```

## Ignore Files

Currently I use .gitignore for the not important files.

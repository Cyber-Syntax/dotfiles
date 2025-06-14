
# My personal dotfiles
>
> I've moved to using GNU Stow for my personal dotfiles maintenance instead of a bare repository.

# How to setup your dotfiles with GNU stow?
>
> [!CAUTION]
> Backup your files!
>
> Always `cd ~/dotfiles` dir before any stow command
>

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

7. make alias, zsh alias or bash. Also, stowrc alias too.
make a file ~/dotfiles/.stowrc

```bash
--dotfiles
--target="$HOME"
--ignore=.stowrc
```

8. stow files to symlink

> [!WARNING]
> stay on the ~/dotfiles dir or it will cause issue
>

```bash
cd ~/dotfiles &
stow .
```

## How to use it?

### Use script to deploy
>
> [!NOTE]
>
> Copy the files you want to use stow to make symlink than start the script.
>
> This would dry run Stow first to show what would change,
> then it would ask for confirmation to deploy the configurations.

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

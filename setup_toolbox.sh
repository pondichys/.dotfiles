#!/bin/bash
#
# set -xe # for debugging
#

# Defining git_global_config function
git_global_config() {
  tput setaf 3
  echo "Enter your git username: "
  read git_username
  echo "Enter your git email: "
  read git_email
  tput sgr0
	echo "Set username and email ..."
	git config --global user.name "${git_username}"
	git config --global user.email "${git_email}"
	echo "Set and configure delta as diff viewer ..."
	git config --global core.pager "delta"
	git config --global interactive.difffilter "delta --color-only"
	git config --global delta.navigate "true"
	git config --global delta.light "false"
	git config --global delta.line-numbers "true"
	git config --global delta.side-by-side "true"
	git config --global merg.conflictstyle "diff3"
	git config --global diff.colormoved "default"
	echo "Set default branch to main ..."
	git config --global init.defaultbranch "main"
	echo
}

# Main script
echo
tput setaf 2
echo "################################################################"
echo "############### Install "
echo "###############      * zsh-autosuggestions" 
echo "###############      * zsh-syntaxhighlighting"
echo "###############      * zsh-completions"
echo "################################################################"
echo
tput sgr0
echo
sudo pacman -S --noconfirm --needed \
	zsh-autosuggestions \
	zsh-syntax-highlighting \
	zsh-completions

tput setaf 2
echo "################################################################"
echo "############### Create ~/.config directory"
echo "################################################################"
tput sgr0
if [ ! -d "$HOME/.config" ]; then
	mkdir "$HOME/.config"
	echo "$HOME/.config directory created"
else
	echo "$HOME/.config directory already exists -> nothing to do!"
fi

echo
tput setaf 2
if [ ! -d "$HOME/.dotfiles" ]; then
	echo "Cloning .dotfiles repository"
	git clone https://github.com/pondichys/.dotfiles
fi
cd "$HOME/.dotfiles" || exit 1
echo "Switching to arch-toolbox branch ..."
git switch arch-toolbox
echo "Creating symbolic links for zsh, starship and tmux"
stow -t "$HOME" zsh starship tmux
tput sgr0

echo
tput setaf 2
echo "################################################################"
echo "############### Configure global git options"
echo "################################################################"
tput sgr0
git_global_config
tput setaf 2
echo "Done"
tput sgr0
echo

echo
tput setaf 2
echo "################################################################"
echo "############### Configure terraform plugin cache"
echo "################################################################"
tput sgr0
if [ -d "$HOME/.terraform.d/plugin-cache" ]; then
	echo "terraform plugin cache already exists"
else
	mkdir -p "$HOME/.terraform.d/plugin-cache"
fi
tput sgr0
echo

echo
tput setaf 2
echo "################################################################"
echo "############### Installing node.js for neovim Mason ..."
echo "################################################################"
tput sgr0
fnm install --latest
echo

echo
tput setaf 2
echo "################################################################"
echo "############### Configure AWS CLI with profile stib-root"
echo "################################################################"
tput sgr0
if [ ! -d "$HOME/.aws" ]; then
	aws configure --profile stib-root
else
	echo ".aws directory found in HOME -> nothing to do!"
fi

echo
tput setaf 6
echo "################################################################"
echo "############### Done"
echo "################################################################"
tput sgr0
echo

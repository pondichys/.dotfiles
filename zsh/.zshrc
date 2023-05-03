# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt extendedglob nomatch
unsetopt autocd beep notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/seb/.zshrc'

# Initialisation of the completion engine
autoload -Uz compinit
compinit
# End of lines added by compinstall

if [ -f ~/.zshrc-personal ] ; then
	source ~/.zshrc-personal
fi

# fnm
export PATH="/home/seb/.local/share/fnm:$PATH"
eval "`fnm env`"
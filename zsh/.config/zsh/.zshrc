#!/usr/bin/env zsh

# ZSH options - see man zshoptions for more info
# setopt AUTO_CD					# Go to folder path without using cd.
setopt AUTO_PUSHD				# Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS			# Do not store duplicates in the stack.
setopt PUSHD_SILENT				# Do not print the directory stack after pushd or popd.

setopt CORRECT					# Spelling correction.
setopt EXTENDED_GLOB				# Use extended globbing syntax.

setopt AUTO_LIST				# Automatically list choices on ambiguous completion.
setopt AUTO_MENU				# Automatically use menu completion.
setopt ALWAYS_TO_END				# Move cursor to end if word had one match.

setopt SHARE_HISTORY				# Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST			# Expire a duplicate event first when cleaning history.
setopt HIST_IGNORE_DUPS				# Do not record duplicate events.
setopt HIST_IGNORE_ALL_DUPS			# Delete an old recorded event if a new one is a duplicate.
setopt HIST_FIND_NO_DUPS			# Do not display a previously found event.
setopt HIST_IGNORE_SPACE			# Do not record events starting with a space.
setopt HIST_SAVE_NO_DUPS			# Do not save duplicate events in history file.
setopt HIST_VERIFY				# Do not execute immediately upon history expansion.

setopt NO_BEEP					# Because beeps are annoying.

# Completions
zmodload zsh/complist				# Loads complist module that provides menu list for completions.
autoload -Uz compinit; compinit			# Load compinit file as function and run it.
_comp_options+=(globdots)			# Include hidden files.

zstyle ':completion:*:*:*:*:*' menu select	# Select completions with arrow keys.

#Load plugins
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh] 
then
	source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]
then
	source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Source useful aliases
source "$ZDOTDIR/zsh_aliases"

# Source useful functions
source "$ZDOTDIR/zsh_functions"

# Key bindings
bindkey -e				# Use emacs style key binding.

# Adapt PATH if directory /usr/local/go/bin is present
if [[ -d /usr/local/go/bin ]]; then
	export PATH=$PATH:/usr/local/go/bin
fi

# Scaleway CLI autocomplete initialization.
if command -v scw &> /dev/null
then
	eval "$(scw autocomplete script shell=zsh)"
fi

# zoxide initialization
if command -v zoxide &> /dev/null
then
	eval "$(zoxide init zsh)"
fi

# Initialize starship prompt if the starship command is found.
if command -v starship &> /dev/null
then
	eval "$(starship init zsh)"
fi

# fnm
export PATH="/home/seb/.local/share/fnm:$PATH"
eval "`fnm env`"

# Run fastfetch if installed
if command -v fastfetch &> /dev/null
then
	fastfetch
fi

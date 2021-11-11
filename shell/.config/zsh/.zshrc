# zsh configuration

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.local/share/oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="jispwoso"

# Plugins ('~/.oh-my-zsh/plugins/*' and '~/.oh-my-zsh/custom/plugins')
[ -d $ZSH/custom/plugins/zsh-syntax-highlighting ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH/custom/plugins/zsh-syntax-highlighting
plugins=(git sudo zsh-syntax-highlighting vi-mode)

# Oh my zsh
[ -e $ZSH/oh-my-zsh.sh ] && source $ZSH/oh-my-zsh.sh

# History settings
setopt share_history
HISTSIZE=10000000
SAVEHIST=10000000
HISTORY_IGNORE="(ls|exit|pwd|clear|history|cd)"
[ -d $HOME/.cache/shell ] || mkdir -p $HOME/.cache/shell
HISTFILE=$HOME/.cache/shell/zsh_history
zshaddhistory() { whence ${${(z)1}[1]} >| /dev/null || return 1 } # Ignore failed commands

# Add aliases
[ -e $HOME/.config/shell/aliasrc ] && source $HOME/.config/shell/aliasrc
# Add functions
[ -e $HOME/.config/shell/functionrc ] && source $HOME/.config/shell/functionrc
# Add rclone functions
[ -e $HOME/.config/rclone/rclone_func ] && source $HOME/.config/rclone/rclone_func

# stamp shown in the history command output.
HIST_STAMPS="%d-%m-%y %T"

# fzf
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh

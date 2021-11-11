# Mix of "gentoo" and "intika" themes

ZSH_THEME_GIT_PROMPT_PREFIX=" (%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"
ZSH_THEME_GIT_PROMPT_DIRTY="$FG[130] ✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ±%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[cyan]%} ▴%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[magenta]%} ▾%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✓%{$reset_color%}"

function prompt_char {
	if [ $UID -eq 0 ]; then echo "#"; else echo $; fi
}

# PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%}%n@)%m %{$fg_bold[blue]%}%(!.%1~.%~) $(git_prompt_info)$(prompt_char)%{$reset_color%} '
PROMPT='%(?,$FG[022][R-$?],$FG[130][$?])$FG[024][!%!] %(!.%{$fg_bold[red]%}.%{$fg_bold[green]%}%n@)%m %{$fg_bold[blue]%}%(!.%1~.%~) $(git_prompt_info)$(prompt_char)%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=") "

# RPROMPT='$FG[059][%~]$FG[059][%D/%*]%(?,$FG[022][R-$?],$FG[130][$?])$FG[024][!%!]%{$reset_color%}'  # original with path
# RPROMPT='$FG[059][%D/%*]%(?,$FG[022][R-$?],$FG[130][$?])$FG[024][!%!]%{$reset_color%}'          # without path
# RPROMPT='%(?,$FG[022][R-$?],$FG[130][$?])$FG[024][!%!]%{$reset_color%}'          # without path

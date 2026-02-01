# robbyrussell-plusplus is a fork of the robbyrussell theme but with a few small tweaks
# 1) the prefix -> no longer uses -> and uses a checkmark for success and a X for failure
# 2) rather than the name of the current directory, show the absolute path (with home represented as ~)
# 3) the last char is no longer X but $
PROMPT="%(?:%{$fg_bold[green]%}%1{✓%} :%{$fg_bold[red]%}%1{✘%} ) %{$fg[cyan]%}%~%{$reset_color%}"
PROMPT+=' $(git_prompt_info)'
PROMPT+="%{$fg[yellow]%}%1{$%}%{$reset_color%} "

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✘%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

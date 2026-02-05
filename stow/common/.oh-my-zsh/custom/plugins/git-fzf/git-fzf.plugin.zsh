# git-fzf - fuzzy find git objects with fzf
#
# Triggers (require space before):
#   gb<tab> - local branches
#   gw<tab> - worktrees
#   gt<tab> - tags
#   gc<tab> - commits (shows hash + message, inserts hash)
#   gf<tab> - changed files (shows status + file, inserts file)
#   gp<tab> - GitHub PRs (shows PR list, inserts PR number)

typeset -gA _git_fzf

__git_fzf_branch() {
  git branch --sort=-committerdate --format='%(refname:short)' 2>/dev/null | fzf --height=40% --reverse
}

__git_fzf_worktree() {
  git worktree list 2>/dev/null | fzf --height=40% --reverse | awk '{print $1}'
}

__git_fzf_tag() {
  git tag 2>/dev/null | fzf --height=40% --reverse
}

__git_fzf_commit() {
  git log --oneline --color=always 2>/dev/null | fzf --height=40% --reverse --ansi | awk '{print $1}'
}

__git_fzf_file() {
  # Exclude untracked files (??), NF handles renamed files (R old -> new)
  # -m allows multi-select, tr converts newlines to spaces
  git status --short 2>/dev/null | grep -v '^??' | fzf --height=40% --reverse -m | awk '{print $NF}' | tr '\n' ' ' | sed 's/ $//'
}

__git_fzf_pr() {
  gh pr list 2>/dev/null | fzf --height=40% --reverse | awk '{print $1}' | tr -d '#'
}

_git_fzf_complete() {
  local lbuf="$LBUFFER"
  local selection

  # Check for triggers - require space before or at start of line
  if [[ "$lbuf" == "gb" || "$lbuf" == *" gb" ]]; then
    LBUFFER="${lbuf% gb}"
    [[ "$lbuf" == "gb" ]] && LBUFFER=""
    selection=$(__git_fzf_branch)
    [[ -n "$selection" ]] && LBUFFER+="${LBUFFER:+ }$selection"
    zle reset-prompt
    return
  elif [[ "$lbuf" == "gw" || "$lbuf" == *" gw" ]]; then
    LBUFFER="${lbuf% gw}"
    [[ "$lbuf" == "gw" ]] && LBUFFER=""
    selection=$(__git_fzf_worktree)
    [[ -n "$selection" ]] && LBUFFER+="${LBUFFER:+ }$selection"
    zle reset-prompt
    return
  elif [[ "$lbuf" == "gt" || "$lbuf" == *" gt" ]]; then
    LBUFFER="${lbuf% gt}"
    [[ "$lbuf" == "gt" ]] && LBUFFER=""
    selection=$(__git_fzf_tag)
    [[ -n "$selection" ]] && LBUFFER+="${LBUFFER:+ }$selection"
    zle reset-prompt
    return
  elif [[ "$lbuf" == "gc" || "$lbuf" == *" gc" ]]; then
    LBUFFER="${lbuf% gc}"
    [[ "$lbuf" == "gc" ]] && LBUFFER=""
    selection=$(__git_fzf_commit)
    [[ -n "$selection" ]] && LBUFFER+="${LBUFFER:+ }$selection"
    zle reset-prompt
    return
  elif [[ "$lbuf" == "gf" || "$lbuf" == *" gf" ]]; then
    LBUFFER="${lbuf% gf}"
    [[ "$lbuf" == "gf" ]] && LBUFFER=""
    selection=$(__git_fzf_file)
    [[ -n "$selection" ]] && LBUFFER+="${LBUFFER:+ }$selection"
    zle reset-prompt
    return
  elif [[ "$lbuf" == "gp" || "$lbuf" == *" gp" ]]; then
    LBUFFER="${lbuf% gp}"
    [[ "$lbuf" == "gp" ]] && LBUFFER=""
    selection=$(__git_fzf_pr)
    [[ -n "$selection" ]] && LBUFFER+="${LBUFFER:+ }$selection"
    zle reset-prompt
    return
  fi

  # Fallback to saved widget
  local km="${KEYMAP:-main}"
  local orig_widget="${_git_fzf[orig_widget_$km]}"
  [[ -z "$orig_widget" && "$km" != "main" ]] && orig_widget="${_git_fzf[orig_widget_main]}"

  if [[ -n "$orig_widget" && "$orig_widget" != "_git_fzf_complete" ]]; then
    zle "$orig_widget"
  else
    zle expand-or-complete
  fi
}

zle -N _git_fzf_complete

# Save current ^I binding and rebind
() {
  local keymap binding orig_widget
  local -a keymaps=(main emacs viins vicmd visual)

  for keymap in $keymaps; do
    binding=$(bindkey -M "$keymap" '^I' 2>/dev/null) || binding=""
    orig_widget="${binding##* }"
    if [[ -n "$binding" && -n "$orig_widget" && "$orig_widget" != "^I" ]]; then
      _git_fzf[orig_widget_$keymap]="$orig_widget"
    fi
    bindkey -M $keymap '^I' _git_fzf_complete
  done
}

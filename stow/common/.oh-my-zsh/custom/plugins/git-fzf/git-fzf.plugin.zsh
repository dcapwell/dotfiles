# git-fzf - fuzzy find git objects with fzf
#
# Triggers (require space before):
#   gb<tab> - local branches
#   gw<tab> - worktrees
#   gt<tab> - tags
#   gc<tab> - commits (shows hash + message, inserts hash)
#   gf<tab> - changed files (shows status + file, inserts file)
#   gp<tab> - GitHub PRs (shows PR list, inserts PR number)

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

_git_fzf_complete_inner() {
  local lbuf="$LBUFFER"
  local selection

  # Check for triggers - require space before or at start of line
  if [[ "$lbuf" == "gb" || "$lbuf" == *" gb" ]]; then
    LBUFFER="${lbuf% gb}"
    [[ "$lbuf" == "gb" ]] && LBUFFER=""
    selection=$(__git_fzf_branch)
  elif [[ "$lbuf" == "gw" || "$lbuf" == *" gw" ]]; then
    LBUFFER="${lbuf% gw}"
    [[ "$lbuf" == "gw" ]] && LBUFFER=""
    selection=$(__git_fzf_worktree)
  elif [[ "$lbuf" == "gt" || "$lbuf" == *" gt" ]]; then
    LBUFFER="${lbuf% gt}"
    [[ "$lbuf" == "gt" ]] && LBUFFER=""
    selection=$(__git_fzf_tag)
  elif [[ "$lbuf" == "gc" || "$lbuf" == *" gc" ]]; then
    LBUFFER="${lbuf% gc}"
    [[ "$lbuf" == "gc" ]] && LBUFFER=""
    selection=$(__git_fzf_commit)
  elif [[ "$lbuf" == "gf" || "$lbuf" == *" gf" ]]; then
    LBUFFER="${lbuf% gf}"
    [[ "$lbuf" == "gf" ]] && LBUFFER=""
    selection=$(__git_fzf_file)
  elif [[ "$lbuf" == "gp" || "$lbuf" == *" gp" ]]; then
    LBUFFER="${lbuf% gp}"
    [[ "$lbuf" == "gp" ]] && LBUFFER=""
    selection=$(__git_fzf_pr)
  else
    return 1  # No trigger matched
  fi

  # Insert selection if one was made
  [[ -n "$selection" ]] && LBUFFER+="${LBUFFER:+ }$selection"
  # Don't call zle reset-prompt here - let caller handle it
  return 0
}

_git_fzf_complete() {
  if _git_fzf_complete_inner; then
    zle reset-prompt
    return
  fi
  # Fall back to fzf completion (preserves **<tab> behavior)
  if (( $+widgets[fzf-completion] )); then
    zle fzf-completion
  else
    zle ${fzf_default_completion:-expand-or-complete}
  fi
}

zle -N _git_fzf_complete
# Bind ^I - cassandra-fzf will override this if loaded after
bindkey '^I' _git_fzf_complete

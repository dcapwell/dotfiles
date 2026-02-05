# git-cam - auto-message commit trigger
#
# Trigger:
#   git cam<tab>       - expands to: git cam "$(git auto-message)"
#   git cam <args><tab> - expands to: git cam <args> "$(git auto-message)"
#
# Requires:
#   git-auto-message script in PATH (uses ollama to generate commit messages)

typeset -gA _git_cam

_git_cam_complete() {
  local lbuf="$LBUFFER"

  # Match "git cam" with optional trailing space and args
  if [[ "$lbuf" == "git cam" || "$lbuf" == *" git cam" || "$lbuf" == "git cam "* || "$lbuf" == *" git cam "* ]]; then
    # Trim trailing whitespace before appending
    LBUFFER="${lbuf%% }"
    LBUFFER+=' "$(git auto-message)"'
    zle reset-prompt
    return
  fi

  # Fallback to saved widget
  local km="${KEYMAP:-main}"
  local orig_widget="${_git_cam[orig_widget_$km]}"
  [[ -z "$orig_widget" && "$km" != "main" ]] && orig_widget="${_git_cam[orig_widget_main]}"

  if [[ -n "$orig_widget" && "$orig_widget" != "_git_cam_complete" ]]; then
    zle "$orig_widget"
  else
    zle expand-or-complete
  fi
}

zle -N _git_cam_complete

# Save current ^I binding and rebind
() {
  local keymap binding orig_widget
  local -a keymaps=(main emacs viins vicmd visual)

  for keymap in $keymaps; do
    binding=$(bindkey -M "$keymap" '^I' 2>/dev/null) || binding=""
    orig_widget="${binding##* }"
    if [[ -n "$binding" && -n "$orig_widget" && "$orig_widget" != "^I" ]]; then
      _git_cam[orig_widget_$keymap]="$orig_widget"
    fi
    bindkey -M $keymap '^I' _git_cam_complete
  done
}

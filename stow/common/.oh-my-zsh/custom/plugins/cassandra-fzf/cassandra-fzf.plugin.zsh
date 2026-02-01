# cassandra-fzf - fuzzy find Cassandra test files and convert to class names
#
# Triggers (require space before):
#   ct<tab> - test files (shows path, inserts Java class name)
#
# Example:
#   test/unit/org/apache/cassandra/index/sai/utils/IndexTermTypeTest.java
#   → org.apache.cassandra.index.sai.utils.IndexTermTypeTest

__cassandra_fzf_testclass() {
  local selected
  selected=$(fd -t f '\.java$' test 2>/dev/null | fzf --height=40% --reverse)
  [[ -z "$selected" ]] && return

  # Transform: test/unit/org/.../Foo.java → org...Foo
  # Simulator is special: test/simulator/test/org/... → strip test/simulator/test/
  # 1. Remove test/<type>/ prefix (first two path components)
  # 2. If still starts with test/, remove that too (simulator case)
  # 3. Remove .java suffix
  # 4. Replace / with .
  local result="${selected#test/*/}"  # Remove test/<type>/
  result="${result#test/}"             # Remove extra test/ (simulator)
  result="${result%.java}"             # Remove .java
  echo "${result//\//.}"               # Replace / with .
}

_cassandra_fzf_complete() {
  local lbuf="$LBUFFER"
  local selection

  # Check for cassandra trigger - require space before or at start of line
  if [[ "$lbuf" == "ct" || "$lbuf" == *" ct" ]]; then
    LBUFFER="${lbuf% ct}"
    [[ "$lbuf" == "ct" ]] && LBUFFER=""
    selection=$(__cassandra_fzf_testclass)
    [[ -n "$selection" ]] && LBUFFER+="${LBUFFER:+ }$selection"
    zle reset-prompt
  # Check for git-fzf triggers
  elif (( $+functions[_git_fzf_complete_inner] )) && _git_fzf_complete_inner; then
    zle reset-prompt
  else
    # Fall back to fzf-completion
    if (( $+widgets[fzf-completion] )); then
      zle fzf-completion
    else
      zle ${fzf_default_completion:-expand-or-complete}
    fi
  fi
}

zle -N _cassandra_fzf_complete
bindkey '^I' _cassandra_fzf_complete

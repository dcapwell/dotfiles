# cassandra-fzf - fuzzy find Cassandra test files and convert to class names
#
# Triggers (require space before):
#   ct<tab> - test files (shows path, inserts Java class name)
#
# Example:
#   test/unit/org/apache/cassandra/index/sai/utils/IndexTermTypeTest.java
#   → org.apache.cassandra.index.sai.utils.IndexTermTypeTest

typeset -gA _cassandra_fzf

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
    return
  fi

  # Fallback to saved widget
  local km="${KEYMAP:-main}"
  local orig_widget="${_cassandra_fzf[orig_widget_$km]}"
  [[ -z "$orig_widget" && "$km" != "main" ]] && orig_widget="${_cassandra_fzf[orig_widget_main]}"

  if [[ -n "$orig_widget" && "$orig_widget" != "_cassandra_fzf_complete" ]]; then
    zle "$orig_widget"
  else
    zle expand-or-complete
  fi
}

zle -N _cassandra_fzf_complete

# Save current ^I binding and rebind
() {
  local keymap binding orig_widget
  local -a keymaps=(main emacs viins vicmd visual)

  for keymap in $keymaps; do
    binding=$(bindkey -M "$keymap" '^I' 2>/dev/null) || binding=""
    orig_widget="${binding##* }"
    if [[ -n "$binding" && -n "$orig_widget" && "$orig_widget" != "^I" ]]; then
      _cassandra_fzf[orig_widget_$keymap]="$orig_widget"
    fi
    bindkey -M $keymap '^I' _cassandra_fzf_complete
  done
}

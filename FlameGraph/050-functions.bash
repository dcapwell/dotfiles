javaflame() {
  local -r path="$1"

  flamegraph.pl --color java "$path" > "$path.svg"
}

javaflame_diff() {
  local -r name="$1"
  local -r first="$2"
  local -r second="$3"

  difffolded.pl "$first" "$second" | flamegraph.pl > "${name}.svg"
  difffolded.pl -n "$second" "$first" | flamegraph.pl --negate > "${name}-negate.svg"
}

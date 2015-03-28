# Tries to open the given path in Intellij (idea)
# If no arguments given, assumes $PWD
intellij() {
  local readonly path="${1:$PWD}"
  if is_osx ; then
    open -a "$(ls -rd /Applications/IntelliJ\ IDEA\ * | head -n1)" "$path"
  else
    echo -e "Command not supported yet on linux.  Please fix =D" 1>&2
    return 1
  fi
}

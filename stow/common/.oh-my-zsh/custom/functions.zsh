# remove a element from the current PATH
remove_from_path() {
  export PATH=$(echo "$PATH" | sed -E -e "s;:$1;;" -e "s;$1:?;;")
}

# Create a new directory and enter it
mkd() {
  mkdir -p "$@" && cd "$_"
}

if is_osx ; then
  # solution from http://superuser.com/questions/490425/how-do-i-switch-between-java-7-and-java-6-on-os-x-10-8-2
  # format:
  ## setjdk 1.6
  ## setjdk 1.7
  ## setjdk 1.8
  setjdk() {
    if [ $# -ne 0 ]; then
      remove_from_path '/System/Library/Frameworks/JavaVM.framework/Home/bin'
      if [[ ! -z "${JAVA_HOME:-}" ]]; then
        remove_from_path "$JAVA_HOME/bin"
      fi
      local version="$1"
      # some JDKs only match as 1.8 and others are 8... so if 8 is used attempt to find the "best" version
      if [[ "$version" == "8" ]]; then
        /usr/libexec/java_home --failfast -v 8 &> /dev/null || version="1.8"
      elif [[ "$version" == "1.8" ]]; then
        /usr/libexec/java_home --failfast -v "1.8" &> /dev/null || version="8"
      fi
      export JAVA_HOME=$(/usr/libexec/java_home -v "$version")
      export PATH="$PATH:$JAVA_HOME/bin"
    fi
    echo "JAVA_HOME set to $JAVA_HOME"
    java -version
  }

  # Default to jdk 11
  setjdk 11
fi

if is_osx ; then
  # solution from http://superuser.com/questions/490425/how-do-i-switch-between-java-7-and-java-6-on-os-x-10-8-2
  # format:
  ## setjdk 1.6
  ## setjdk 1.7
  ## setjdk 1.8
  setjdk() {
    if [ $# -ne 0 ]; then
      remove_from_path '/System/Library/Frameworks/JavaVM.framework/Home/bin'
      if [ -n "${JAVA_HOME+x}" ]; then
        remove_from_path "$JAVA_HOME/bin"
      fi
      export JAVA_HOME=$(/usr/libexec/java_home -v "$@")
      export PATH="$JAVA_HOME/bin:$PATH"
    fi
    echo "JAVA_HOME set to $JAVA_HOME"
    java -version
  }

  # Default to jdk 8
  setjdk 8
fi

jvm_memory_watch() {
  local -r pid="$1"
  jstat -gc -h10 "$pid" 1000 0 | awk '/^\s*[0-9]/ {printf "%-10s %-10s %-10s %-10s %-10s %-10s\n", int((100*$6)/$5), int((100*$8)/$7), $(NF-3), $(NF-2), $(NF-1), $NF}'
}

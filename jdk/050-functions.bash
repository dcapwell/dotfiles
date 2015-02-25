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
        remove_from_path "$JAVA_HOME"
      fi
      export JAVA_HOME=$(/usr/libexec/java_home -v "$@")
      export PATH="$JAVA_HOME/bin:$PATH"
    fi
    echo "JAVA_HOME set to $JAVA_HOME"
    java -version
  }

fi

#!/usr/bin/env bash

shopt -s expand_aliases

for path in $(find "$DOTFILE_HOME" -name "*.bash" | perl -e "print sort{(split '/', \$a)[-1] <=> (split '/', \$b)[-1]}<>")
do
  source "$path" &> /dev/null || true
done

#set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

usage() {
  cat <<EOF
Usage: $(basename $0) (options)* (--)? (ant arguments)*
Options:
  --clean               Cleanup the build
  --jvm|--jdk|--java    Use the desired JDK
  --rebuild             Shorthand for 'ant realclean && ant && ant generate-idea-files'
  --help                This help screen
EOF
exit 1
}
ORIGINAL_JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | awk -F. '{print $1}')

while [ $# -gt 0 ]; do
  case "$1" in
    --jvm|--jdk|--java)
      setjdk "$2"
      shift 2
      ;;
    --clean)
      rm -rf build
      shift
      ;;
    --rebuild)
      # ant realclean && ant && ant generate-idea-files 
      set -- "realclean" "jar" "generate-idea-files"
      break
      ;;
    -h|--help)
      usage
      ;;
    *|--)
      break
      ;;
  esac
done

JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | awk -F. '{print $1}')

if [[ "$ORIGINAL_JAVA_VERSION" != "$JAVA_VERSION" ]]; then
  echo "JVM changed from $ORIGINAL_JAVA_VERSION to $JAVA_VERSION; cleaning up"
  rm -rf build
fi

if [ "$JAVA_VERSION" -ge 11 ]; then
  export CASSANDRA_USE_JDK11=true
fi

ant "$@"

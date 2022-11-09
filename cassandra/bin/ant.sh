#!/usr/bin/env bash

shopt -s expand_aliases

for path in $(find "$DOTFILE_HOME" -name "*.bash" | perl -e "print sort{(split '/', \$a)[-1] <=> (split '/', \$b)[-1]}<>")
do
  source "$path" &> /dev/null || true
done

set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

if [ $# -ge 2 ] && [ "$1" == "--with-jvm" ]; then
  setjdk "$2"
  shift 2
fi

JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | awk -F. '{print $1}')

if [ "$JAVA_VERSION" -ge 11 ]; then
  export CASSANDRA_USE_JDK11=true
fi

ant "$@"

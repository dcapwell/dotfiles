#!/usr/bin/env bash

#set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

bin="$(cd "$(dirname "$0")" > /dev/null; pwd)"

_main() {
  for f in $(grep --files-with-matches --text -r --exclude 'test/data/*' 'System.exit' "$@"); do
    sed -i '' 's/System.exit/new Throwable("System.exit called!"); System.exit/g' "$f"
  done
}

_main "$@"

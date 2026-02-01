#!/usr/bin/env bash

#set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

bin="$(cd "$(dirname "$0")" > /dev/null; pwd)"

_main() {
  local -r pattern="$1"
  local -r other_dir="$2"

   vimdiff $(find . -name "$pattern") $(find "$other_dir" -name "$pattern")
}

_main "$@"

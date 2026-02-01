#!/usr/bin/env bash

#set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

bin="$(cd "$(dirname "$0")" > /dev/null; pwd)"

_main() {
  local sha
  # loop over args, executing as in order of execution
  while [ $# -gt 0 ]; do
    case "$1" in
      *)
        sha="$1"
        shift
        break
        ;;
    esac
  done
  for f in $(git show --pretty='format:' --name-only "$sha"); do
    git diff "$sha" "$f" || true
  done
}

_main "$@"

#!/usr/bin/env bash

#set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

bin="$(cd "$(dirname "$0")" > /dev/null; pwd)"

_main() {
  if ! type chdman &> /dev/null; then
    echo "chdman is not installed, do brew install rom-tools" 1>&2
    exit 1
  fi
  local -r backup="${1:-}"
  for file in *.cue; do 
    echo "Creating ${file%.*}.chd..."
    chdman createcd -i "${file%.*}.cue" -o "${file%.*}.chd"
    if [[ ! -z "${backup:-}" ]]; then
      echo "Moving ${file%.*}.cue and $(ls -1 "${file%.*}"*.bin) to $backup"
      mv  "${file%.*}.cue"  "${file%.*}"*.bin "$backup"
    fi
  done
}

_main "$@"

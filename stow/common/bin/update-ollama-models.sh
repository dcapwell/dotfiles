#!/usr/bin/env bash

#set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

bin="$(cd "$(dirname "$0")" > /dev/null; pwd)"

_main() {
  local model
  for model in $(ollama list | tail +2 | awk '{print $1}'); do
    echo "Updating $model"
    ollama pull "$model"
  done
}

_main "$@"

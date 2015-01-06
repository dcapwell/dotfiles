#!/usr/bin/env bash

set -e
set -o pipefail

bin=`dirname "$0"`
bin=`cd "$bin">/dev/null; pwd`

git_plugins=(
  "git://github.com/tpope/vim-sensible.git"
  "git@github.com:kien/rainbow_parentheses.vim.git"
  "git@github.com:guns/vim-clojure-static.git"
  "git@github.com:guns/vim-clojure-highlight.git"
  "git@github.com:tpope/vim-fireplace.git"
)

git_name() {
  basename "$1" | sed 's;.git;;g'
}

git_install() {
  local url="$1"
  local name=$(git_name "$url")

  cd ~/.vim/bundle
  if [ -d "$name" ]; then
    cd "$name"
    git pull
  else
    git clone "$1"
  fi
}

main() {
  # setup vim-pathogen and install the plugins through that
  mkdir -p ~/.vim/autoload ~/.vim/bundle
  wget --no-check-certificate -O ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

  for plugin in "${git_plugins[@]}"; do
    git_install "$plugin"
  done
}

main "$@"

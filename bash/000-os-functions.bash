# This set of functions are to abstract over *nix based systems

alias is_osx='[[ "$(uname -s)" == "Darwin" ]]'
alias is_linux='[[ "$(uname -s)" == "Linux" ]]'
alias is_rhel='type yum > /dev/null 2>&1'
alias is_ubuntu='type apt-get > /dev/null 2>&1'

# get the number of cpus on the current host
num_cpus() {
  case "$(uname -s)" in
    Darwin)
      sysctl hw.ncpu | awk '{print $2}'
      ;;
    *)
      echo "Unsupported system type: $(uname -s)" >&2
      return 1
      ;;
  esac
}

install_pkg() {
  # based off debian
  if type apt-get >/dev/null 2>&1 ; then
    sudo apt-get install -y "$@"
    return $?
  fi

  # based off rhel
  if type yum > /dev/null 2>&1 ; then
    sudo yum install -y "$@"
    return $?
  fi

  # osx
  if type brew > /dev/null 2>&1 ; then
    for pkg in "$@"
    do
      # check if installed first
      if ! brew ls -1 | grep "$pkg" > /dev/null ; then
        brew install -y "$pkg"
      fi
    done
    return $?
  fi

  echo "Unknown system package manager..." >&2
}

# This set of functions are to abstract over *nix based systems

alias is_osx='[[ "$(uname -s)" == "Darwin" ]]'
alias is_linux='[[ "$(uname -s)" == "Linux" ]]'

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


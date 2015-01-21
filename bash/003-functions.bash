# Print out the absolute path given a relative path
abspath() {
  echo $(cd $(dirname "$1"); pwd)/$(basename "$1")
}

# Run a command N times across a pool of threads
# N <command> <args>
parn() {
  if [[ "$1" == *[!0-9]* ]]; then 
    echo "Unable to run tasks, first input must be a number"
    return 1
  fi
  tasks=$1
  shift

  args="$@"
  par=$(echo "2 * $(num_cpus) " | bc)

  seq $tasks | xargs -n 1 -P $par bash -c "$args" bash
}

# Run a command N times sequentially
# N <command> <args>
runn() {
  if [[ "$1" == *[!0-9]* ]]; then 
    echo "Unable to run tasks, first input must be a number"
    return 1
  fi
  tasks=$1
  shift

  args="$@"

  seq $tasks | xargs -n 1 bash -c "$args" bash
}

# Creates a template script. The script will have a main function and fail-fast.
script-gen() {
  local name="$1"
  cat <<EOF > "$name"
#!/usr/bin/env bash

#set -x
set -e
set -o pipefail

bin=\$(cd \$(dirname "\$0") > /dev/null; pwd)

main() {
  # select action type
  # local action=\${1:-all}
  # case "\$action" in
  #   *)
  #     echo "Unknown action: \$action" 1>\&2
  #     exit 1
  #     ;;
  # esac

  # loop over args, executing as in order of execution
  # while [ \$# -gt 0 ]; do
  #   case "\$1" in
  #     *)
  #       break
  #       ;;
  #   esac
  # done
}

main "\$@"
EOF

  chmod a+x "$name"
}

# Updates a file with the current time, and opens it for editing
meeting_note() {
  if [ -e "$1" ]; then
    echo "" >> $1
  fi
  echo "=== $(date) ===" >> $1
  vim $1
}

# remove a element from the current PATH
removeFromPath() {
  export PATH=$(echo "$PATH" | sed -E -e "s;:$1;;" -e "s;$1:?;;")
}

clipboard() {
  case "$(uname -s)" in
    Linux)
      xclip -selection clipboard
      ;;
    Darwin)
      pbcopy
      ;;
    *)
      echo "Unable to find clipboard commands" 1>&2
      ;;
  esac
}

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

#set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

bin="\$(cd "\$(dirname "\$0")" > /dev/null; pwd)"

_main() {
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

_main "\$@"
EOF

  chmod a+x "$name"
  "${VISUAL:-"${EDITOR:-vi}"}" "$name"
}

# Updates a file with the current time, and opens it for editing
meeting_note() {
  if [ -e "$1" ]; then
    echo "" >> $1
  fi
  echo "=== $(date) ===" >> $1
  vim $1
}

# Create a markdown file about the given topic.  The date and name will be used to find the location of the file.
blog_post() {
  if [ $# -lt 1 ]; then
    echo "A title is needed to create a blog post"
    return 1
  fi
  local year=$(date +%Y)
  local month=$(date +%m)
  local day=$(date +%d)
  local title="$@"
  local dir="$year/$month/$day"
  local name="$(echo $title | tr -d '\n' | tr '[:space:]' '_').md"
  mkdir -p "$dir"
  cat > "$dir/$name" <<EOF
# $title
# Reference

[^1]:
EOF
  echo "$dir/$name"
}

# remove a element from the current PATH
remove_from_path() {
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

# Create a new directory and enter it
mkd() {
  mkdir -p "$@" && cd "$_";
}

# Start an HTTP server from a directory, optionally specifying the port
http_server() {
  local port="${1:-8000}"
  echo "Starting server http://localhost:$port"
  # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
  # And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
  python -c $'
import SimpleHTTPServer
map = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map
map[""] = "text/plain"
for key, value in map.items():
  map[key] = value + ";charset=UTF-8"
  SimpleHTTPServer.test()' "$port"
}

# Add color to stderr for a command given
# Example: color mvn clean test
# http://stackoverflow.com/questions/1763891/can-stdout-and-stderr-use-different-colors-under-xterm-konsole
color()(set -o pipefail;"$@" 2>&1>&3|sed $'s,.*,\e[31m&\e[m,'>&2)3>&1

password_gen() {
  if [ "$1" == "-" ]; then
    cat | md5 | perl -pe 's/(^|-)(\w)/\U$2/g'
  else
    echo "$1" | md5 | perl -pe 's/(^|-)(\w)/\U$2/g'
  fi
}

tmp_sandbox_cleanup() {
  if [ "${TMP_SANDBOX:-}" ]; then
    rm -rf "$TMP_SANDBOX"
    unset "$TMP_SANDBOX"
  fi
  if [ "${TMP_SANDBOX_ORIGIN_DIR}" ]; then
    cd "$TMP_SANDBOX_ORIGIN_DIR"
    unset "$TMP_SANDBOX_ORIGIN_DIR"
  fi
}

tmp_sandbox() {
  local readonly output_dir=$(mktemp -d -t "tmp_sandbox.XXXXXXXXXX")
  cd "$output_dir"
  export TMP_SANDBOX="$output_dir"
  export TMP_SANDBOX_ORIGIN_DIR="$PWD"
  trap tmp_sandbox_cleanup EXIT
  bash
}

bucket_count() {
  sort -g | uniq -c  | awk '{print $2, $1}'
}

_histogram() {
  local readonly histo="$(printf "%$(( ${COLUMNS} - 10 ))s\n" | sed 's/ /=/g')+"

  local key=""
  local value=""

  read key value

  while [ -n "$key" ] ; do
    # Use a default width of 70 for the histogram
    printf "%4s %s\n" "$key" "${histo:0:$value}"

    read key value
  done
}

histogram() {
  bucket_count | _histogram
}

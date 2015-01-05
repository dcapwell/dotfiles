# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"

# Reload the shell
alias reload="exec $SHELL -l"

# Runs curl as a JSON post request
alias curl-json="curl -X POST -H'Content-Type: application/json'"

# GNU Tree command built from linux primitives
alias ltree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g' | less"

# Always grep with color turned on
alias grep='grep --color'

# use GNU time rather than bash time
alias time=/usr/bin/time

# set bash to use vi mode rather than emacs mode
set -o vi

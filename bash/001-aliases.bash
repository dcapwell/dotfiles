# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."
alias ........="cd ../../../../../../.."
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

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

alias hex2dec='printf "%d\n"'

alias say='say -v Daniel'

alias download_latest='(ls -1trd ~/Downloads/* | tail -n 1)'
alias dl=download_latest

# Replace vim with NeoVim
alias vim=nvim
alias vi=nvim

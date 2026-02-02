# Replace vim with NeoVim
alias vim=nvim
alias vi=nvim

# Always grep with color turned on
alias grep='grep --color'

# Add simple command to find the latest file in downloads
alias download_latest='(ls -1trd ~/Downloads/* | tail -n 1)'
alias dl=download_latest

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

alias is_osx='[[ "$(uname -s)" == "Darwin" ]]'
alias is_linux='[[ "$(uname -s)" == "Linux" ]]'
alias is_rhel='type yum > /dev/null 2>&1'
alias is_ubuntu='type apt-get > /dev/null 2>&1'

# GNU Tree command built from linux primitives
alias ltree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g' | less"

# Hex to decimal conversion
alias hex2dec='printf "%d\n"'

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

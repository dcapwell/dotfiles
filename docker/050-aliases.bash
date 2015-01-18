# run the current directory in a docker container
# maven and gradle homes are also mounted
alias docker-env='docker run -t -i --rm -w $PWD -v $PWD:$PWD'

if type boot2docker >/dev/null 2>&1 ; then
  # restart boot2docker
  alias boot2docker-restart="boot2docker down && boot2docker up"
fi

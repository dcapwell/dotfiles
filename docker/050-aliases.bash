# run the current directory in a docker container
# maven and gradle homes are also mounted
alias docker-env='docker run -t -i --privileged --rm -w $PWD -v $PWD:$PWD'

alias dockerviz='docker run --rm -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz images -t'
alias dockviz='docker run --rm -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz images -t'

if type boot2docker >/dev/null 2>&1 ; then
  # restart boot2docker
  alias boot2docker-restart="boot2docker down && boot2docker up"
fi

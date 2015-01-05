# run the current directory in a docker container
# maven and gradle homes are also mounted
alias docker-env='docker run -t -i -w $PWD -v $PWD:$PWD -v $HOME/.m2:/root/.m2 -v $HOME/.gradle:/root/.gradle'

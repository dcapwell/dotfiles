# cleanup old containers that are no longer active
function docker_clean() {
  docker rm $(docker ps --all --no-trunc | awk '{print $1}' | egrep -v 'CONTAINER')
}

# stop all containers
function docker_stop_all() {
  docker stop $(docker ps | awk '{print $1}' | egrep -v "CONTAINER")
}

# kill all containers
function docker_kill_all() {
  docker kill $(docker ps | awk '{print $1}' | egrep -v "CONTAINER")
}

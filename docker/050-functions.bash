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

function docker_clean_images() {
  docker images | awk '{print $3}' | xargs docker rmi
}

function docker_clean_images_dangling() {
  docker rmi $(docker images -f dangling=true -q)
}

docker_ssh() {
  if type docker-machine 2>/dev/null; then
    docker-machine ssh docker "$@"
  elif type boot2docker 2>/dev/null; then
    boot2docker ssh "$@"
  fi
}

docker_api() {
  docker_ssh curl --silent --show-error --globoff --insecure --cert $DOCKER_CERT_PATH/cert.pem --key $DOCKER_CERT_PATH/key.pem "$(echo $DOCKER_HOST | sed 's;tcp;https;')/$@"
}

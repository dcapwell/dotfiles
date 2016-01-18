if type docker-machine 1>/dev/null 2>/dev/null ; then
  eval $(docker-machine env docker 2>/dev/null)
elif type boot2docker 1>/dev/null 2>/dev/null ; then
  eval $(boot2docker shellinit 2>/dev/null)
fi

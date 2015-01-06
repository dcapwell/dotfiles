SSH_OPTS=(
  -o PasswordAuthentication=no
  -o ConnectTimeout=2
  -o UserKnownHostsFile=/dev/null
  -o StrictHostKeyChecking=no
)

# SSH into a remote EC2 host
# ENV
# EC2_PEM  : Path to the identity (pem) file (defaults to $HOME/.ssh/aws.pem)
# EC2_USER : user name to login as (defaults to ec2-user)
ec2-login() {
  if [ "$1" == "" ]; then
      echo "Unable to login to EC2; No host given" >&2
      return 1
  fi

  ssh -i ${EC2_PEM:-~/.ssh/aws.pem} "${SSH_OPTS[@]}" ${EC2_USER:-ec2-user}@$1
}

# SSH into a remote EC2 host. This function will attempt to re-login on ssh failures (dropped connection, etc.)
# ENV
# EC2_PEM  : Path to the identity (pem) file (defaults to $HOME/.ssh/aws.pem)
# EC2_USER : user name to login as (defaults to ec2-user)
ec2-ssh() {
  if [ "$1" == "" ]; then
      echo "Unable to login to EC2; No host given" >&2
      return 1
  fi

  # trim hostname to a shorter form
  tempvar=$1
  case $tempvar in
    *compute-1.amazonaws.com)   SHOW_HOST=$(echo $tempvar | sed -e 's/\.compute-1\.amazonaws\.com//') ;;
    *com)     SHOW_HOST=$(echo $tempvar | sed -r -e 's/\.\w+\.\w+$//') ;;
    *)      SHOW_HOST=$tempvar ;;
  esac

  # Will respawn your ssh session, in case it gets killed (e.g. by the firewall)
  # NOTE: If you actually want to kill the ssh session, you need to exit ssh yourself, then ^C to kill this script
  while [ 1 = 1 ]; do
    echo -n -e "\033k${SHOW_HOST}\033\\"
    ec2-login $1
    echo -n -e "\033kDOWN-${SHOW_HOST}\033\\"
    sleep 5
  done

  # Change back to local system's hostname
  SHOW_HOST=$(echo $HOSTNAME | awk -F. '{print $1}')
  echo -n -e "\033k${PREFIX}${SHOW_HOST}\033\\"
}

# SSH into a set of remote EC2 hosts sequentially
# ENV
# EC2_PEM  : Path to the identity (pem) file (defaults to $HOME/.ssh/aws.pem)
# EC2_USER : user name to login as (defaults to ec2-user)
ec2-ssh-hosts() {
  for host in $@; do
    ec2-login $host
  done
}

# SCP a file to a EC2 host
# <local path> <host>
# ENV
# EC2_PEM  : Path to the identity (pem) file (defaults to $HOME/.ssh/aws.pem)
# EC2_USER : user name to login as (defaults to ec2-user)
ec2-scp() {
  if [ "$2" == "" ]; then
      echo "Unable to login to EC2; No host given" >&2
      return 1
  fi
  scp -i ${EC2_PEM:-~/.ssh/aws.pem} "${SSH_OPTS[@]}" $1 ${EC2_USER:-ec2-user}@$2:~
}

# SCP a file to the set of EC2 hosts
# <local path> <hosts>+
# ENV
# EC2_PEM  : Path to the identity (pem) file (defaults to $HOME/.ssh/aws.pem)
# EC2_USER : user name to login as (defaults to ec2-user)
ec2-scp-hosts() {
  local file=$1
  shift

  for host in $@; do
    ec2-scp $file $host
  done
}


# Rsync between a local and ec2 node
ec2-rsync() {
  rsync -rave "ssh -i ${EC2_PEM:-~/.ssh/aws.pem} ${SSH_OPTS[@]}" "$@"
}

unset SSH_OPTS

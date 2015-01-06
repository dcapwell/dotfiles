if [ "$PS1" != "" ] ; then
  POSTFIX=""
  ## enables screen to see what application is launched
  POSTFIX="\[\033k\033\\"

  ## display git branch if git_ps1 is usable
  if type __git_ps1 >/dev/null 2>&1 ; then
    GIT_PROMPT='$(__git_ps1 "(%s)")'
    POSTFIX="${POSTFIX} ${bldcyn}${GIT_PROMPT}${txtrst}"
  fi

  export PS1="[${txtgrn}\u${txtrst} ${txtylw}\w${txtrst}]${POSTFIX} \$ "
fi

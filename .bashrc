source ~/.bash_aliases

if which defaults > /dev/null 2>&1 ; then
  defaults write com.apple.finder AppleShowAllFiles TRUE
fi

# is this a remote (ssh) login?
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SSH_SESSION_TYPE=remote/ssh
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) SSH_SESSION_TYPE=remote/ssh;;
  esac
fi

if [ "$PS1" ]; then

  red='\[\e[31m\]'
  green='\[\e[32m\]'
  yellow='\[\e[33m\]'
  cyan='\[\e[36m\]'
  grey='\[\e[0;37m\]'

  reset_color='\[\e[0m\]'
  set_title='\[\e]0;\]\h:\w\[\007\]'

  [[ -n "$SSH_SESSION_TYPE" ]] && set_title="${set_title}${red}"

  prompt="$green$"

  prompt_user=`id -un`
  if [[ $prompt_user = root ]]; then
    prompt="$red#"
  elif [[ $prompt_user != dev ]]; then
    prompt="$yellow$prompt_user$"
  fi

  function prompt-git-user() {
    git_user=`git config --get user.name`
    if test -n "$git_user"; then
      echo " '$git_user'"
    fi
  }

  function prompt-git-branch() {
    git_branch=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/^* //'`
    if test -n "$git_branch"; then
      echo " [$git_branch]"
    fi
  }

  function prompt-git-rebasing() {
    [[ -d .git/rebase-apply ]] && echo " REBASING"
  }

  function boxname() {
    if [ -n "$SSH_SESSION_TYPE" ]; then
      echo "(`hostname -s`-remote) "
    else
      echo "(`hostname -s`) "
    fi
  }

  function rubyversion() {
    ruby -v|cut -d' ' -f2
  }

  # create a $fill of all screen width minus the time string and a space:
  let fillsize=${COLUMNS}-12
  fill=""
  while [ "$fillsize" -gt "0" ]
  do
  fill="-${fill}" # fill with underscores to work on
  let fillsize=${fillsize}-1
  done

  PS1="${set_title}\$(boxname)${green}(\t) ${yellow}\w${grey}\$(prompt-git-branch)${red}\$(prompt-git-rebasing)${cyan}\$(prompt-git-user) ${yellow}\$(rubyversion)
${prompt} ${reset_color}"
fi

test -e ~/projects && export CDPATH=.:$CDPATH:~/projects
test -e ~/src && export CDPATH=.:$CDPATH:~/src

test -e ~/projects && export export PATH=$PATH:~/projects
test -e ~/src && export export PATH=$PATH:~/src

export PATH=$PATH:/usr/local/share/npm/bin
export PATH=$PATH:/usr/local/bin
# export PATH="`yarn global bin`:$PATH"
export PATH=~/bin:$PATH

export BUNDLER_EDITOR='subl' # Don't use -w, that takes over the comand line
export EDITOR='subl -w'
export LESS='R'


# gpg-agent
[ -f ~/.gpg-agent-info ] && source ~/.gpg-agent-info
if [ -S "${GPG_AGENT_INFO%%:*}" ]; then
   export GPG_AGENT_INFO
else
   eval $( gpg-agent --daemon --write-env-file ~/.gpg-agent-info )
fi
# use this instead when gpgconf supports the --launch option. Apparently latest default gpg via homebrew supports it.
# if ! pgrep -x -u "${USER}" gpg-agent >/dev/null 2>&1; then
#   gpgconf --launch gpg-agent
# fi
export GPG_TTY=$(tty)

function gpg-agent-restart {
  local pid=$(pgrep -x -u "${USER}" gpg-agent)
  kill ${pid}
  eval $( gpg-agent --daemon --write-env-file ~/.gpg-agent-info )
  export GPG_AGENT_INFO
}

_direnv_hook() {
  eval "$(direnv export bash 2>/dev/null)";
}
if ! [[ "$PROMPT_COMMAND" =~ _direnv_hook ]]; then
  PROMPT_COMMAND="_direnv_hook;$PROMPT_COMMAND";
fi

export HISTCONTROL=ignorespace

. $HOME/.asdf/asdf.sh

. $HOME/.asdf/completions/asdf.bash

[ -f /opt/boxen/homebrew/bin/aws_completer ] && complete -C '/opt/boxen/homebrew/bin/aws_completer' aws

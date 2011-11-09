# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

#source ~/bin/git-completion.bash

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT='%b %d %H:%M:%S: '

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=15000
export HISTFILESIZE=30000
set cmdhist

# append to the history file, don't overwrite it
shopt -s histappend
shopt -s histverify
shopt -s histreedit

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

shopt -s cdspell
shopt -s checkjobs

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
function ll
{
    gls --color=always -alh "$@" | more -R;
}


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

export PS1='\[\033[0;32m\]\h\[\033[0;31m\] <\W>\[\033[0;31m\]$(__git_ps1)\[\033[0;35m\] \!\[\033[0;34m\] $ \[\033[0m\]'
# export PS1='\[\033[1;34m\]\h\[\033[1;31m\] <\W>\[\033[1;31m\]$(__git_ps1)\[\033[0;35m\] \!\[\033[1;34m\] $ \[\033[0m\]'

# Pip bash completion start
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip
# pip bash completion end

export PATH=$PATH:/opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin

#/etc/profile begin
if [ -x /usr/libexec/path_helper ]; then
    eval `/usr/libexec/path_helper -s`
    defaults write $HOME/.MacOSX/environment PATH "$PATH"
fi
#/etc/profile end

export P4CONFIG=P4ENV
export P4PORT=perforce.ironport.com:1666

export INPUTRC=$HOME/.inputrc

function bk
{
    cp $1{,.bak};
}

function he
{
    (history | egrep $1);
}

function sw
{
    bk $1;
    bk $2;
    local RANDSTR=$RANDOM;
    cp $1 /tmp/$RANDSTR;
    cp $2 $1;
    cp /tmp/$RANDSTR $2;
}

function sb
{
    sw $1{,.bak};
}

function myproc
{
    ps -axcdhe;
}

function allproc
{
    ps -axcdhe;
}

function em
{
    /opt/local/bin/emacsclient --alternate-editor="" $1
}

#export PATH=/opt/local/bin:$PATH
export ALTERNATE_EDITOR=emacs
export EDITOR=em
export VISUAL=em
#export PAGER=less
#export LESS=-R
export LSCOLORS="cxfxcxdxbxegedabagacad"

export WORKON_HOME=~/MyVirtualEnvs

export PATH=/opt/local/bin:/opt/local/sbin:$PATH


bind 'set mark-directories on'
bind 'set mark-symlinked-directories on'
bind 'set page-completions off'
bind 'set show-all-if-ambiguous on'
bind 'set visible-stats on'
bind 'set completion-query-items 9001'

# export LOCALNAME=""
# function termname () { export LOCALNAME="$1|"; }
# PS1="\[\e]0;\${LOCALNAME}\u@\h:\w\a\]$PS1"
# function ___set_title () {
#   local WD=$(pwd | sed "s/^\/home\/$USER/~/")
#   echo -ne "\e]0;${LOCALNAME}$USER@$HOSTNAME:$WD ($1)\a"
# }
# trap '___set_title "$BASH_COMMAND"' DEBUG

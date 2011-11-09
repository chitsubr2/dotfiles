##
# Your previous /Users/subu/.bash_profile file was backed up as /Users/subu/.bash_profile.macports-saved_2011-01-31_at_15:32:23
##

# MacPorts Installer addition on 2011-01-31_at_15:32:23: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.


##
# Your previous /Users/subu/.bash_profile file was backed up as /Users/subu/.bash_profile.macports-saved_2011-01-31_at_15:33:41
##

# MacPorts Installer addition on 2011-01-31_at_15:33:41: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

# bash-completion
if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi

#source ~/bin/git-completion.bash

[[ -f ~/.bashrc ]] && . ~/.bashrc
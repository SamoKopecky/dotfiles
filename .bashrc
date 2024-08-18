# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc

export PATH=$PATH:/home/samuel.kopecky/.local/share/JetBrains/Toolbox/scripts:/home/samuel.kopecky/.cargo/bin:/home/samuel.kopecky/go/bin
#export PS1='\$? | \[\033[1;34m\]\h\[\033[0m\] \w \[\033[1;33m\]$(__git_ps1 "%s")\[\033[0m\]]\$ '
source /home/samuel.kopecky/.git-prompt.sh


PROMPT_COMMAND=__prompt_command    # Function to generate PS1 after CMDs

__prompt_command() {
    local EXIT="$?"                # This needs to be first
    local pre="$1"
    local post="$2"
    if [ -n "${VIRTUAL_ENV}" ] && [ -z "${VIRTUAL_ENV_DISABLE_PROMPT:-}" ]; then
       if [ "`basename \"$VIRTUAL_ENV\"`" = "__" ] ; then
          # special case for Aspen magic directories
          # see http://www.zetadev.com/software/aspen/
          pre="[`basename \`dirname \"$VIRTUAL_ENV\"\``] ${pre}"
       else
          pre="(`basename \"$VIRTUAL_ENV\"`) ${pre}"
       fi
    fi
    PS1="${pre}${post}["

    local RCol='\[\e[0m\]'

    local BOLD='\[\e[1m\]'
    local Red='\[\e[38;5;1m\]'
    local Gre='\[\e[38;5;2m\]'
    local BYel='\[\e[1;33m\]'
    local BBlu='\[\e[1;34m\]'
    local Pur='\[\e[0;35m\]'


    if [ $EXIT != 0 ]; then
        PS1+="${BOLD}${Red}\h${RCol}"        # Add red if exit code non 0
    else
        PS1+="${BOLD}${Gre}\h${RCol}"
    fi
    

    PS1+=" \w \[\033[1;33m\]$(__git_ps1 "%s")\[\033[0m\]]\$ "

}


alias k=kubectl

export PATH="$PATH:/home/samuel.kopecky/.local/bin/ppc-data-debug-tools"
export PATH="$PATH:/opt/FreeTube:/opt/discord/discord"
export PATH="$PATH:/home/samuel.kopecky/.cache/pypoetry/virtualenvs/republish-tool-jILT7XYa-py3.12/bin"
alias k9sdev='k9s --context gke_heu-k8s-dev_europe-west3_collective'
alias k9sprep='k9s --context gke_heu-k8s-pre-prod_europe-west3_collective'
alias k9sprod='k9s --context gke_heu-k8s-prod_europe-west3_collective'
export KUBE_EDITOR='vim'
alias vim=nvim
alias mt="make test"
alias md="make down"
alias mu="make up-d"

export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring

alias "xc=wl-copy"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


source /home/samuel.kopecky/.bash_completions/republish.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

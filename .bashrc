# .bashrc

# Generate color based on status code
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

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi
unset rc

# Colors
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# Function to generate PS1 after CMDs
PROMPT_COMMAND=__prompt_command    

source $HOME/.git-prompt.sh

# PATH
export PATH="$PATH:$HOME/.local/bin/ppc-data-debug-tools"
export PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts:"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:/opt/FreeTube"
export PATH="$PATH:/opt/discord/discord"

export EDITOR='vim'

export KUBE_EDITOR='vim'
export PYENV_ROOT="$HOME/.pyenv"
export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"


# Aliases
alias k=kubectl
alias k9sdev='k9s --context gke_heu-k8s-dev_europe-west3_collective'
alias k9sprep='k9s --context gke_heu-k8s-pre-prod_europe-west3_collective'
alias k9sprod='k9s --context gke_heu-k8s-prod_europe-west3_collective'
alias xc="wl-copy"
alias mt="make test"
alias md="make down"
alias mu="make up-d"


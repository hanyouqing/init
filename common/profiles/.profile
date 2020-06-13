# ~/.profile by Youqing
# priority order for bash profile files: 
#   /etc/profile,  ~/.bash_profile,  ~/.bash_login,  ~/.profile

# ------------------------------- #
#    Customize History Format     #
# ------------------------------- #
HISTTIMEFORMAT="[%d/%m/%Y %T%z] ($(whoami)) "

# ----------------------- #
#    Customize Prompt     #
# ----------------------- #
export TERM=xterm-256color
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
PS1='\[\033[01;32m\]\h\[\033[01;34m\]:\w\[\033[01;31m\]$(parse_git_branch)\[\033[00m\]\[\033[0;32m\]\n\[\033[0;93m\]\u$\[\033[00m\] '
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \(\1\)/'
}

# --------------------------- #
#    Customize alias cmds     #
# --------------------------- #
alias vi='vim'
alias ls='ls -G'
alias ll='ls -l'
alias grep='grep --color'

# ---------------------------- #
#    Customize alias todir     #
# ---------------------------- #
[[ -d ${HOME}/Apps/bin ]] || mkdir -p ${HOME}/Apps/bin
alias desktop="cd ${HOME}/Desktop"
alias download="cd ${HOME}/Downloads"
alias apps="cd ${HOME}/Apps"
alias github="cd ${HOME}/github.com"
alias work="cd ${HOME}/github.com/work" # symlink to org directory

# --------------------------------- #
#    Customize PATH environment     #
# --------------------------------- #
export PATH=.:$PATH
export PATH=${HOME}/Apps/bin:$PATH
export PATH=${HOME}/Apps/maven/bin:${PATH}
export PATH=${HOME}/Apps/helm/:${PATH}

# --------------------------------------- # 
#    Customize environment for Golang     #
# --------------------------------------- #
[[ -d ~/go/src ]]            || mkdir -p ~/go/src
[[ -d ~/github.com ]]        || mkdir -p ~/github.com
[[ -L ~/go/src/github.com ]] || ln -s ~/github.com ~/go/src/
export GOROOT=/usr/local/go
export GOPATH="${HOME}/go"
export GOBIN="${GOPATH}/bin"
export PATH=$PATH:$GOROOT/bin:$GOBIN

# ------------------------------------- # 
#    Customize environment for java     #
# ------------------------------------- #
# export PATH="/usr/local/opt/python/libexec/bin:$PATH"
#export JAVA_HOME=
#export JAVA_CLASSIC=
#export JAVA_LIB=
#export M2_HOME=

[[ -s ~/.bashrc ]] && . ~/.bashrc
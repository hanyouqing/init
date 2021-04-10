#!/bin/bash
# 
#########################################################################
#                                                                       #
#   This script is used to the initialization setup of MacOS and Linux. # 
#                                                                       #
#########################################################################
#

#####################
# Config ~/.profile #
#####################
grep '# ~/.profile' ~/.bash_profile || cat >> ~/.bash_profile <<EOF
# ~/.profile $(date +%F_%T%z)
[[ -f ~/.profile ]] && . ~/.profile

EOF
echo '[[ -f ~/.profile ]] && . ~/.profile' >> ~/.bash_profile


##################
# Config for ssh #
##################
mkdir -pv    /tmp/hosts
mkdir -pv    ~/.ssh/conf.d
touch        ~/.ssh/config
touch        ~/.ssh/{deveplopment,staging,productoin,me}.pem
chmod -R 700 ~/.ssh
chmod -R 700 ~/.ssh/conf.d
chmod -R 600 ~/.ssh/conf.d/*
find         ~/.ssh/ -type f -exec chmod 600 {} \;
cat > ~/.ssh/config <<EOT
Host *
$([[ $(uname) == "Darwin" ]]&&echo "    IgnoreUnkown UseKeyChain")
$([[ $(uname) == "Darwin" ]]&&echo "    UseKeychain yes")
    AddKeysToAgent yes
    Compression yes
    PubkeyAuthentication yes

    ControlMaster auto
    ControlPersist yes
    ControlPath /tmp/hosts/%r@%h-%p

    SendEnv LANG LC_ALL=en.US.UTF-8
    GSSAPIAuthentication no
    StrictHostKeyChecking no
    ServerAliveInterval 60
    ServerAliveCountMax 360
    TCPKeepAlive yes

# Include depends on OpenSSH_7.3p1+
Include ~/.ssh/conf.d/development
Include ~/.ssh/conf.d/testing
Include ~/.ssh/conf.d/staging
Include ~/.ssh/conf.d/production
Include ~/.ssh/conf.d/default
EOT
cat > ~/.ssh/conf.d/default <<EOT
Host jump-ali-bj-000 x.x.x.x
    HostName x.x.x.x
    User 18600000000
    Port xxxxx

Host cvm-tct-sha-001 y.y.y.y
    HostName y.y.y.y
    User username
    Port 22
    IdentityFile ~/.ssh/jump-ali-bj-000.pem
    ProxyCommand ssh jump-ali-bj-000 -q -W %h:%p

Host *
    Port 22
    IdentityFile ~/.ssh/id_rsa
EOT


###############################
# Install git-flow-completion #
###############################
#   https://github.com/nvie/gitflow/wiki/Installation
#   https://github.com/bobthecow/git-flow-completion
git clone https://github.com/bobthecow/git-flow-completion.git ~/github.com/bobthecow/git-flow-completion


###############
# Install fzf # 
###############
#   https://github.com/junegunn/fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install <<<y
source ~/.${SHELL##*bin/}rc


#################
# Install tfenv #
#################
#   https://github.com/tfutils/tfenv
#   https://www.terraform.io/docs/commands/index.html
[[ -d ~/.tfenv ]] || { \
   git clone https://github.com/tfutils/tfenv.git ~/.tfenv \
&& cd ~/.tfenv \
&& lastest_version="$(git tag|grep -v '-'|tail -1)"; git checkout tags/${lastest_version} -b ${lastest_version}; \
} 
grep '# tfenv' ~/.bash_profile || echo -e "# tfenv $(date +%F_%T%z)\nexport PATH=\"\$HOME/.tfenv/bin:\$PATH\"" >> ~/.bash_profile
source ~/.bash_profile && terraform -install-autocomplete


#####################
# Install oh-my-zsh # 
#####################
#   https://ohmyz.sh/#install
# sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


######################
# Install oh-my-bash # 
######################
#   https://github.com/ohmybash/oh-my-bash
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"


####################
# Install SpaceVim #
####################
#   https://github.com/SpaceVim/SpaceVim
#   https://spacevim.org/documentation/
#   https://github.com/yangyangwithgnu/use_vim_as_ide
#   Fix CMD + C:
#   https://github.com/SpaceVim/SpaceVim/issues/695
curl -sLf https://spacevim.org/install.sh | bash
mkdir -p ~/.SpaceVim.d/autoload
cat >> ~/.SpaceVim.d/autoload/custom_init.vim <<EOF 
# fix copy $(date +%F_%T%z)
function! custom_init#before() abort
    set mouse=r
endf
EOF
cat >> ~/.SpaceVim/autoload/SpaceVim/default.vim <<EOF
# Fix copy to clipboard $(date +%F_%T%z)
#   https://github.com/SpaceVim/SpaceVim/issues/2202
#   https://github.com/SpaceVim/SpaceVim/commit/c4be5b44d4ea7cda980e876e92741be41a914afa
if has('unnamedplus')
  xnoremap <Leader>y "+y
  xnoremap <Leader>d "+d
  nnoremap <Leader>p "+p
  nnoremap <Leader>P "+P
  xnoremap <Leader>p "+p
  xnoremap <Leader>P "+P
else
  xnoremap <Leader>y "*y
  xnoremap <Leader>d "*d
  nnoremap <Leader>p "*p
  nnoremap <Leader>P "*P
  xnoremap <Leader>p "*p
  xnoremap <Leader>P "*P
endif
EOF


#################
# Install Conda #
#################
#   https://docs.conda.io/en/latest/miniconda.html
CONDA_SCRIPT="Miniconda3-latest-$(uname -s)-$(uname -m).sh"
wget -c -P /tmp/ https://repo.continuum.io/miniconda/${CONDA_SCRIPT//Darwin/MacOSX} 
[ -d ~/miniconda3 ] || bash /tmp/${CONDA_SCRIPT//Darwin/MacOSX} -bfu
~/miniconda3/bin/conda init ${SHELL##*bin/}
~/miniconda3/bin/conda update -n base -c defaults conda <<<y 
~/miniconda3/bin/conda config --set auto_activate_base false
~/miniconda3/bin/conda create -n python3 python=3.7 <<<y
~/miniconda3/bin/conda info -e 
~/miniconda3/bin/pip install \
    thefuck \
    ipython


#################
# Install tfenv #
#################
#   https://www.terraform.io/docs/
git clone https://github.com/tfutils/tfenv.git ~/.tfenv
grep '.tfenv'  ~/.${SHELL##*bin/}rc || echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.${SHELL##*bin/}rc
~/.tfenv/bin/tfenv install $(tfenv list-remote|grep -v '-'|head -1)
~/.tfenv/bin/tfenv use $(tfenv list-remote|grep -v '-'|head -1)


####################
# Install Binaries #
####################
mkdir -pv ~/Apps/bin
grep '^# Apps/bin' ~/.bash_profile || cat  >> ~/.bash_profile <<EOF
# Apps/bin $(date +%F_%T%z)
PATH=\$PATH:~/Apps/bin

EOF

# Golang #
mkdir -pv ~/github.com
mkdir -pv ~/go/src
ln -s ~/github.com ~/go/src/
# maven #
wget -c -P /tmp/ http://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.6.2/binaries/apache-maven-3.6.2-bin.zip
unzip   -d ~/Apps/ /tmp/apache-maven-3.6.2-bin.zip
ln -s      ~/Apps/apache-maven-3.6.2 ~/Apps/maven

#   @TODO:

#!/bin/bash
# 
#########################################################################
#                                                                       #
#   This script is used to the initialization setup of MacOS and Linux. # 
#                                                                       #
#########################################################################
#


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
# Install Conda # thefuck, ipython
#################
#   https://docs.conda.io/en/latest/miniconda.html
CONDA_SCRIPT="Miniconda3-latest-$(uname -s)-$(uname -m).sh"
wget -c -P /tmp/ https://repo.continuum.io/miniconda/${CONDA_SCRIPT//Darwin/MacOSX} 
[ -d ${HOME}/miniconda3 ] || bash ${INFRA_DOWNLOADS}/${CONDA_SCRIPT//Darwin/MacOSX} -bfu 
~/miniconda3/bin/conda init ${SHELL##*bin/}
~/miniconda3/bin/conda update -n base -c defaults conda <<<y 
~/miniconda3/bin/conda config --set auto_activate_base false
~/miniconda3/bin/conda create -n python3 python=3.7 <<<y
~/miniconda3/bin/conda info -e 


############
# SpaceVim #
############
# Fix CMD + C:
#   https://github.com/SpaceVim/SpaceVim/issues/695
curl -sLf https://spacevim.org/install.sh | bash


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
#   @TODO:
grep '^# Apps' ~/.bash_profile || echo 'PATH=$PATH:~/Apps/bin' >> ~/.bash_profile
mkdir -pv ~/Apps/bin
mkdir -pv ~/github.com
mkdir -pv ~/go/src
ln -s ~/github.com ~/go/src/

wget -c -P /tmp/ http://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.6.2/binaries/apache-maven-3.6.2-bin.zip
unzip   -d ~/Apps/ /tmp/apache-maven-3.6.2-bin.zip
ln -s      ~/Apps/apache-maven-3.6.2 ~/Apps/maven

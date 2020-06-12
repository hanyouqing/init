#!/bin/bash
# 
###############################################################
#                                                             #
#   This script is used to the initialization setup of MacOS. # 
#                                                             #
###############################################################
#

#################
# Install Xcode #
#################
#   https://developer.apple.com/library/archive/technotes/tn2339/_index.html
xcode-select --install || softwareupdate --install -a


################
# Install Brew #
################
#   https://brew.sh/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"


############################
# Install Packages by brew #
############################
brew install \
    git-flow \
    readline \
    bash \
    tmux \
    wget \
    unzip \
    xz \
    zlib \
    tree \
    bat \
    jq \
    mtr \
    telnet

###################
# Setting library #
###################
grep '^# library' ~/.bash_profile || cat >> ~/.bash_profile <<EOL
# library $(date +%F_%T%z)
export LDFLAGS="-L/usr/local/opt/zlib/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include"
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH} /usr/local/opt/zlib/lib/pkgconfig"
EOL


###########################
# Install bash-completion #
###########################
#   https://github.com/scop/bash-completion
#   https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion.html
brew install bash-completion@2
grep '/usr/local/bin/bash' /etc/shells || echo '/usr/local/bin/bash' >> /etc/shells
chsh -s /usr/local/bin/bash
grep '^# BASH_COMPLETION' ~/.bash_profile || cat >> ~/.bash_profile <<EOF
# BASH_COMPLETION $(date +%F_%T%z)
export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
EOF


##########################
# Install Docker-Desktop #
##########################
#   https://hub.docker.com/editions/community/docker-ce-desktop-mac/
#   https://docs.docker.com/
which docker && { \
    wget -c -P /tmp/ https://download.docker.com/mac/stable/Docker.dmg; \
    open /tmp/Docker.dmg; }


###################
# Install Sublime #
###################
#   https://www.sublimetext.com/3
#   @TODO: configs
wget -c -O /tmp/SublimeTextBuild.dmg https://download.sublimetext.com/Sublime%20Text%20Build%203211.dmg
open /tmp/SublimeTextBuild.dmg
grep subl ~/.profile || echo 'alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"' >> ~/.profile
# Install Plugins
#   JSON
#   Emmet


##############################
# Install Visual Studio Code #
##############################
#   https://code.visualstudio.com/
#   https://code.visualstudio.com/Download
#   @TODO: configs
wget -c -O /tmp/VSCode-darwin-stable.zip https://go.microsoft.com/fwlink/?LinkID=620882
unzip -d /tmp/ /tmp/VSCode-darwin-stable.zip
echo -e "\n\tPlease move \"Visual Studio Code\" to \"Applications\"\n"
open /tmp/ 
# Install code command in PATH:
#     Shift + CMD + P 
#   -> shell 
#   -> Install `code` command in PATH
# Langunage Support:
#   golang
#   python
#   javascript
#   yaml
#   json
#   markdown
#   mermaid-diagram
#   emmet
# Git Plugin:
#   git history
#   git graph
# Plugins:
#   terraform
#   ansible
#   docker
#   kubernetes
#   icpanle


#######################
# Install rancher cli #
#######################
#   https://rancher.com/docs/rancher/v2.x/en/cli/
wget -c -P /tmp/ https://github.com/rancher/cli/releases/download/v2.4.3/rancher-darwin-amd64-v2.4.3.tar.gz
tar -C /tmp/ -xvf /tmp/rancher-darwin-amd64-v2.4.3.tar.gz
mv /tmp/rancher-v2.4.3/rancher /usr/local/bin/


############################
# Install kubernetes tools #
############################
#   https://kubernetes.io/docs/tasks/tools/install-kubectl/
#   https://github.com/derailed/k9s
#   https://github.com/ahmetb/kubectx
mkdir -pv ~/.kube/conf.d/
brew install \
    kubectl \
    helm \
    kustomize \
    kubectx \
    krew \
    derailed/k9s/k9s
grep '^# kubectl completion' ~/.bash_profile || cat >> ~/.bash_profile <<EOF
# kubectl completion $(date +%F_%T%z)
source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k
EOF
kustomize install-completion <<<yes
grep '^export KUBECONFIG' ~/.bash_profile || echo 'export KUBECONFIG="~/.kube/config$(ls -d ~/.kube/conf.d/*|sed "s#^#:#g"|tr -d "\n")"' >> ~/.bash_profile
# Install lens
wget -c -P /tmp/ https://github.com/lensapp/lens/releases/download/v3.4.0/Lens-3.4.0.dmg
open /tmp/Lens-3.4.0.dmg


###################
# Install golang  #
###################
#   https://golang.org/dl/
{ \
wget -c -P /tmp/ https://dl.google.com/go/go1.14.4.darwin-amd64.pkg; \
open /tmp/go1.14.4.darwin-amd64.pkg; \
}


###################
# Install nodejs  #
###################
# install node
#   https://github.com/nvm-sh/nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash


#################
# Install java  #
#################
#   https://www.java.com/zh_CN/download/help/mac_install.xml
#   https://www.oracle.com/technetwork/java/javase/downloads/index.html
#   https://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase8-2177648.html
#   https://maven.apache.org/install.html
#   @TODO:


###########
# Unmount # 
###########
umount "/Volumes/Docker/"
umount "/Volumes/Sublime Text"
umount "/Volumes/Lens 3.4.0"

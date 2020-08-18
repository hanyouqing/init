#!/bin/bash
# 
################################################################
#                                                              #
#   This script is used to the initialization setup for MacOS. # 
#                                                              #
################################################################
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



##########
# ClashX #
##########
# @TODO


############################
# Install Packages by brew #
############################
# ALL_PROXY=socks5://127.0.0.1:7891
brew install \
    wireguard-tools \
    speedtest \
    iperf \
    wireguard-tools \
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
    telnet \
    ffmpeg \
    hugo \
    nvm \
    jsonnet \
    kubecfg \
    pulumi \
    cfssl
# speedtest cli: https://www.speedtest.net/apps/cli
brew tap teamookla/speedtest
brew update
brew install speedtest --force



###############
# Set library #
###############
touch ~/.bash_profile
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
# @TODO:
sudo cat >> /etc/shells <<EOF
# /usr/local/bin/bash $(date +%F_%T%z)
/usr/local/bin/bash
EOF
chsh -s /usr/local/bin/bash
grep '^# BASH_COMPLETION' ~/.bash_profile || cat >> ~/.bash_profile <<EOF
# BASH_COMPLETION $(date +%F_%T%z)
export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

EOF
# git completion
cd /usr/local/etc/bash_completion.d/
curl -L -O https://raw.github.com/git/git/master/contrib/completion/git-completion.bash


##################
# Install iTerm2 #
##################
#   https://www.iterm2.com/documentation.html
[[ -d /Applications/iTerm.app/ ]] || { \
    wget -c -P /tmp/ https://iterm2.com/downloads/stable/iTerm2-3_3_11.zip \
 && unzip -d /tmp/ /tmp/iTerm2-3_3_11.zip \
 && sudo mv /tmp/iTerm.app /Application/;
}


##########################
# Install Docker-Desktop #
##########################
#   https://hub.docker.com/editions/community/docker-ce-desktop-mac/
#   https://docs.docker.com/
#   https://docs.docker.com/compose/completion/
#   https://docs.docker.com/engine/reference/commandline/app_completion/
which docker || { \
    wget -c -P /tmp/ https://download.docker.com/mac/stable/Docker.dmg \
 && open /tmp/Docker.dmg \
 && sleep 5 \
 && sudo cp -prfv /Volumes/Docker/Docker.app /Applications/ \
 && umount /Volumes/Docker \
 && cd /usr/local/etc/bash_completion.d/ \
 && curl -L -O https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose \
 && curl -L -O https://raw.githubusercontent.com/docker/cli/master/contrib/completion/bash/docker
}


###################
# Install Sublime #
###################
#   https://www.sublimetext.com/3
#   @TODO: configs
[[ -d /Applications/Sublime\ Text.app/ ]] || { \
       wget -c -O /tmp/SublimeTextBuild.dmg https://download.sublimetext.com/Sublime%20Text%20Build%203211.dmg \
    && open /tmp/SublimeTextBuild.dmg \
    && sleep 3 \
    && cp -prfv /Volumes/Sublime\ Text/Sublime\ Text.app /Applications/ \
    && grep subl ~/.bash_profile || echo -e "# subl $(date +%F_%T%z)\nalias subl=\"/Applications/Sublime\\ Text.app/Contents/SharedSupport/bin/subl\"\n" >> ~/.bash_profile \
    && umount /Volumes/Sublime\ Text; \
}
# Install Plugins
#   JSON
#   Emmet


##############################
# Install Visual Studio Code #
##############################
#   https://code.visualstudio.com/
#   https://code.visualstudio.com/Download
#   @TODO: configs
[[ -d /Applications/Visual\ Studio\ Code.app/ ]] || { \
       wget -c -O /tmp/VSCode-darwin-stable.zip https://go.microsoft.com/fwlink/?LinkID=620882 \
    && unzip -d /tmp/ /tmp/VSCode-darwin-stable.zip \
    && sudo mv /tmp/Visual\ Studio\ Code.app/ /Applications/ \
}
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
#   marp
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
#   https://github.com/GoogleContainerTools/skaffold
#   https://github.com/derailed/k9s
#   https://github.com/ahmetb/kubectx
#   https://microk8s.io
mkdir -pv ~/.kube/conf.d/
brew install \
    kubectl \
    helm \
    kustomize \
    skaffold \
    kubectx \
    krew \
    derailed/k9s/k9s \
    ubuntu/microk8s/microk8s \
grep '^# kubectl completion' ~/.bash_profile || cat >> ~/.bash_profile <<EOF
# kubectl completion $(date +%F_%T%z)
# @TODO:   1 .bash_profile|14 error| syntax error near unexpected token `('
source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k

EOF
echo yes | kustomize install-completion
mkdir -pv ${HOME}/.kube/ && touch ${HOME}/.kube/example
grep '^export KUBECONFIG' ~/.bash_profile || cat >> ~/.bash_profile <<EOF
# kubeconfig $(date +%F_%T%z)
export KUBECONFIG="\${HOME}/.kube/config\$(ls \${HOME}/.kube/conf.d/*|sed "s#^#:#g"|tr -d "\n")"

EOF
# Install lens
#   https://k8slens.dev/
{ \
   wget -c -P /tmp/ https://github.com/lensapp/lens/releases/download/v3.5.0/Lens-3.5.0.dmg \
&& open /tmp/Lens-3.4.0.dmg \
&& sleep 5 \
&& cp -prf /Volumes/Lens\ 3.5.0/Lens.app /Applications/ \
&& unmount /Volumes/Lens\ 3.5.0; \
}



###################
# Install golang  #
###################
#   https://golang.org/dl/
{ \
    wget -c -P /tmp/ https://dl.google.com/go/go1.14.4.darwin-amd64.pkg \
 && open /tmp/go1.14.4.darwin-amd64.pkg; \
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

#################
# Install TODO  #
#################
cat > ~/to-be-install.md <<EOT
# To Be Insltalled
* Goolge
    Chrome
    Chrome Canary
* Firefox
* Slack
* Zoom
* Authy
* CheatSheet
* Lastpass
* VLC
* OBS
* PyCharm
* Tunnelblick
* AppStore
    * Mweb
    * Enpass
    * Evernote
    * Easyfind
    * Youdao Dict
EOT


####################
# Install Vanilla  #
####################
#   https://matthewpalmer.net/vanilla/
{ \
    wget -c -P /tmp/ https://macrelease.matthewpalmer.net/Vanilla.dmg \
 && open /tmp/Vanilla.dmg \
 && sleep 3 \
 && cp -prf /Volumes/Vanilla/Vanilla.app /Applications/ \
 && umount /Volumes/Vanilla; \
}


################
# Install OBS  #
################ 
#   https://obsproject.com/
{ \
    wget -c -P /tmp/ https://cdn-fastly.obsproject.com/downloads/obs-mac-25.0.8.dmg \
 && open /tmp/obs-mac-25.0.8.dmg
 && sleep 3 \
 && cp -prf /Volumes/OBS/OBS.app /Applications/ \
 && umount /Volumes/OBS; \
}


###########
# Unmount # 
###########
umount /Volumes/Firefox
umount /Volumes/Google\ Chrome
umount /Volumes/Google\ Chrome\ Canary/
umount /Volumes/Slack.app


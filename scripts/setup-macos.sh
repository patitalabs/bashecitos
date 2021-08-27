#!/bin/bash

# This scripts installs brew on a macOS host and installs the tools that I most generally use to work and play ✨

install_homebrew(){
    BREW_IS_INSTALLED=$(which brew &>/dev/null)

    if [[ ${BREW_IS_INSTALLED} -eq 0 ]]; then
        echo "Homebrew is not installed. Installing now ... ☕️"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

upgrade_homebrew() {
    echo "Homebrew version is $(brew --version | sed -n 1p | tr -d 'Homebrew ')"
    echo "Upgrading brew ... ☕️"
    brew upgrade
}

install_kubernetes_tools(){
    echo "Installing Kubernetes tools"
    brew install stern 
    brew install kubernetes-cli
}

install_docker_tools(){
    echo "Installing Docker tools"
    brew install dive
}

install_general_tools(){
    echo "Installing some general tools"
    brew install git 
    brew install tree
    brew install wget
    brew install watch
    brew install jq
    brew install yq
    brew install ccat 

}

install_oh_my_zsh(){
    echo "Installing Oh My Zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

setup_oh_my_zsh(){
    echo "Setup Oh My Zsh completion"
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
}

print_preface(){
    echo "🌱 Preface" 
    echo " ============== "
    echo "This script will install some tools, but there are others, that will have to be downloaded and installed manually first: "
    echo "💻 iTerm "
    echo "🐳 Docker "
    echo "📦 VirtualBox"

    echo "Do you have those already installed? (Y/N)" 
    read READY_TO_INSTALL

    if [[ $(echo ${READY_TO_INSTALL} | tr '[:upper:]' '[:lower:]') != 'y' ]]; then 
        echo "Please go ahead and install the tools that need to be installed manually first."
        exit 1
    fi 
}

print_preface
install_homebrew
update_brew

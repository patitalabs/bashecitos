#!/bin/bash

# This scripts installs brew on a macOS host and installs the tools that I most generally use to work and play ✨

print_preface(){
    echo "  🌱 Preface 🌱 " 
    echo " ================ "
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

install_homebrew(){
    IS_HOMEBREW_INSTALLED=$(which brew &>/dev/null)

    if [[ ${IS_HOMEBREW_INSTALLED} -eq 0 ]]; then
        echo "Homebrew version is $(brew --version | sed -n 1p | tr -d 'Homebrew ') is already installed."
    else
        echo "Homebrew is not installed. Installing now ... ☕️"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo "Homebrew version is $(brew --version | sed -n 1p | tr -d 'Homebrew ') is now installed."
    fi
}

upgrade_homebrew() {
    echo "Upgrading Homebrew... ☕️"
    brew upgrade
}

install_general_tools(){
    GENERAL_TOOLS=(git tree wget watch jq yq ccat)
    echo "Installing some general tools: ${GENERAL_TOOLS}"

    for TOOL in ${GENERAL_TOOLS}; do 
        brew install ${TOOL}
    done
}

install_oh_my_zsh(){
    echo "Installing Oh My Zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

setup_oh_my_zsh_completions(){
    echo "Setup Oh My Zsh completions"
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
}

setup_oh_my_zsh_pluggins(){

}

install_kubernetes_tools(){
    KUBERNETES_TOOLS=(stern kubernetes-cli)
    echo "Installing Kubernetes tools: ${KUBERNETES_TOOLS}"
    
    for TOOL in ${KUBERNETES_TOOLS}; do 
        brew install ${TOOL}
    done
}

install_docker_tools(){
    DOCKER_TOOLS=(dive)
    echo "Installing Docker tools"

    for TOOL in ${DOCKER_TOOLS}; do 
        brew install ${TOOL}
    done 
}

print_preface
install_homebrew
update_brew
install_general_tools
install_oh_my_zsh
setup_oh_my_zsh_completions
setup_oh_my_zsh_pluggins

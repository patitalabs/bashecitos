#!/bin/bash

# This scripts installs Homebrew and other tools that I most generally use to work and play, on a macOS host 🍎

set -e

print_preface(){
    echo "  🌱 Preface 🌱 " 
    echo " ================ "
    echo "This script will install some tools, but there are others, that will have to be downloaded and installed manually first: "
    echo "💻 iTerm "
    echo "🐳 Docker "
    echo "📦 VirtualBox"

    echo "Do you have those already installed? (Y/N)" 
    read -r READY_TO_INSTALL

    if [[ $(echo "${READY_TO_INSTALL}" | tr '[:upper:]' '[:lower:]') != 'y' ]]; then 
        echo "Please go ahead and install the tools that need to be installed manually first."
        exit 1
    fi 
}

install_homebrew(){
    IS_HOMEBREW_INSTALLED=$(which brew &>/dev/null)

    if [[ ${IS_HOMEBREW_INSTALLED} -eq 0 ]]; then
        echo "Homebrew version is $(brew --version | sed -n 1p | sed -e 's/Homebrew //') is already installed."
    else
        echo "Homebrew is not installed. Installing now ... ☕️"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo "Homebrew version is $(brew --version | sed -n 1p | sed -e 's/Homebrew //') is now installed."
    fi
}

upgrade_homebrew() {
    echo "Upgrading Homebrew... ☕️"
    brew upgrade
}

install_general_tools(){
    GENERAL_TOOLS=(git tree wget watch jq yq ccat)
    echo "Installing some general tools: ${GENERAL_TOOLS[*]}"

    for TOOL in "${GENERAL_TOOLS[@]}"; do 
        brew install "${TOOL}"
    done
}

install_ohmyzsh(){
    echo "Installing Oh My Zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_ohmyzsh_plugins(){
    OHMYZSH_PLUGINS=(zsh-completions zsh-syntax-highlighting zsh-autosuggestions)
    echo "Installing Oh My Zsh plugins: ${OHMYZSH_PLUGINS[*]}"

    for PLUGIN in "${OHMYZSH_PLUGINS[@]}"; do 
        git clone https://github.com/zsh-users/"${PLUGIN}" "${HOME}"/.oh-my-zsh/custom/plugins/"${PLUGIN}"
        ls -la "${HOME}"/.oh-my-zsh/custom/plugins/
    done
}

setup_ohmyzsh_theme(){
    ZSH_THEME='awesomepanda'

    echo "Setting ZSH Theme to: ${ZSH_THEME}"
    sed -i -e "s/ZSH_THEME=.*/ZSH_THEME=\"${ZSH_THEME}\"/" "${HOME}"/.zshrc
}

setup_ohmyzsh_plugins(){ 
    ZSH_PLUGINS=(git dotenv osx python kubectl docker zsh-completions zsh-syntax-highlighting zsh-autosuggestions)

    echo "Setting up ZSH plugins: ${ZSH_PLUGINS[*]}"
    sed -i -e "s/plugins=.*/plugins=(${ZSH_PLUGINS[*]})/" "${HOME}"/.zshrc
}

setup_git() {
    echo "Setting up Git 🐱" 
    echo -n "What is your GitHub username? " 
    read -r GITHUB_USERNAME
    echo -n "What is your GitHub email? "
    read -r GITHUB_EMAIL

    sed -e "s/REPLACE_ME_WITH_GITHUB_USERNAME/${GITHUB_USERNAME}/" scripts/templates/gitconfig | sed -e "s/REPLACE_ME_WITH_GITHUB_EMAIL/${GITHUB_EMAIL}/" > "${HOME}"/.gitconfig

    echo "Git was setup with the username: ${GITHUB_USERNAME} and email: ${GITHUB_EMAIL}."
    echo "The ${HOME}/.gitconfig file is the following: "
    cat "${HOME}/"/.gitconfig
}

install_kubernetes_tools(){
    KUBERNETES_TOOLS=(stern kubernetes-cli)
    echo "Installing Kubernetes tools: ${KUBERNETES_TOOLS[*]}"
    
    for TOOL in "${KUBERNETES_TOOLS[@]}"; do 
        brew install "${TOOL}"
    done
}

install_docker_tools(){
    DOCKER_TOOLS=(dive)
    echo "Installing Docker tools"

    for TOOL in "${DOCKER_TOOLS[@]}"; do 
        brew install "${TOOL}"
    done 
}

echo "Going to setup a new macOS 💻"

print_preface
install_homebrew
upgrade_homebrew
install_general_tools
install_ohmyzsh
install_ohmyzsh_plugins
setup_ohmyzsh_theme
setup_ohmyzsh_plugins
setup_git

echo "All done! ✅"
exit 0

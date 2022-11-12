#!/bin/bash

# This script installs some of the tools that I most generally use to work and play, on a macOS host 🍎
# It requires Homebrew to already be installed on the host where it will run.

set -e

function print_preface() {
    echo "  🌱 Preface 🌱 "
    echo " ================ "
    echo "This script will install some tools, but there are others, that will have to be downloaded and installed manually first: "
    echo "💻 iTerm "
    echo "💎 Homebrew"

    echo "Do you have those already installed? (y/n)"
    read -r READY_TO_INSTALL

    check_that_homebrew_is_installed

    if [[ $(echo "${READY_TO_INSTALL}" | tr '[:upper:]' '[:lower:]') == 'y' ]]; then
        echo "Great! Do you want to also setup git? (y/n)"
        read -r SETUP_GIT

        if [[ $(echo "${SETUP_GIT}" | tr '[:upper:]' '[:lower:]') == 'y' ]]; then
            echo -n "What is your GitHub username? "
            read -r GITHUB_USERNAME
            echo -n "What is your GitHub email? "
            read -r GITHUB_EMAIL
        fi
    else
        echo "Please install the tools that need to be installed manually first."
        exit 1
    fi
}

function check_that_homebrew_is_installed() {
    IS_HOMEBREW_INSTALLED=$(command -v brew &>/dev/null)

    if [[ ${IS_HOMEBREW_INSTALLED} -eq 0 ]]; then
        echo "Homebrew version $(brew --version | sed -n 1p | sed -e 's/Homebrew //') is already installed. So we can proceed with the installation 🚀"
    else
        echo 'Homebrew is not installed 😥. Please install it running the following command on your terminal:'
        # We do not want to expand this expression, since it's only for printing purposes.
        # shellcheck disable=SC2016
        '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)'
        exit 1
    fi
}

function install_git() {
    IS_GIT_INSTALLED=$(command -v git &>/dev/null)

    if [[ ${IS_GIT_INSTALLED} -eq 0 ]]; then
        echo "git version $(git --version | sed -n 1p | sed -e 's/git version //') is already installed 🐱."
    else
        echo "Installing git 🐱"
        brew install git
    fi
}

function install_general_tools() {
    GENERAL_TOOLS=(tree wget watch jq yq ccat)
    echo "Installing some general tools: ${GENERAL_TOOLS[*]}"

    for TOOL in "${GENERAL_TOOLS[@]}"; do
        brew install "${TOOL}"
    done
}

function install_ohmyzsh() {
    echo "Installing Oh My Zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

function install_ohmyzsh_plugins() {
    OHMYZSH_PLUGINS=(zsh-completions zsh-syntax-highlighting zsh-autosuggestions)
    echo "Installing Oh My Zsh plugins: ${OHMYZSH_PLUGINS[*]}"

    for PLUGIN in "${OHMYZSH_PLUGINS[@]}"; do
        git clone https://github.com/zsh-users/"${PLUGIN}" "${HOME}"/.oh-my-zsh/custom/plugins/"${PLUGIN}"
    done
}

function setup_ohmyzsh_theme() {
    ZSH_THEME='awesomepanda'

    echo "Setting ZSH Theme to: ${ZSH_THEME}"
    sed -i -e "s/ZSH_THEME=.*/ZSH_THEME=\"${ZSH_THEME}\"/" "${HOME}"/.zshrc
}

function setup_ohmyzsh_plugins() {
    ZSH_PLUGINS=(git dotenv osx python kubectl docker zsh-completions zsh-syntax-highlighting zsh-autosuggestions)

    echo "Setting up ZSH plugins: ${ZSH_PLUGINS[*]}"
    sed -i -e "s/plugins=.*/plugins=(${ZSH_PLUGINS[*]})/" "${HOME}"/.zshrc
}

function setup_git() {
    if [[ $(echo "${SETUP_GIT}" | tr '[:upper:]' '[:lower:]') == 'y' ]]; then
        echo "Setting up Git 🐱"

        sed -e "s/REPLACE_ME_WITH_GITHUB_USERNAME/${GITHUB_USERNAME}/" src/templates/gitconfig | sed -e "s/REPLACE_ME_WITH_GITHUB_EMAIL/${GITHUB_EMAIL}/" >"${HOME}"/.gitconfig

        echo "Git was setup with the username: ${GITHUB_USERNAME} and email: ${GITHUB_EMAIL}."
        echo "The ${HOME}/.gitconfig file is the following: "
        cat "${HOME}"/.gitconfig
    else
        echo "Skipping Git 🐱 setup."
    fi
}

function install_docker_tools() {
    DOCKER_TOOLS=(docker docker-compose docker-machine dive)
    echo "Installing Docker tools"

    for TOOL in "${DOCKER_TOOLS[@]}"; do
        brew install "${TOOL}"
    done
}

function install_virtual_box() {
    echo "Installing VirtualBox since that's where minikube and docker will be run"
    brew install virtualbox
}

function install_kubernetes_tools() {
    KUBERNETES_TOOLS=(stern kubernetes-cli minikube helm helmfile k9s)
    echo "Installing Kubernetes tools: ${KUBERNETES_TOOLS[*]}"

    for TOOL in "${KUBERNETES_TOOLS[@]}"; do
        brew install "${TOOL}"
    done
}

echo "Going to setup a new macOS 💻"

print_preface
install_git
install_general_tools
install_ohmyzsh
install_ohmyzsh_plugins
setup_ohmyzsh_theme
setup_ohmyzsh_plugins
setup_git
install_docker_tools
install_virtual_box
install_kubernetes_tools

echo "All done! ✅"
exit 0

#!/usr/bin/env bats

@test 'Homebrew is installed' {
  brew --version
}

@test 'Git is installed and setup' {
  git --version
  [[ -f "${HOME}"/.gitconfig ]]
}

@test 'Oh My Zsh is setup' {
  [[ -f "${HOME}"/.zshrc ]]
}

@test 'Oh My Zsh theme is setup' {
  INSTALLED_THEME=$(grep 'ZSH_THEME=' "${HOME}"/.zshrc | sed -n 1p | sed 's/^[[:space:]]*//')
  [[ "${INSTALLED_THEME}" = "ZSH_THEME=\"awesomepanda\"" ]]
}

@test 'Oh My Zsh plugins are setup' {
  grep 'plugins=' "${HOME}"/.zshrc | sed -n 2p | sed 's/^[[:space:]]*//'
  [[ "${output}" = "plugins=(git dotenv osx python kubectl docker zsh-completions zsh-syntax-highlighting zsh-autosuggestions)" ]]

  [[ -d "${HOME}"/.oh-my-zsh/custom/plugins/zsh-completions ]]

  [[ -d "${HOME}"/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]]

  [[ -d "${HOME}"/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]]
}

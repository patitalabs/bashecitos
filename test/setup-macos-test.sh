#!/usr/bin/env bats

@test 'Homebrew is installed' {
  run brew --version
  (( status == 0 ))
}

@test 'Git is installed and setup' {
  run git --version
  (( status == 0 ))

  run [ -f "${HOME}"/.gitconfig ]
  (( status == 0 ))
}

@test 'Oh my Zsh is setup' {
  run [ -f "${HOME}"/.zshrc ]
  (( status == 0 ))

  run grep 'ZSH_THEME=' "${HOME}"/.zshrc | sed -n 1p
  (( status == 0 ))
  [[ "${output}" = "ZSH_THEME=\"awesomepanda\"" ]]

  run grep 'plugins=' "${HOME}"/.zshrc | sed -n 2p
  (( status == 0 ))
  [[ "${output}" = "plugins=(git dotenv osx python zsh-syntax-highlighting zsh-autosuggestions kubectl docker)" ]]

  run [ -d "${HOME}"/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]
  (( status == 0 ))

  run [ -d "${HOME}"/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]
  (( status == 0 ))
}
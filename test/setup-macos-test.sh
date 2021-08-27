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

@test 'Oh My Zsh is setup' {
  run [ -f "${HOME}"/.zshrc ]
  (( status == 0 ))
}

@test 'Oh My Zsh theme is setup' {
  run grep 'ZSH_THEME=' "${HOME}"/.zshrc
  (( status == 0 ))
  [[ "${output}" = "ZSH_THEME=\"awesomepanda\"" ]]
}

@test 'Oh My Zsh plugins are setup' {
  run grep 'plugins=' "${HOME}"/.zshrc | sed -n 2p
  (( status == 0 ))
  [[ "${output}" = "plugins=(git dotenv osx python kubectl docker zsh-completions zsh-syntax-highlighting zsh-autosuggestions)" ]]

  run [ -d "${HOME}"/.oh-my-zsh/custom/plugins/zsh-completions ]
  (( status == 0 ))

  run [ -d "${HOME}"/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]
  (( status == 0 ))

  run [ -d "${HOME}"/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]
  (( status == 0 ))
}
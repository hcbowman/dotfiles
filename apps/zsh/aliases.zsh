# To fix brew doctor's warning ""config" scripts exist outside your system or Homebrew directorie."
alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'

# Get macOS Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update; sudo gem cleanup'

# Delete Tor
alias dtor='brew uninstall --zap --verbose --cask tor-browser'

# Run AUTOMATIC1111 Web UI
alias sda="cd ${HOME}/Developer/Projects\ -\ GitHub/stable-diffusion-webui && ./run_webui_mac.sh"

#DEBUG
#echo "aliases.zsh ran"
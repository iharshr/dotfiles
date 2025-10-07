export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-autocomplete)

# Git aliases
alias gcl="git clone"
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push origin"
alias gl="git pull origin"
alias gco="git checkout"

# Go binaries in PATH
export PATH=$PATH:$(go env GOPATH)/bin

source $ZSH/oh-my-zsh.sh

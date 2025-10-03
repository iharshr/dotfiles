export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting  zsh-autocomplete)

# Git aliases
alias gcl="git clone"                      # git clone <repo>
alias ga="git add ."                       # git add all changes
alias gc="git commit -m"                   # git commit -m "message"
alias gp="git push origin"                 # git push origin <branch>
alias gl="git pull origin"                 # git pull origin <branch>
alias gco="git checkout"                   # git checkout <branch>

source $ZSH/oh-my-zsh.sh


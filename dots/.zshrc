# Load syntax highlighting (must be at end)
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Load autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Better completion settings
autoload -Uz compinit && compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Colored completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Menu selection
zstyle ':completion:*' menu select

# Partial completion suggestions
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix

PS1='%F{red}%~%f $ '
export EDITOR=nvim
export PATH="$HOME/.local/bin:$PATH"

alias tkill='tmux kill-server'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias sus='systemctl suspend'

bindkey -s '^F' 'tmux-sessionizer\n'
bindkey '^l' autosuggest-accept

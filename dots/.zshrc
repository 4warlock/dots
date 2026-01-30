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
alias u='cat $HOME/unicorn.txt'
alias k='cat $HOME/heart.txt'

#bindkey -s '^F' 'tmux-sessionizer\n'
bindkey '^y' autosuggest-accept

# Fuzzy finder for all directories
bindkey -s '^F' 'tmux-sessionizer\n'
# Quick jumps to specific directories
bindkey -s '\ej' "tmux-sessionizer $HOME/java\n"
bindkey -s '\ek' "tmux-sessionizer $HOME/python\n"
bindkey -s '\el' "tmux-sessionizer $HOME/notes/econ\n"
bindkey -s '\eh' "tmux-sessionizer $HOME/elixir\n"
bindkey -s '\ec' "tmux-sessionizer $HOME/.config\n"

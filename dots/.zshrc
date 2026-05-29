stty -ixon
PROMPT='%F{red}%1~%f $ '

setopt AUTO_CD

export EDITOR=nvim
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/home/ant/.npm-global/bin"

alias tkill='tmux kill-server'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias sus='systemctl suspend'
alias u='cat $HOME/unicorn.txt'
alias k='cat $HOME/heart.txt'
alias poweroff='systemctl poweroff'
alias cv='nvim ~/.config/nvim/init.lua'
alias ct='nvim ~/.config/tmux/tmux.conf'
alias ch='nvim ~/.config/hypr/hyprland.conf'
alias cz='nvim ~/.zshrc'
alias sz='source ~/.zshrc'

bindkey '^y' autosuggest-accept
bindkey -s '^F' 'tmux-sessionizer\n'

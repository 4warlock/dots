stty -ixon
#PS1='%F{red}%~%f $ '
# For ~/ Base and normal pathname 
_prompt_path() {
  [ "$PWD" = "$HOME" ] && echo "~ base" || echo "${PWD/#$HOME/~}"
}
setopt PROMPT_SUBST
PROMPT='%F{red}$(_prompt_path)%f $ '
# Ends here

export EDITOR=nvim
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$(npm config get prefix)/bin"

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
bindkey -s '\el' "tmux-sessionizer $HOME/notes\n"
bindkey -s '\ec' "tmux-sessionizer $HOME/.config\n"
bindkey -s '\eh' "tmux-sessionizer $HOME\n"

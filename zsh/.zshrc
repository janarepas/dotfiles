autoload -U colors && colors
bindkey -e
PS1="%{$fg[magenta]%}%~%{$fg[red]%} %{$reset_color%}$%b "

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
source <(fzf --zsh)

finder() {
    open .
}
zle -N finder
bindkey '^f' finder

# Basic auto/tab complete:
autoload -U compinit && compinit
autoload -U colors && colors
zmodload zsh/complist

_comp_options+=(globdots)		# Include hidden files.




export TERM=xterm-256color
export PATH="$HOME/.local/bin:$PATH"

alias venv="source .venv/bin/activate"
alias vim=nvim
alias vi="nvim"
alias nm="neomutt"
alias p="poetry"
alias mb="~/Documents/projects/microbrew/target/debug/microbrew" 
export EDITOR="nvim"
export MANPAGER="nvim +Man!"
alias rip="yt-dlp -x --audio-format=\"mp3\""

# edit command line
autoload edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line


MAILSYNC_MUTE=1

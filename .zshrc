# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme: See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="yoda"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# truecolor
export COLORTERM=truecolor

# aliases
alias vi="nvim"
alias vi-dots="nvim ~/.config"
alias cd-me="cd ~/Projects/"

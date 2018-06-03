# Profiling Start #############################################################

# Let zprof generate a report on startup
# zmodload zsh/zprof

# Generate an xtrace file
# PS4=$'\\\011%D{%s%6.}\011%x\011%I\011%N\011%e\011'
# exec 3>&2 2>~/.zshstart.$$.log
# setopt xtrace prompt_subst

###############################################################################

# History
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e

zstyle :compinstall filename $HOME/.zshrc

# Only check whether the .zcompdump file needs to be reloaded
# once per day, rather than every time the shell loads.
autoload -Uz compinit
if [ $(uname) == Linux ]; then
  if [ $(expr $(date +"%j") - $(stat -c %Y $HOME/.zcompdump)) > 86400 ]; then
    compinit
  else
    compinit -C
  fi
else
  if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump) ]; then
    compinit
  else
    compinit -C
  fi
fi

# zsh-completions
fpath=(/usr/local/share/zsh-completions $fpath)

# Needed for (neo)vim's base16 color support
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# auto-cd
setopt auto_cd

# up arrow history completion
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down


################################################################################
# Separate configs
################################################################################

autoload -U add-zsh-hook
source $HOME/.dotfiles/zsh/prompt
source $HOME/.dotfiles/zsh/aliases
source $HOME/.dotfiles/zsh/dev

##############################################################################
# Plugins
##############################################################################

export ZDOTDIR=$HOME/.dotfiles/zsh

# Extra completions
# https://github.com/zsh-users/zsh-completions
fpath=($HOME/.dotfiles/zsh/zsh-completions $fpath)

# Colored man-pages
# https://github.com/zuxfoucault/colored-man-pages_mod
source $HOME/.dotfiles/zsh/colored-man-pages_mod/colored-man-pages_mod.plugin.zsh

# Syntax highlighting of shell commands
# https://github.com/zsh-users/zsh-syntax-highlighting
source $HOME/.dotfiles/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Command line fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,.virtualenvs}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 40% --no-reverse'
edit-in-nvim () { nvim $(fzf); }
zle -N edit-in-nvim
bindkey "^p" edit-in-nvim

# Profiling ###################################################################

# Turn off zprof once .zshrc has been sourced
# zprof

# Turn off xtrace once .zshrc has been sourced
# unsetopt xtrace
# exec 2>&3 3>&-

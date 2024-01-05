#==============================================================
#
# C O N F I G U R A T I O N  F O R  Z S H
#

#=-=-=-=-=-=-=
# load stuffs
#=-=-=-=-=-=-=

autoload -U colors && colors
autoload -U compinit && compinit
autoload -U vcs_info && vcs_info

zmodload zsh/complist
zmodload zsh/terminfo

# setopt
setopt \
  autocd \
  ksh_glob \
  extendedglob \
  prompt_subst \
  inc_append_history

bindkey -v

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Import seperate config files
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

for r in $HOME/.config/zsh/*.zsh; do
  if [[ $DEBUG > 0 ]]; then
    echo "zsh: sourcing $r"
  fi
  source $r
done

eval $( dircolors -b $XDG_CONFIG_HOME/zsh/LS_COLORS/LS_COLORS )
export LS_COLORS

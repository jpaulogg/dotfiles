#!/bin/zsh

# aparência
autoload -U colors && colors
if [ $USERNAME = 'root' ]; then
	PS1="%B%F{1}[ %m:%F{12}%~%F{1} ]#%F{reset_color}%b "
else
	PS1="%B%F{1}[ %F{3}%n%F{11}:%~%F{1} ]%F{3}$%F{reset_color}%b "
fi

# opções {{{1
setopt histignorealldups

HISTFILE="${XDG_DATA_HOME}/zsh/histfile"
HISTSIZE=5000
SAVEHIST=5000

# completando linha de comando
autoload -U compinit 
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # não diferenciar maíusculas e minúsculas
zstyle ':completion:*' rehash true                        # achar novos arquivos executáveis no PATH
zmodload zsh/complist                                                           
compinit -C -d /home/jpgg/.cache/zsh/compdump             # cache de inicialização compinit
_comp_options+=(globdots)	                              # incluir arquivos ocultos

# combinação de teclas {{{1
export KEYTIMEOUT=1

bindkey -v
bindkey '^?' backward-delete-char
bindkey '^n' expand-or-complete

bindkey '^r' history-incremental-search-backward
bindkey -M isearch '^n' history-incremental-search-forward
bindkey -M isearch '^p' history-incremental-search-backward

# carregar aliases (abreviações + funções)
source "${ZDOTDIR}/aliases"
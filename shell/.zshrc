#!/bin/zsh

# aparência
autoload -U colors && colors
if [ $USERNAME = 'root' ]; then
	PS1=" %B%F{1}%m:%F{12}%~%F{1}#%F{reset_color}%b "
else
	PS1="%B%F{1}[ %F{144}%n:%F{3}%~%F{1} ]%F{144}$%F{reset_color}%b "
fi

# opções {{{1
setopt autocd
setopt nobeep
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
_comp_options+=(globdots)		# incluir arquivos ocultos

# combinação de teclas {{{1
export KEYTIMEOUT=1

bindkey -v
bindkey '^?' backward-delete-char
bindkey '^p' up-line-or-history
bindkey '^n' expand-or-complete

bindkey '^r' history-incremental-search-backward
bindkey -M isearch '^n' history-incremental-search-forward
bindkey -M isearch '^p' history-incremental-search-backward

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# formato do cursor nos modos tipo 'vi' (inserção, normal, visual)
function zle-keymap-select () {
	case $KEYMAP in
		vicmd) echo -ne '\e[1 q';;      # block
		viins|main) echo -ne '\e[5 q';; # beam
	esac
}
zle -N zle-keymap-select
zle-line-init() {
	echo -ne '\e[5 q'
}
zle -N zle-line-init
echo -ne '\e[5 q'                # iniciar com o cursor "fino" (inserção)
preexec() { echo -ne '\e[5 q' ;} # o mesmo para novos shells

source "${ZDOTDIR}/aliasrc"
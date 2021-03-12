#!/bin/zsh
# Zsh - arquivo de configuração (executado em shells de login e de não-login).

# aparência
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# opções {{{1
setopt autocd
setopt nobeep
setopt histignorealldups

HISTFILE=~/.cache/zsh/history
HISTSIZE=1000
SAVEHIST=1000

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

## Aliases {{{1

# adicionando opções padrões
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'
alias mkdir='mkdir -pv'

alias ls="ls -phN --color=auto --group-directories-first"
alias grep="grep --color=auto"
alias diff="diff --color=auto"
alias less="less -R"

# abreviações de comandos longos
alias xb='xbacklight'
alias sx="startx ${HOME}/.config/X11/xinitrc"
alias p='doas pacman'
alias mci='doas make clean install'

alias gc='git commit'
alias gpom='git push origin master'
alias gitu='git add . && git commit -m "update" && git push origin'

alias v='nvim'

# plugin syntwx
source /home/jpgg/.local/share/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2> /dev/null


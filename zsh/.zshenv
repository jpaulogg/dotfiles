#!/bin/zsh
# Zsh Environment - executed in login, non-login and scripts.

# programas padrões
export TERMINAL='st'
export EDITOR='nvim'

# arquivos de configuração
export XDG_CONFIG_HOME="$HOME/.config"
export XINITRC="${HOME}/.config/X11/xinitrc"
export XAUTHORITY="${HOME}/.config/X11/Xauthority"

# histórico e cache
export HISTFILE="${HOME}/.cache/HISTFILE"
export LESSHISTFILE="${HOME}/.cache/lesshist"

# man pages colors (less)
export LESS_TERMCAP_mb=$(tput bold; tput setaf 9)             # blinking red
export LESS_TERMCAP_md=$(tput bold; tput setaf 14)            # bold (section) aqua
export LESS_TERMCAP_so=$(tput bold; tput rev; tput setaf 15)  # stand (status and search) out white
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)                # end standout
export LESS_TERMCAP_us=$(tput bold; tput setaf 13)            # underline (keywords, etc) purple
export LESS_TERMCAP_ue=$(tput sgr0)                           # end underline
export LESS_TERMCAP_me=$(tput sgr0)                           # end bold, blinking, standout, underline


#
# ~/.bashrc
#

# Entorno
export EDITOR="nano"
export PATH="$HOME/.local/bin:$PATH"
export XDG_DATA_HOME="$HOME/.local/share"

# Si la shell no es interactiva, no cargar prompt, aliases ni herramientas visuales.
[[ $- != *i* ]] && return

# Autocompletado de Bash
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

# Prompt
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi

# Fastfetch centrado para Ghostty
cfetch() {
    command -v fastfetch >/dev/null 2>&1 || return

    local term_width
    term_width=$(tput cols 2>/dev/null || printf '120')

    local text_width=63
    local logo_width=38
    local gap=5
    local margin=2

    # Adaptar la ilustración al espacio disponible
    local available=$((term_width - text_width - gap - margin * 2))

    if (( available < logo_width )); then
        logo_width=$available
        gap=3
    fi

    # Evitar tamaños inválidos en ventanas muy pequeñas
    if (( logo_width < 10 )); then
        fastfetch --logo-type none
        return
    fi

    local logo_height=$((logo_width / 2))

    # Calcular el centrado horizontal
    local total_width=$((logo_width + gap + text_width))
    local padding=$(((term_width - total_width) / 2))

    (( padding < 0 )) && padding=0

    # Seleccionar una ilustración aleatoria
    local -a logos=()
    local file

    for file in "$HOME"/.config/fastfetch/media/*.{png,jpg}; do
        [[ -f "$file" ]] && logos+=("$file")
    done

    if (( ${#logos[@]} == 0 )); then
        fastfetch --logo-type none
        return
    fi

    local logo_path
    logo_path=$(shuf -e "${logos[@]}" -n 1)

    fastfetch \
        --logo "$logo_path" \
        --logo-type kitty \
        --logo-width "$logo_width" \
        --logo-height "$logo_height" \
        --logo-padding-top 3 \
        --logo-padding-right "$gap" \
        --logo-padding-left "$padding"
}
cfetch

# Wrapper de shell para Yazi
y() {
    local tmp cwd
    tmp="$(mktemp -t "yazi-cwd.XXXXXX")" || return

    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"


# ALIAS

# ─────────────────────────────
# Exa
# ─────────────────────────────

# Listado rápido
alias l='exa --icons --color=always --group-directories-first'

# Listado detallado
alias ls='exa -lh --icons --color=always --git --group-directories-first'

# Listado detallado + archivos ocultos
alias la='exa -lha --icons --color=always --git --group-directories-first'

# Ordenar por tamaño, más grandes primero
alias lsz='exa -lh --icons --color=always --git --sort=size --reverse --group-directories-first'

# Ordenar por modificación, más recientes primero
alias lsm='exa -lh --icons --color=always --git --sort=modified --reverse --group-directories-first'

# Solo directorios
alias lsd='exa -D --icons --color=always --group-directories-first'

# Árbol incluyendo archivos ocultos
alias lta='exa -Ta --icons --color=always --group-directories-first'

# Árbol con profundidad configurable
lt() {
    exa -T --icons --color=always --group-directories-first --level="${1:-2}"
}

# Árbol solo de directorios con profundidad configurable
ltd() {
    exa -T -D --icons --color=always --group-directories-first --level="${1:-2}"
}

# Disco de Windows
alias winmount='sudo mount -t ntfs-3g UUID=2E8006678006363D /mnt/windows'
alias winumount='sudo umount /mnt/windows'

# Mantenimiento del sistema en Arch
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias remove='sudo pacman -Rns'
alias search='pacman -Ss'
alias cleanup='sudo pacman -Sc'
alias restart_plasma='systemctl --user restart plasma-plasmashell'
alias pacrefresh='sudo reflector --country Chile,Argentina,Brazil --protocol https --age 12 --latest 20 --sort rate --save /etc/pacman.d/mirrorlist && sudo pacman -Syyu'

# Navegación y herramientas
alias cd..='cd ..'
alias ..='cd ..'
alias mkd='mkdir -p'
alias conf='cd ~/.config'
alias hist='history | grep'
alias grep='grep --color=auto'
alias cls='clear'

#alias comfy='cd ~/Local-IA/ComfyUI && source venv/bin/activate && python main.py & sleep 5 && xdg-open http://127.0.0.1:8188'

comfy() (
    cd "$HOME/Local-IA/ComfyUI" || exit 1
    source venv/bin/activate

    (
        sleep 5
        xdg-open http://127.0.0.1:8188 >/dev/null 2>&1
    ) &

    exec python main.py
)
. "$HOME/.local/bin/env"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

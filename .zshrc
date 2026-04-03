# =========================
# PATH & Core Value
# =========================
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"
ZSH_THEME="powerlevel10k/powerlevel10k"

# =========================
# Plugins
# =========================
plugins=()
[[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]     && plugins+=(zsh-autosuggestions)
[[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]] && plugins+=(zsh-syntax-highlighting)

# Load OMZ file
[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# =========================
# Load Theme
# =========================
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Run fastfetch on initial shell
(( $+commands[fastfetch] )) && fastfetch

# =========================
# Alias
# =========================

(( $+commands[nvim] ))      && alias v='nvim'
(( $+commands[fastfetch] )) && alias ff='fastfetch'
(( $+commands[pacman] ))    && alias c='doas pacman -Rns $(pacman -Qtdq)'
(( $+commands[yay] ))       && alias u='yay -Syu'

# =========================
# etc.
# =========================
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
setopt AUTO_CD

autoload -U colors && colors

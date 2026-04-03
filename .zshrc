# run fastfetch on shell running
if command -v fastfetch >/dev/null 2>&1; then
  fastfetch
fi

# =========================
# PATH
# =========================
export PATH=$HOME/bin:/usr/local/bin:$PATH

# =========================
# OH-MY-ZSH
# =========================
export ZSH="${ZSH:-$HOME/.oh-my-zsh}"

ZSH_THEME="powerlevel10k/powerlevel10k"

# plugins
plugins=()

if [ -d "$ZSH/custom/plugins/zsh-autosuggestions" ]; then
  plugins+=(zsh-autosuggestions)
fi

if [ -d "$ZSH/custom/plugins/zsh-syntax-highlighting" ]; then
  plugins+=(zsh-syntax-highlighting)
fi

# oh-my-zsh load
if [ -f "$ZSH/oh-my-zsh.sh" ]; then
  source $ZSH/oh-my-zsh.sh
fi

# =========================
# Powerlevel10k
# =========================
if [ -f ~/.p10k.zsh ]; then
  source ~/.p10k.zsh
fi

# =========================
# Alias
# =========================

# neovim
if command -v nvim >/dev/null 2>&1; then
  alias v="nvim"
fi

# fastfetch
if command -v fastfetch >/dev/null 2>&1; then
  alias ff="fastfetch"
fi

# Cleanup
if command -v pacman >/dev/null 2>&1; then
  alias c='doas pacman -Rns $(pacman -Qtdq)'
fi

# Update
if command -v yay >/dev/null 2>&1; then
  alias u='yay -Syu'
fi

# =========================
# etc.
# =========================

# history setting
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY

# automation cd
setopt AUTO_CD

# color scheme
autoload -U colors && colors

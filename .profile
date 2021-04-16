export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim

# Using FZF with vim. Ignore files in .gitignore
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

export PATH="$PATH:/home/anton/.local/bin"

source /usr/share/nvm/init-nvm.sh

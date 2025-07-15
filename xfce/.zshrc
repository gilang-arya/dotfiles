# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="mytheme"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting z)
source $ZSH/oh-my-zsh.sh

# Custom alias
alias sudo='sudo '
alias c=clear
alias vi=nvim
alias mi=micro
alias code=codium
alias start='sudo systemctl start '
alias stop='sudo systemctl stop '

#MPV
alias music='~/.scripts/music.sh'

# Package
alias paccek='yay -Q | grep '
alias upgrade='yay -Syu && flatpak upgrade'

# Git
alias gi='git init'
alias gs='git status'
alias ga='git add .'
alias gcm='git commit -m '
alias gp='git push'
alias gc='git clone '
alias grh='git reset --hard '
alias grr='git remote remove '

#Config
alias zshconfig='mi ~/.zshrc'

# Recording Video
alias record='/home/gilang/.scripts/record_ffmpeg.sh'

# Docker
alias cleandock='docker rm -f $(docker ps -a -q) && docker rmi -f $(docker images -a -q) && docker volume rm $(docker volume ls -q) && docker network rm $(docker network ls -q)'

alias grubup="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias hw='hwinfo --short'                                   # Hardware Info
alias update='sudo pacman -Syu'
alias mirror="sudo cachyos-rate-mirrors"
alias ls='eza -al --color=always --group-directories-first --icons' # preferred listing

# Cleanup orphaned packages
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Neovim Config
alias viconf="cd ~/.config/nvim"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

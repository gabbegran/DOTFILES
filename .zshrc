# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


export ZSH="$HOME/.oh-my-zsh"

plugins=(git web-search tailscale zsh-calc sudo ssh-agent)


source $ZSH/oh-my-zsh.sh

bindkey '^Z' undo
bindkey '^[[90;6u' redo



alias hx="helix"
alias ..="cd .."
alias update="sudo pacman -Syyu"
alias install="sudo pacman -S" 
alias tss="sudo tailscale status"
alias tsw="sudo tailscale web"
alias tsd="sudo tailscale down"
alias tsu="sudo tailscale up"
alias tsenpi5="sudo tailscale set --exit-node=pi5 --exit-node-allow-lan-access=true"
alias tsen="sudo tailscale set --exit-node="
alias cat="bat --style=plain --paging=never"
alias cd="z"
alias weather="curl wttr.in/Uppsala" # Replace with your city
alias help="tldr"
alias rm="trash-put"
alias tlist="trash-list"
alias trestore="trash-restore"
alias cheat="curl -s https://cht.sh/"
alias ai="gemini"
alias larp="fastfetch"
alias deploy="/home/za66e/websites/template/deploy.sh"
alias vpnCH="tailscale set --exit-node=ch-zrh-wg-401.mullvad.ts.net --exit-node-allow-lan-access=true"
alias vpnNO="tailscale set --exit-node=no-osl-wg-101.mullvad.ts.net --exit-node-allow-lan-access=true"
alias vpnPI5="tailscale set --exit-node=pi5 --exit-node-allow-lan-access=true"
alias printer="lp -d HP_LaserJet_P2055dn"

# Function to search text and preview with bat
findtext() {
  rg --column --line-number --no-heading --color=always --smart-case --glob "!{.git,node_modules}/*" "$1" | \
  fzf --ansi \
      --delimiter : \
      --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
      --bind "enter:execute(hx {1}:{2})+abort"
}

# Created by newuser for 5.9
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source <(fzf --zsh)

# Created by `pipx` on 2025-12-22 16:20:41
export PATH="$PATH:/home/za66e/.local/bin"

export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

# typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
fastfetch
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(thefuck --alias)"

export PATH="$HOME/.local/bin:$PATH"

export PATH=$PATH:/home/za66e/.spicetify
export PATH=$PATH:~/.spicetify











zstyle :omz:plugins:ssh-agent identities id_rsa

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH="/usr/local/sbin:$PATH"

# Source antigen
source /opt/homebrew/share/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundles <<EOBUNDLES
  git
  command-not-found
  zsh-users/zsh-completions
  zsh-users/zsh-syntax-highlighting
  asdf
EOBUNDLES

# Load the theme.
antigen theme romkatv/powerlevel10k

# Tell Antigen that you're done.
antigen apply

# Source all sourced configs
for file in ~/dotfiles/*; do
  source $file
done

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

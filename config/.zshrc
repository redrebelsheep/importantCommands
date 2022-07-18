export PATH=${PATH}:/usr/local/mysql/bin/
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export PATH=/opt/d1ade4u/bin:$PATH
export ZSH="/Users/d1ade4u/.oh-my-zsh"
export DEFAULT_USER="d1ade4u"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="agnoster"


ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git macos)

source $ZSH/oh-my-zsh.sh

alias ..="cd .."
alias cd..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"
alias o="open ."

alias ll="ls -la -G"
alias g="git"
alias gp="git pull"
alias gundo="git reset --soft HEAD~"
alias gamend="git commit -av --amend --no-edit"
alias zshconfig="code ~/.zshrc"
alias install="brew install"
alias uninstall="brew uninstall"

alias c='pygmentize -O style=monokai -f console256 -g'

## MacOSX Lookscreen
alias lock="pmset displaysleepnow"

# FUNCTIONS

function hl (){
    highlight -O rtf "$1" | pbcopy
    echo "code is copied to clipboard"
}

# Create a new directory and enter it
function md() {
	mkdir -p "$@" && cd "$@"
}

function code {
    open -a '/Volumes/Macintosh HD/Applications/Visual Studio Code.app' "$1"
}

# Go to the root of the current git project, or just go one folder up
function up() {
  export git_dir="$(git rev-parse --show-toplevel 2> /dev/null)"
  if [ -z $git_dir ]
  then
    cd ..
  else
    cd $git_dir
  fi
}
export PATH="/usr/local/opt/ruby/bin:/usr/local/lib/ruby/gems/3.0.0/bin:$PATH"
# eval "$(rbenv init - zsh)"
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# /usr/libexec/java_home -V | grep jdk
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-11.0.13.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

#export http_proxy=http://127.0.0.1:9000/localproxy-6885f7ba.pac
#export https_proxy=http://127.0.0.1:9000/localproxy-6885f7ba.pac
#export no_proxy=localhost,127.0.0.1,.wob.vw.vwg,.vwgroup.com



clear

if pgrep -x "Zscaler" > /dev/null; then
        echo "Zscaler running - setting proxy env..."
        export http_proxy=http://127.0.0.1:9000
        export https_proxy=http://127.0.0.1:9000
else
        echo "Zscaler not running - no proxy env set..."
        echo "No proxy env set..."w
fi


# if pgrep -x "Zscaler" > /dev/null; then
# echo "Zscaler running - setting proxy env..."
# export http_proxy=http://127.0.0.1:9000
# export https_proxy=http://127.0.0.1:9000
# npm config set proxy http://127.0.0.1:9000
# npm config set https-proxy http://127.0.0.1:9000
# else
# echo "Zscaler not running - no proxy env set..."
# echo "No proxy env set..."
# npm config rm proxy
# npm config rm https-proxy
# fi


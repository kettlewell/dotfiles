# TODO:
#        slim down zshrc to not use ohmyzsh
#    Move All into ${HOME}/dotfiles/custom_zsh.sh
#        or move all of .oh-my-zsh.sh into here... 
# 

# export PATH=$HOME/bin:/usr/local/bin:$PATH
#zmodload zsh/zprof # top of your .zshrc file

export ZSH="${HOME}/dotfiles/zsh"
#echo "ZSH: ${ZSH}"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# TODO: DELETE CUSTOM
# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# TODO: All Plugins in dir
#plugins=(git colored-man-pages colorize postgres tmux)

#source $ZSH/custom_zsh.sh

# Set ZSH_CACHE_DIR to the path where cache files should be created
# or else we will use the default cache/
if [[ -z "$ZSH_CACHE_DIR" ]]; then
  ZSH_CACHE_DIR="$ZSH/cache"
fi

## Migrate .zsh-update file to $ZSH_CACHE_DIR
#if [ -f ~/.zsh-update ] && [ ! -f ${ZSH_CACHE_DIR}/.zsh-update ]; then
#    mv ~/.zsh-update ${ZSH_CACHE_DIR}/.zsh-update
#fi

# Check for updates on initial load...
#if [ "$DISABLE_AUTO_UPDATE" != "true" ]; then
#  env ZSH=$ZSH ZSH_CACHE_DIR=$ZSH_CACHE_DIR DISABLE_UPDATE_PROMPT=$DISABLE_UPDATE_PROMPT zsh -f $ZSH/tools/check_for_upgrade.sh
#fi

# Initializes Oh My Zsh

# add a function path
#fpath=($ZSH/functions $ZSH/completions $fpath)

# Load all stock functions (from $fpath files) called below.
autoload -U compaudit compinit

# Set ZSH_CUSTOM to the path where your custom config files
# and plugins exists, or else we will use the default custom/
#if [[ -z "$ZSH_CUSTOM" ]]; then
#    ZSH_CUSTOM="$ZSH/custom"
#fi


is_plugin() {
  local base_dir=$1
  #local name=$2
  #echo "is_plugin $base_dir/plugins/$name/$name.plugin.zsh"
  #echo "or"
  #echo "$base_dir/plugins/$name/_$name"
  #builtin test -f $base_dir #/plugins/$name/$name.plugin.zsh \
  #  || builtin test -f $base_dir/plugins/$name/_$name
  builtin test -f $base_dir
}

# Add all defined plugins to fpath. This must be done
# before running compinit.
#for plugin ($plugins); do
for plugin ($ZSH/plugins/**/*.plugin.zsh); do
  #if is_plugin $ZSH_CUSTOM $plugin; then
  #  fpath=($ZSH_CUSTOM/plugins/$plugin $fpath)
  if is_plugin $plugin; then
    echo "[oh-my-zsh] plugin '${plugin%/*}' FOUND"
    fpath=(${plugin%/*} $fpath)
  else
    echo "[oh-my-zsh] plugin '${plugin%/*}' not found"
  fi
done

# Figure out the SHORT hostname
if [[ "$OSTYPE" = darwin* ]]; then
  # macOS's $HOST changes with dhcp, etc. Use ComputerName if possible.
  SHORT_HOST=$(scutil --get ComputerName 2>/dev/null) || SHORT_HOST=${HOST/.*/}
else
  SHORT_HOST=${HOST/.*/}
fi

# Save the location of the current completion dump file.
if [ -z "$ZSH_COMPDUMP" ]; then
  ZSH_COMPDUMP="${ZDOTDIR:-${HOME}}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"
fi

if [[ $ZSH_DISABLE_COMPFIX != true ]]; then
  source $ZSH/lib/compfix.zsh
  # If completion insecurities exist, warn the user
  handle_completion_insecurities
  # Load only from secure directories
  compinit -i -C -d "${ZSH_COMPDUMP}"
else
  # If the user wants it, load from all found directories
  compinit -u -C -d "${ZSH_COMPDUMP}"
fi


# Load all of the config files in ~/oh-my-zsh that end in .zsh
# TIP: Add files you don't want in git to .gitignore
for config_file ($ZSH/lib/*.zsh); do
    echo "[oh-my-zsh] config_file '$config_file'"
  custom_config_file="${ZSH_CUSTOM}/lib/${config_file:t}"
  [ -f "${custom_config_file}" ] && config_file=${custom_config_file}
  source $config_file
done

# Load all of the plugins that were defined in ~/.zshrc
for plugin ($ZSH/plugins/**/*.plugin.zsh); do
    echo "[oh-my-zsh] plugin '$plugin'"
   if [ -f $plugin ]; then
      source $plugin
   fi
done

# Load all of your custom configurations from custom/
#for config_file ($ZSH_CUSTOM/*.zsh(N)); do
#  source $config_file
#done
unset config_file

# Load the theme
if [ ! "$ZSH_THEME" = ""  ]; then
  if [ -f "$ZSH_CUSTOM/$ZSH_THEME.zsh-theme" ]; then
    source "$ZSH_CUSTOM/$ZSH_THEME.zsh-theme"
  elif [ -f "$ZSH_CUSTOM/themes/$ZSH_THEME.zsh-theme" ]; then
    source "$ZSH_CUSTOM/themes/$ZSH_THEME.zsh-theme"
  else
    source "$ZSH/themes/$ZSH_THEME.zsh-theme"
  fi
fi




# User configuration


# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='emacs'
else
   export EDITOR='emacs'
fi

# TODO: Load Aliases
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# zprof # bottom of .zshrc

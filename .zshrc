# Path to your oh-my-zsh installation.
export ZSH=/home/iann/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="badwolfie"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git systemd sudo web-search)

# User configuration

export PATH="/home/iann/perl5/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:."
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh
#source /usr/share/zsh/scripts/antigen/antigen.zsh

# You may need to manually set your language environment
export LANG=es_MX.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR="nvim"
else
  export EDITOR="nvim"
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias grep="grep --color=auto"
alias ls="ls --color=auto -h"
alias webroot="cd /srv/http/"
alias database="mysql sigca1 -u root -p"
alias icheck="ping -c 3 www.google.com"
alias ssh_cic="ssh -p 81 ian@ihernandez.cic.ipn.mx"
alias cdiff="colordiff"
alias vim="nvim"

# Rewriting scp so that it connects to my work computer
scp () {
	cic_request=false
	for arg in $@; do
		if [[ ($arg == *"ihernandez"*) || ($arg == *"148.204.65.213"*) ]]; then
			cic_request=true
			break
		fi
	done
	
	if [[ $cic_request == true ]]; then
		/usr/bin/scp -P 81 $*
	else 
		/usr/bin/scp $*
	fi
}

# Script to copy a file to my ditfiles git folder
dotfile () {
	cp $* ~/Proyectos/dotfiles 
}

# Starts apache and mysql servers
startsrv () { 
    sudo echo -n "Starting apache server (via systemctl)... "
    sudo systemctl start httpd.service
    echo "Done."

    echo -n "Starting mysql server (via systemctl)... "
    sudo systemctl start mysqld.service
    echo "Done."
}

# Stops apache and mysql servers
stopsrv () { 
    sudo echo -n "Stopping apache server (via systemctl)... "
    sudo systemctl stop httpd.service
    echo "Done."

    echo -n "Stopping mysql server (via systemctl)... "
    sudo systemctl stop mysqld.service
    echo "Done."
}

# Removes orphaned packages
rmorph () {
    if [[ ! -n $(pacman -Qdtq) ]]; then
        echo "No orphans to remove."
    else
        sudo pacman -Rns $(pacman -Qdtq)
    fi
}

# Checks explicity installed packages (not in base, base-devel or xorg)
checkinstall () {
	db="/tmp/pkg_db"
	xorg="/tmp/pkg_xorg"
	base="/tmp/pkg_base"
	basedevel="/tmp/pkg_basedevel"
    gnome="/tmp/pkg_gnome"
    gnomeextra="/tmp/pkg_gnomeextra"
	tmp="/tmp/pkg_temp"
		
	pacman -Qqet            | sort -u > $db
	pacman -Qqg xorg        | sort -u > $xorg
    pacman -Qqg base        | sort -u > $base
    pacman -Qqg base-devel  | sort -u > $basedevel
    pacman -Qqg gnome       | sort -u > $gnome
    pacman -Qqg gnome-extra | sort -u > $gnomeextra

    comm -23 $db $xorg > $tmp
    cat $tmp > $db
    comm -23 $db $base > $tmp
    cat $tmp > $db
    comm -23 $db $basedevel > $tmp
    cat $tmp > $db
    comm -23 $db $gnome > $tmp
    cat $tmp > $db
    comm -23 $db $gnomeextra 
}

# Generate a list of all files that are not part of a package
checkfiles () {
    TMPDIR=`mktemp -d`
    FILTER=$(sed '1,/^## FILTER/d' $0 | tr '\n' '|')
    FILTER=${FILTER%|}

    cd $TMPDIR
    find /bin /boot /etc /lib /opt /sbin /usr /var | sort -u > full
    pacman -Ql | tee owned_full | cut -d' ' -f2- | sed 's/\/$//' | sort -u > owned

    grep -Ev "^($FILTER)" owned > owned- && mv owned- owned

    echo -e '\033[1mOwned, but not found:\033[0m'
    comm -13 full owned | while read entry
    do
            echo [`grep --max-count=1 $entry owned_full|cut -d' ' -f1`] $entry
    done | sort

    grep -Ev "^($FILTER)" full > full- && mv full- full

    echo -e '\n\033[1mFound, but not owned:\033[0m'
    comm -23 full owned

    rm $TMPDIR/{full,owned,owned_full} && rmdir $TMPDIR
    exit $?

    ## FILTERED FILES / PATHS ##
    /boot/grub
    /dev
    /etc/X11/xdm/authdir
    /home
    /media
    /mnt
    /proc
    /root
    /srv
    /sys
    /tmp
    /var/abs
    /var/cache
    /var/games
    /var/log
    /var/lib/pacman
    /var/lib/mysql
    /var/run
    /var/tmp
}

if [[ $TERM == "xterm" ]]; then
    export TERM=xterm-256color
fi

echo -e "\e[1;35mBienvenido Ian...\e[0m"

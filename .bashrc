#
# ~/.bashrc
#

# if [ "$TERM" = "linux" ]; then
#     echo -en "\e]P0222222" #black
#     echo -en "\e]P8222222" #darkgrey
#     echo -en "\e]P1803232" #darkred
#     echo -en "\e]P9982b2b" #red
#     echo -en "\e]P25b762f" #darkgreen
#     echo -en "\e]PA89b83f" #green
#     echo -en "\e]P3aa9943" #brown
#     echo -en "\e]PBefef60" #yellow
#     echo -en "\e]P4324c80" #darkblue
#     echo -en "\e]PC2b4f98" #blue
#     echo -en "\e]P5706c9a" #darkmagenta
#     echo -en "\e]PD826ab1" #magenta
#     echo -en "\e]P692b19e" #darkcyan
#     echo -en "\e]PEa1cdcd" #cyan
#     echo -en "\e]P7ffffff" #lightgrey
#     echo -en "\e]PFdedede" #white
#     clear #for background artifacting
# fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias grep='grep --color=auto'
alias ls='ls --color=auto -h'
alias webroot='cd /srv/http'
alias database='mysql sigca -u root -p'
alias icheck='ping -c 3 www.google.com'
export EDITOR='vim' 

# Renaming frequently used pacman and yaourt operations
alias pacupgrade='yaourt -Syua'
alias pacinstall='sudo pacman -S'
alias pacremove='sudo pacman -R'
alias aurinstall='yaourt -S'

complete -cf pacupgrade
complete -cf pacinstall
complete -cf pacremove
complete -cf aurinstall


# SAL_USE_VCLPLUGIN=gtk3 lowriter

# Starts apache and mysql servers
startsrv() { 
    sudo echo -n "Starting apache server (via systemctl)... "
    sudo systemctl start httpd.service
    echo "Done."

    echo -n "Starting mysql server (via systemctl)... "
    sudo systemctl start mysqld.service
    echo "Done."
}

# Stops apache and mysql servers
stopsrv() { 
    sudo echo -n "Stopping apache server (via systemctl)... "
    sudo systemctl stop httpd.service
    echo "Done."

    echo -n "Stopping mysql server (via systemctl)... "
    sudo systemctl stop mysqld.service
    echo "Done."
}

# Removes orphaned packages
rmorph() {
    if [[ ! -n $(pacman -Qdtq) ]]; then
        echo "No orphans to remove."
    else
        sudo pacman -Rns $(pacman -Qdtq)
    fi
}

# Checks explicity installed packages (not in base, base-devel or xorg)
checkinstall() {
	db="/tmp/pkg_db"
	xorg="/tmp/pkg_xorg"
	base="/tmp/pkg_base"
	basedevel="/tmp/pkg_basedevel"
	tmp="/tmp/pkg_temp"
		
	pacman -Qqet           | sort -u > $db
	pacman -Qqg xorg       | sort -u > $xorg
    pacman -Qqg base       | sort -u > $base
    pacman -Qqg base-devel | sort -u > $basedevel

    comm -23 $db $xorg > $tmp
    cat $tmp > $db
    comm -23 $db $base > $tmp
    cat $tmp > $db
    comm -23 $db $basedevel
}

# Generate a list of all files that are not part of a package
checkfiles() {
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

# Compile and execute a C source on the fly
quickc() {
        [[ $1 ]]    || { echo "Falta el nombre del archivo de codigo fuente." >&2; return 1; }
        [[ -r $1 ]] || { printf "El archivo %s no existe o esta dañado.\n" "$1" >&2; return 1; }
    local output_path=${TMPDIR:-/tmp}/${1##*/};
    gcc -Wall "$1" -o "$output_path" && "$output_path";
    rm "$output_path";
    return 0;
}

# Upgrade gdm source files for compiling
upgdm() {
    echo 'Cleaning build directory...'
    rm -rf Documentos/abs/gdm
    sudo abs extra/gdm
    cp -r /var/abs/extra/gdm/ Documentos/abs/
    cd Documentos/abs/gdm/
    vim PKGBUILD
    makepkg -s
    echo 'Build completed. Proceed to install libgdm and gdm packages using pacman.'
}

# Custom prompt and welcome message
PS1='\[\e[1;34m\]\u@\h \[\e[1;35m\]\W \$\[\e[0m\] '
echo -e '\e[1;35mBienvenido Ian...\e[0m'

PATH="/home/iann/perl5/bin${PATH+:}${PATH}"; export PATH;
PERL5LIB="/home/iann/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/iann/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/iann/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/iann/perl5"; export PERL_MM_OPT;

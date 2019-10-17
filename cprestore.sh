#!/usr/bin/bash
# By arshatech.com
# You can easyly restore your cPanel backups by cprestore.sh script.

colors () {
	green='\033[1;32m'
	red='\033[1;31m'
	blue='\033[1;34m'
	cyan='\033[1;36m'
	yellow='\033[1;33m'
	nc='\033[0m'
}

restore () {
	printf "\n%10s${blue} [*] Restoring backups...${nc}"
	for each in "${backups[@]}"; do
		/scripts/restorepkg $each 2>&1  1>/dev/null
		user=$(echo $each | awk -F/ '{ print $NF }')
		if [ $? == 0 ]; then
		        printf "\n%12s${green} [+] ${blue} $user${nc}"
		else
		        printf "\n%12s${red} [-] ${blue}$user${nc}"
		fi
	done
	echo
}

colors
printf "%7s${cyan}[~] By: arshatech.com${nc}"
if [ "$EUID" -ne 0 ]; then
	printf "\n%9s${red}[-] Error: Run this script as root user!${nc}\n"
	exit 0
elif [ "$#" != "1" ]; then
	printf "\n%9s${yellow}[*] Usage:   bash `basename $0` <cPanelBackups>${nc}\n"
	printf "%9s${yellow}    Example: bash `basename $0` /home/backups/${nc}\n"
	exit 0
else
	arg=$1
	arg=$(echo $arg | sed 's:/[/]*$::g')
	arg=$(echo $arg | sed 's/\([/]\)\1\+/\1/g')
	backups=( $(ls $arg/*tar.gz) )
fi

if [ -a /scripts/restorepkg ]; then
	printf "\n%8s${blue} [+] cPanel detected!${nc}"
	restore
	printf "%10s${blue} [*] Finished!${nc}\n"
	exit 0
else
	printf "\n%8s${red} [-] cPanel is not detected!${nc}\n"
	exit 0
fi

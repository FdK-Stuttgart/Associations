#!/bin/sh
#
# Reproducible Development Environment
#
# TODO Add nginx php-fpm as in the guix-lemp-container
# https://notabug.org/hackware/guix-lemp-container.git
#
# Wishlist: Include XDebug

wd=$(pwd) # WD=$(dirname "$0") # i.e. path to this file

# MariaDB
sed -i -e "s|#mysql_user#|$(whoami)|" $wd/etc/my.cnf

# Recreate the dirs destroyed by `git clean --force -dx`:
for prjd in \
        $wd/node_modules \
        $wd/map/app-map/node_modules \
        $wd/map/app-form/node_modules \
        $wd/var/log \
        $wd/var/lib/mysql/data \
        ;
    do
    # printf "prjd: $prjd\n"
    if [ ! -d $prjd ]; then
        mkdir --parent $prjd
    fi
done

# $wd/node_modules should contain only the packages needed by angular
# (the ng) itself. Both app-map and app-form have their node_modules-directories

# TODO replace busybox with env
cliTools="$cliTools gnupg busybox rsync openssh bash ripgrep less mycli"
cliTools="$cliTools grep git coreutils sed which ncurses"
cliTools="$cliTools php mariadb pgcli jq nss-certs curl"
cliTools="$cliTools node"
cliTools="$cliTools openjdk@17.0.3:jdk leiningen"

cmd=guix
# [[ ! $(command -v $cmd) ]] - '[[' is a bashishm
if [ ! "$(command -v $cmd)" ]; then
    printf "ERR: Command not available: %s\n" $cmd
    exit 1;
fi
# --preserve=^fdk
#   preserve environment variables matching REGEX
# TODO add '--export-manifest' to obtain an scm file
set -x
guix shell \
     --container --network \
     $cliTools \
     --preserve=^fdk \
     --share=$wd/.bash_profile=$HOME/.bash_profile \
     --share=$wd/.bashrc=$HOME/.bashrc \
     --share=$wd/node_modules=$HOME/node_modules \
     --share=$wd/map/app-map/node_modules=$HOME/node_modules/map/app-map/ \
     --share=$wd/map/app-form/node_modules=$HOME/node_modules/map/app-form/ \
     --share=$HOME/.gitconfig=$HOME/.gitconfig \
     --share=$HOME/.ssh/=$HOME/.ssh/ \
     --share=$wd/etc=/usr/etc \
     --share=$wd/var/log=/var/log \
     --share=$wd/var/lib/mysql/data=/var/lib/mysql/data \
     --share=$wd \
     -- bash

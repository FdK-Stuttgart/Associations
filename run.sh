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
grep -qF "#mysqld_user#" $wd/etc/my.cnf &&\
    sed -i -e "s|#mysqld_user#|$(whoami)|" $wd/etc/my.cnf

prj_dirs=(
    $wd/node_modules
    $wd/map/app-map/node_modules
    $wd/map/app-form/node_modules
    $wd/var/log
    $wd/var/lib/mysql/data
)

# `git clean --force -dx` destroys the prj_dirs. Recreate it:
for prjd in ${prj_dirs[@]}; do
    if [ ! -d $prjd ]; then
        mkdir --parent $prjd
    fi
done

# $wd/node_modules should contain only the packages needed by angular
# (the ng) itself. Both app-map and app-form have their node_modules-directories

# TODO replace busybox with env
cliTools="$cliTools busybox rsync openssh bash ripgrep less mycli"
cliTools="$cliTools grep git coreutils sed node which"

# --preserve=^fdk
#   preserve environment variables matching REGEX
set -x
guix shell \
     --container --network --check \
     node php mariadb nss-certs curl $cliTools \
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

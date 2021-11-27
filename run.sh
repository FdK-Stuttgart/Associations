#!/bin/sh
#
# Reproducible Development Environment
#
# TODO Add nginx php-fpm as in the guix-lemp-container
# https://notabug.org/hackware/guix-lemp-container.git
#
# Wishlist: Include XDebug

if [ ! $# -eq 2 ]; then
   cat << EOF
usage: $0 <shared_path> <public_path>
       shared_path: exchange directory
       public_path: public facing location, must be within shared_path

   ex: $0 /home/user/dev public_html
EOF
   exit 1
fi

shared_path="$1"
public_path="$1/$2"
file_path=$(dirname "$0") # path to this file

# MariaDB
grep -qF "#mysqld_user#" $file_path/etc/my.cnf &&\
    sed -i -e "s|#mysqld_user#|$(whoami)|" $file_path/etc/my.cnf

prj_dirs=(
    $file_path/node_modules
    $file_path/map/app-map/node_modules
    $file_path/map/app-form/node_modules
    $file_path/var/log
    $file_path/var/lib/mysql/data
)

# `git clean --force -dx` destroys the prj_dirs. Recreate it:
for prjd in ${prj_dirs[@]}; do
    if [ ! -d $prjd ]; then
        mkdir --parent $prjd
    fi
done

# $file_path/node_modules should contain only the packages needed by angular
# (the ng) itself. Both app-map and app-form have their node_modules-directories

# TODO replace busybox with env
cliTools="busybox rsync openssh bash ripgrep less mycli"
cliTools="$cliTools grep git coreutils sed node which"
guix shell \
     --container --network --no-cwd --check \
     node php mariadb nss-certs curl $cliTools \
     --preserve=^fdk \
     --share=$file_path/.bash_profile=$HOME/.bash_profile \
     --share=$file_path/.bashrc=$HOME/.bashrc \
     --share=$file_path/node_modules=$HOME/node_modules \
     --share=$file_path/map/app-map/node_modules=$HOME/node_modules/map/app-map/ \
     --share=$file_path/map/app-form/node_modules=$HOME/node_modulesmap/app-form/ \
     --share=$HOME/.gitconfig=$HOME/.gitconfig \
     --share=$file_path/etc=/usr/etc \
     --share=$file_path/var/log=/var/log \
     --share=$file_path/var/lib/mysql/data=/var/lib/mysql/data \
     --share=$shared_path \
     -- bash

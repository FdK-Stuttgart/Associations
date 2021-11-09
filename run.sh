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

if [ ! -d $file_path/node_modules ]; then
    mkdir $file_path/node_modules
fi

# $file_path/node_modules should contain only the packages needed by angular
# (the ng) itself. Both app-map and app-form have their node_modules-directories

cliTools="busybox ripgrep"
# cliTools="$cliTools coreutils"
guix shell \
     --container --network --no-cwd \
     node php mariadb nss-certs curl $cliTools \
     --share=$file_path/node_modules=$HOME/node_modules \
     --share=$file_path/etc=/usr/etc \
     --share=$file_path/var/log=/var/log \
     --share=$file_path/var/lib/mysql/data=/var/lib/mysql/data \
     --share=$shared_path

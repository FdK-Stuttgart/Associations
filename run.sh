#!/bin/sh
#
# Reproducible Development Environment

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

prj_dirs=(
    $wd/node_modules
    $wd/map/app-map/node_modules
    $wd/map/app-form/node_modules
    $wd/var/log
)

# `git clean --force -dx` destroys the prj_dirs. Recreate it:
for prjd in ${prj_dirs[@]}; do
    if [ ! -d $prjd ]; then
        set -x  # Print commands and their arguments as they are executed.
        mkdir --parent $prjd
        { retval="$?"; set +x; } 2>/dev/null
    fi
done

# $wd/node_modules should contain only the packages needed by angular
# (the ng) itself. Both app-map and app-form have their node_modules-directories

cmd=guix
# [[ ! $(command -v $cmd) ]] - '[[' is a bashishm
if [ ! "$(command -v $cmd)" ]; then
    printf "ERR: Command not available: %s\n" $cmd
    exit 1;
fi

# --preserve=REGEX
#   preserve environment variables matching REGEX
#
# The $DISPLAY is needed by clojure.inspector, however the
#   --preserve=^DISPLAY
# leads to an error in the REPL:
#   Authorization required, but no authorization protocol specified
# and:
#   error in process filter: cljr--maybe-nses-in-bad-state: \
#   Some namespaces are in a bad state: ...

# No shell is started when the '--search-paths' parameter is used. Only the
# variables making up the environment are displayed.
#   guix shell --search-paths

set -x
guix shell \
     --manifest=manifest.scm \
     --container --network \
     --preserve=^fdk \
     --share=/usr/bin \
     --share=$HOME/.bash_history=$HOME/.bash_history \
     --share=$HOME/.config/fish=$HOME/.config/fish \
     --share=$HOME/.gitconfig=$HOME/.gitconfig \
     --share=$HOME/.m2/=$HOME/.m2/ \
     --share=$HOME/.ssh/=$HOME/.ssh/ \
     --share=$wd/.bash_profile=$HOME/.bash_profile \
     --share=$wd/.bashrc=$HOME/.bashrc \
     --share=$wd/.envrc=$HOME/.envrc \
     --share=$wd/etc=/usr/etc \
     --share=$wd/map/app-form/node_modules=$HOME/node_modules/map/app-form/ \
     --share=$wd/map/app-map/node_modules=$HOME/node_modules/map/app-map/ \
     --share=$wd/node_modules=$HOME/node_modules \
     --share=$wd/var/lib/mysql/data=/var/lib/mysql/data \
     --share=$wd/var/log=/var/log \
     --share=$wd \
     -- bash

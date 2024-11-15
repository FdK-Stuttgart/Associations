#!/bin/sh
#
# Reproducible Development Environment

wd=$(pwd) # WD=$(dirname "$0") # working directory, i.e. path to this file

# MariaDB
sed -i -e "s|#mysql_user#|$(whoami)|" $wd/etc/my.cnf

# Recreate the dirs destroyed by `git clean --force -dx`. See also .bashrc
for extraDirs in \
        $wd/node_modules \
        $wd/map/app-map/node_modules \
        $wd/map/app-form/node_modules \
        $wd/var/log \
        $wd/var/lib/mysql/data \
        ;
    do
    # printf "extraDirs: $extraDirs\n"
    if [ ! -d $extraDirs ]; then
        set -x  # Print commands and their arguments as they are executed.
        mkdir --parent $extraDirs
        { retval="$?"; set +x; } 2>/dev/null
    fi
done

# $wd/node_modules should contain only the packages needed by angular
# (the ng) itself. Both app-map and app-form have their node_modules-directories

cmd=guix
# In bash the `command` has no '--search' parameter. Only in fish-shell
# [[ ! $(command -v $cmd) ]] - using double brackets '[[' / ']]' is a bashishm
if [ ! "$(command -v $cmd)" ]; then
    printf "ERR: Command not available: %s\n" $cmd
    exit 1;
fi

# --preserve=REGEX
#   preserve environment variables matching REGEX
#
# Following is needed by clojure.inspector:
# --preserve=^DISPLAY$ --preserve=^XAUTHORITY$ \
# --share=/run/user/1000/gdm/Xauthority=/run/user/1000/gdm/Xauthority \
# or, when the GDM is not used, try:
# --share=/run/user/1000/ICEauthority=/run/user/1000/ICEauthority \

# No shell is started when the '--search-paths' parameter is used. Only the
# variables making up the environment are displayed.
#   guix shell --search-paths

# Make ./persistent-profile a symlink to the `guix shell ...` result, and
# register it as a garbage collector root, i.e. prevent garbage collection
# during(!) the `guix shell ...` session:
# --root=./persistent-profile \

# Create environment for the package that the '...' EXPR evaluates to.
# --expression='(list (@ (gnu packages bash) bash) "include")' \

# Expose the symlink, in case the script is started from fdk.kit or similar.
# Warning: hardcoded path! See also .bashrc
# --share=$HOME/dec/fdk=$HOME/dec/fdk \

# set up my local time
# --share=/etc/localtime=/etc/localtime

# for rlwrap called via `clj -M:dev:nrepl`
# --preserve=^TERM$

set -x # Print commands and their arguments as they are executed.
guix shell \
     --root=./persistent-profile \
     --manifest=manifest.scm \
     --container --network \
     --preserve=^TERM$ \
     --preserve=^fdk \
     --preserve=^CMAP \
     --preserve=^DISPLAY$ --preserve=^XAUTHORITY$ \
     --share=/run/user/1000/ICEauthority=/run/user/1000/ICEauthority \
     --share=/usr/bin \
     --share=/etc/localtime=/etc/localtime \
     --share=$HOME/.bash_history=$HOME/.bash_history \
     --share=$HOME/.config/fish=$HOME/.config/fish \
     --share=$HOME/.gitconfig=$HOME/.gitconfig \
     --share=$HOME/.m2/=$HOME/.m2/ \
     --share=$HOME/.ssh/=$HOME/.ssh/ \
     --share=$HOME/dec/fdk=$HOME/dec/fdk \
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

# Bash initialization for interactive non-login shells and
# for remote shells (info "(bash) Bash Startup Files").

# Export 'SHELL' to child processes.  Programs such as 'screen'
# honor it and otherwise use /bin/sh.
export SHELL

# /run is not automatically created by guix
mkdir /run

# Quick access to $GUIX_ENVIRONMENT, for usage on config files
# (currently only /etc/nginx/nginx.conf)
ln -s $GUIX_ENVIRONMENT /env

# Link every file in /usr/etc on /etc
ls -1d /usr/etc/* | while read filepath; do
    ln -s $filepath /etc/
done

# https://www.reddit.com/r/GUIX/comments/kt7tqr/clearing_a_terminal_in_guix
clear () {
    printf '\e[2J\e[H'
}

alias ng='node $HOME/node_modules/\@angular/cli/bin/ng'
# node_bin=`which node`
# ng_bin=$HOME/node_modules/\@angular/cli/bin/ng
#  serve_map_cmd="$node_bin $ng_bin serve --port 4021"
# serve_form_cmd="$node_bin $ng_bin serve --port 4022"

prjdir=~/dec/fdk
port_map=4201
port_form=4202

p1=$prjdir/map/app-map/package.json
p11=$prjdir/map/app-map/package-lock.json
p2=$prjdir/map/app-form/package.json
p22=$prjdir/map/app-form/package-lock.json

test_php () {
    printf "Testing php WebServer... \n"
    url=http://localhost:4200/api/associations/read-associations.php
    cnt_chars=$(curl --silent --request GET $url | wc -c)
    printf "... %s chars received\n" $cnt_chars
}

wp_auth_test () {
    data='{"username":"'$fdk_test_wp_username'","password":"'$fdk_test_wp_password'"}'
    set -x  # Print commands and their arguments as they are executed.
    curl -v -H 'Content-Type: application/json' \
         --data $data $fdk_test_wp_authApi_basePath/jwt-auth/v1/token

    # --head  print only the headers
    # curl --head $fdk_test_wp_authApi_basePath/jwt-auth/v1/token
    # Don't print commands
    { retval="$?";
      set +x; } 2>/dev/null
}

wp_auth_prod () {
    # --head  print only the headers
    # curl --head $fdk_prod_wp_authApi_basePath=https/jwt-auth/v1/token
    data='{"username":"'$fdk_prod_wp_username'","password":"'$fdk_prod_wp_password'"}'
    set -x  # Print commands and their arguments as they are executed.
    curl -v -H 'Content-Type: application/json' \
         --data $data $fdk_prod_wp_authApi_basePath/jwt-auth/v1/token
    # Don't print commands
    { retval="$?";
      set +x; } 2>/dev/null
}

wp_auth_test_token () {
    token=$(wp_auth_test)
    printf "%s\n" $(echo $token | jq -r '.token')
}

test_wp_dev () {
    token=$(wp_auth_test_token)
    # --head print only the headers
    set -x  # print commands and their arguments as they are executed.
    curl --oauth2-bearer $token --head $fdk_dev_wp_authApi_basePath/jwt-auth/v1/token
    { retval="$?";
      set +x; } 2>/dev/null
}

download () {
    set -x  # Print commands and their arguments as they are executed.
    # wget \
    #       https://wordpress.org/latest.zip \
    #       https://files.phpmyadmin.net/phpMyAdmin/5.1.3/phpMyAdmin-5.1.3-all-languages.zip \
    #       https://downloads.wordpress.org/plugin/code-snippets.zip \
    #       https://downloads.wordpress.org/plugin/jwt-authentication-for-wp-rest-api.1.2.6.zip \
    #       --directory-prefix=$prjdir/map/database
    # unzip phpMyAdmin-5.1.3-all-languages.zip
    # unzip latest.zip
    # Don't print commands
    { retval="$?";
      set +x; } 2>/dev/null
    printf "Open:\n"
    printf "      http://localhost:4200/wordpress/wp-admin/install.php\n"
    printf "      http://localhost:4200/phpMyAdmin-5.1.3-all-languages/index.php\n"
    printf "      http://localhost:4200/wordpress/index.php?rest_route=/\n"
    printf "      http://localhost:4200/wordpress/index.php?rest_route=/jwt-auth/v1\n"
    printf "      http://localhost:4200/wordpress/index.php?rest_route=/jwt-auth/v1/token\n"
}

start_php () {
    mysqld_safe 1>/dev/null &
    # phpApi paths
    sed -i -e "s|localhost/AssociationMap|localhost:4200|" \
        $prjdir/map/app-map/src/environments/environment.ts \
        $prjdir/map/app-form/src/environments/environment.ts

    # php -c /usr/etc -f /usr/etc/db-connect-test.php

    # --no-header / -q   means quiet-mode
    # -c <path>|<file>   Look for php.ini file in this directory
    # -t <docroot>       Specify document root <docroot> for built-in web server.
    # redirection '... 1>/var/log/php_stdout.log &' doesn't work
    set -x  # Print commands and their arguments as they are executed.
    php -q -c /usr/etc \
        -S localhost:4200 \
        -t $prjdir/map/database/ \
        &>/var/log/php_stdout.log &
    # Don't print commands
    { retval="$?";
      set +x; } 2>/dev/null

#     xterm -e 'env DISPLAY=":1.0" PROMPT_COMMAND="unset PROMPT_COMMAND
# ls -la
# echo $DISPLAY
# " bash'


#     xfce4-terminal \
#         --title="php" \
#         --command='env PROMPT_COMMAND="unset PROMPT_COMMAND
# # php -c /usr/etc -f /usr/etc/db-connect-test.php
# php -c /usr/etc -S localhost:4200 -t $prjdir/map/database/ 1>/dev/null &
# " bash'
}

# kill_all is broken: killing a node process messes up the terminal
kill_all () {
    # mysqladmin shutdown
    # set -x
    killall mariadbd # 'killall mysqld_safe' doesn't work
    killall php
    pkill -f "ng serve --port $port_map"
    pkill -f "ng serve --port $port_form"
    # set +x
}

create_database_php () {
    local db_php=$prjdir/map/database/api/database.php
    if [[ ! -f $db_php ]]; then
        cp $(dirname $db_php)/_$(basename $db_php) $db_php
        sed -i -e "s|'DB_NAME',.*''|'DB_NAME', 'associations'|" $db_php
        sed -i -e "s|'DB_USER',.*''|'DB_USER', '$USER'|" $db_php
    fi
}

install_node_modules () {
    # test if the directory is empty
    if [ -z "$(ls -A ./node_modules)" ]; then
        # do not ask 'Would you like to share anonymous usage data'
        ng analytics off
        npm install
    fi
}

serve_map () {
    # test_php
    # set -x
    create_database_php
    cd $prjdir/map/app-map/
    install_node_modules
    local logfile=/var/log/serve_map.log
    printf "See %s\n" $logfile
    # ng serve --port $port_map &>$logfile &
    ng serve --port $port_map
    # cd -
    # set +x

#     xfce4-terminal \
#         --working-directory="$prjdir/map/app-map/" \
#         --title="app-map" \
#         --command='env PROMPT_COMMAND="unset PROMPT_COMMAND
# curl --request GET http://localhost:4200/api/associations/read-associations.php
# ng serve --port 4201
# " bash'
}

serve_form () {
    # test_php
    # set -x
    create_database_php
    cd $prjdir/map/app-form/
    install_node_modules
    logfile=/var/log/serve_form.log
    printf "See %s\n" $logfile
    # ng serve --port $port_form &>$logfile &
    ng serve --port $port_form
    # cd -
    # set +x

#     xfce4-terminal \
#         --working-directory="$prjdir/map/app-form/" \
#         --title="app-form" \
#         --command='env PROMPT_COMMAND="unset PROMPT_COMMAND
# curl --request GET http://localhost:4200/api/associations/read-associations.php
# ng serve --port 4202
# " bash'
}

start () {
    start_php
    serve_map
    serve_form
}

set_ng () {
    local file=$1
    sed -i \
        's#"ng \(.*\)"#"node $HOME/node_modules/@angular/cli/bin/ng.js \1"#' \
        $file
}

set_version () {
    local file=$1
    grep "version" $file \
    | grep --only-matching "\([0-9]*\?\.[0-9]*\?\.[0-9]*\?\)"
}

version () {
    cd $prjdir
    git stash

    cd $(dirname $p1)
    npm run app-map:version # no autocommit
    # npm run app-map:version:commit
    local ver_map=$(set_version $p1)

    cd $(dirname $p2)
    npm run app-form:version # no autocommit
    # npm run app-form:version:commit
    local ver_form=$(set_version $p2)

    cd $prjdir
    # -lt 5: all 3 version numbers MAJOR.MINOR.PATCH must be non-empty
    if [[ "$ver_form" != "$ver_map" && ${#ver_map} -lt 5 ]]; then
        printf "Wrong version numbers: ver_form: '%s', ver_map: '%s'\n" \
               $ver_form $ver_map
        printf "Reverting changes."
        git checkout -- $p1 $p2 $p11 $p22
        local retval=1
    else
        git add $p1 $p2 $p11 $p22
        git commit -m "v${ver_map}"
        local retval=0
    fi
    git stash pop
    return $retval
}

build () {
    cd $prjdir
    git stash
    set_ng $p1
    cd $prjdir/map/app-map
    npm run app-map:build:prod

    set_ng $p2
    sed -i "s|del-cli --force|rm -rf|" $p2
    sed -i "s|robocopy \(.*\) \*\.\* \/S \/E \/IS|cp -r \1|" $p2
    sed -i \
        "s|\(npm-run-all\)|node $HOME/dec/fdk/map/app-form/node_modules/npm-run-all/bin/npm-run-all/main.js \1|" \
        $p2
    cd $prjdir/map/app-form
    npm run app-form:build:prod

    git checkout -- $p1 $p2 $p11 $p22
    cd $prjdir
    git stash pop
    return 0
}

ver_build () {
    version
    local result="$?"
    if [ "$result" -ne 0 ]; then
        return $result
    else
        build
        return $?
    fi
}

deploy () {
    local fdk_login=$1
    local fdk_server=$2
    local fdk_home=$3
    if [[ -z "$fdk_login" || -z "$fdk_server" || -z "$fdk_home" ]]; then
        printf "Error: undefined variable(s):\n"
        printf "    fdk_login:  '%s'\n" $fdk_login
        printf "    fdk_server: '%s'\n" $fdk_server
        printf "    fdk_home:   '%s'\n" $fdk_home
    else
        local timestamp=$(date '+%s')
        echo "" > /tmp/backup.sh
        echo "set -v" >> /tmp/backup.sh
        echo "cd $fdk_home" >> /tmp/backup.sh
        echo "cp -r AssociationMap/ AssociationMap.backup-$timestamp/" >> /tmp/backup.sh
        echo "chmod -R -w AssociationMap.backup-$timestamp/" >> /tmp/backup.sh
        set -x
        ssh -t $fdk_login@$fdk_server < /tmp/backup.sh
        cd $prjdir
        # file transfer DEV -> TEST:
        # --archive --verbose --compress
        rsync -avz \
              --exclude="AssociationMap/.htaccess" \
              --exclude="AssociationMap/edit/.htaccess" \
              --exclude="AssociationMap/api/database.php" \
              ./map/dist/AssociationMap \
              $fdk_login@$fdk_server:$fdk_home
        set +x
    fi
}

deploy_test () {
    if [[ -z "$fdk_test_login" || -z "$fdk_test_server" || -z "$fdk_test_home" ]]; then
        printf "Error: undefined variable(s):\n"
        printf "    fdk_test_login:  '%s'\n" $fdk_test_login
        printf "    fdk_test_server: '%s'\n" $fdk_test_server
        printf "    fdk_test_home:   '%s'\n" $fdk_test_home
    else
        deploy $fdk_test_login $fdk_test_server $fdk_test_home
    fi
}

deploy_prod () {
    if [[ -z "$fdk_prod_login" || -z "$fdk_prod_server" || -z "$fdk_prod_home" ]]; then
        printf "Error: undefined variable(s):\n"
        printf "    fdk_prod_login:  '%s'\n" $fdk_prod_login
        printf "    fdk_prod_server: '%s'\n" $fdk_prod_server
        printf "    fdk_prod_home:   '%s'\n" $fdk_prod_home
    else
        deploy $fdk_prod_login $fdk_prod_server $fdk_prod_home
    fi
}

alias dow=download
alias twt=wp_auth_test
alias twd=test_wp_dev
alias form=serve_form
alias map=serve_map
alias shp=start_php

# Random password generator
# @param $1 password length
randpw () {
    head /dev/urandom | tr -dc '_?!#A-Za-z0-9' | head -c $1 ; echo ''
}

## Install nodejs packages on the first run
countMatchingLines=$(npm list @angular/cli | grep -c @angular/cli)
if [ $countMatchingLines -eq 0 ]; then
    npm install @angular/cli << EOF
N
EOF
    curdir=$(pwd)
    cd $prjdir/map/app-form/
    npm install
    cd $prjdir/map/app-map/
    npm install
    cd $curdir
fi

set_mysqlPassword () {
    local mysqlPassword=$(randpw 24)
    sed -i -e "s|# password|password = $mysqlPassword|" /usr/etc/my.cnf
}

## Install MariaDB on the first run
if [ ! -d /var/lib/mysql/data/mysql ]; then
    # Awful hack, required to solve a bug on mariadb guix' package
    lc_messages_dir=$(find /gnu/store -type d -name english | grep mysql)
    sed -i -e "s|#lc_messages_dir#|$lc_messages_dir|" /usr/etc/my.cnf

    mysql_install_db
    mysqld_safe &
    # execution of `mysql_secure_installation` is not needed
    sleep 3
    set_mysqlPassword
    mysql --user $USER << EOF
DROP DATABASE IF EXISTS associations;
CREATE DATABASE IF NOT EXISTS associations;
GRANT ALL PRIVILEGES ON associations.* TO '$USER'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
select '-- Loading test data ...' AS '';
SOURCE map/database/db-export/associations.sql;
-- SHOW TABLES;
-- SHOW COLUMNS IN activities;
SELECT count(*) as 'count-of-activities (should be ~130):'
FROM associations.activities;
EOF
    mysqladmin --user $USER shutdown
fi


guix_prompt () {
    cat << EOF
=========================================
  ____ _   _ _   _    ____       _
 / ___| \ | | | | |  / ___|_   _(_)_  __
| |  _|  \| | | | | | |  _| | | | \ \/ /
| |_| | |\  | |_| | | |_| | |_| | |>  <
 \____|_| \_|\___/   \____|\__,_|_/_/\_\\

Welcome! Available commands:
  start_php, serve_map, serve_form, version, build, deploy_test, deploy_prod
=========================================
EOF
}

if [[ $- != *i* ]]
then
    # We are being invoked from a non-interactive shell.  If this
    # is an SSH session (as in "ssh host command"), source
    # /etc/profile so we get PATH and other essential variables.
    [[ -n "$SSH_CLIENT" ]] && guix_prompt

    # Don't do anything else.
    return
fi

# Source the system-wide file.
# source /etc/bashrc

guix_prompt

# Adjust the prompt depending on whether we're in 'guix environment'.
if [ -n "$GUIX_ENVIRONMENT" ]
then
    PS1='\u@\h \w [env]\$ '
else
    PS1='\u@\h \w\$ '
fi
alias ls='ls -p --color=auto'
alias ll='ls -l'
alias grep='grep --color=auto'
alias clear="printf '\e[2J\e[H'"

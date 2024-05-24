# Bash initialization for interactive non-login shells and
# for remote shells (info "(bash) Bash Startup Files").

# Export 'SHELL' to child processes.  Programs such as 'screen'
# honor it and otherwise use /bin/sh.
export SHELL

# /run is not automatically created by guix
[ ! -d /run ] && mkdir /run

# Quick access to $GUIX_ENVIRONMENT, for usage on config files
# (currently only /etc/nginx/nginx.conf)
[ ! -L /env ] && ln -s $GUIX_ENVIRONMENT /env

# Link every file in /usr/etc on /etc
ls -1d /usr/etc/* | while read filepath; do
    bname=/etc/$(basename $filepath)
    [ ! -L $bname ] && ln -s $filepath $bname
done

alias ng='node ./node_modules/\@angular/cli/bin/ng.js'
# node_bin=`which node`
# ng_bin=$HOME/node_modules/\@angular/cli/bin/ng
#  serve_map_cmd="$node_bin $ng_bin serve --port 4021"
# serve_form_cmd="$node_bin $ng_bin serve --port 4022"

prjd=~/dec/fdk
port_map=4201
port_form=4202
port_php=4200

p1=$prjd/map/app-map/package.json
p11=$prjd/map/app-map/package-lock.json
p2=$prjd/map/app-form/package.json
p22=$prjd/map/app-form/package-lock.json

test_php () {
    url=http://localhost:$port_php/api/associations/read-associations.php
    printf "Testing php WebServer... \n"
    set -x  # Print commands and their arguments as they are executed.
    cnt_chars=$(curl --silent --request GET $url | wc -c)
    { retval="$?"; set +x; } 2>/dev/null
    printf "... %s chars received\n" $cnt_chars
}

data () {
    printf '{"username":"%s","password":"%s"}' $1 $2
}

wp_auth_test () {
    set -x  # Print commands and their arguments as they are executed.
    curl -H 'Content-Type: application/json' \
         --data $(data $fdk_test_wp_username $fdk_test_wp_password) \
         $fdk_test_wp_authApi_basePath/jwt-auth/v1/token
    # --head  print only the headers
    # curl --head $fdk_test_wp_authApi_basePath/jwt-auth/v1/token
    # Don't print commands
    { retval="$?"; set +x; } 2>/dev/null
    printf "\n"
}

wp_auth_prod () {
    # --head  print only the headers
    # curl --head $fdk_prod_wp_authApi_basePath=https/jwt-auth/v1/token
    set -x  # Print commands and their arguments as they are executed.
    curl -H 'Content-Type: application/json' \
         --data $(data $fdk_prod_wp_username $fdk_prod_wp_password) \
         $fdk_prod_wp_authApi_basePath/jwt-auth/v1/token
    # Don't print commands
    { retval="$?"; set +x; } 2>/dev/null
    printf "\n"
}

wp_auth_test_token () {
    token=$(wp_auth_test)
    printf "%s\n" $(echo $token | jq -r '.token')
}

test_wp_dev () {
    # --head print only the headers
    set -x  # print commands and their arguments as they are executed.
    curl --oauth2-bearer $(wp_auth_test_token) \
         --head $fdk_dev_wp_authApi_basePath/jwt-auth/v1/token
    { retval="$?"; set +x; } 2>/dev/null
}

test_basic_auth () {
    assocId=744b3317-7f5c-4dc2-be61-03e25859223c
    # encstr=$(echo 'Hello world!' | base64) # returns: SGVsbG8gd29ybGQh
    encstr=$(echo $fdk_test_wp_username':'$fdk_test_wp_password | base64)
    set -x  # print commands and their arguments as they are executed.
    curl -H "Authorization: Basic ${encstr}" \
         $fdk_dev_wp_authApi/api/associations/delete-association.php?id=$assocId
    { retval="$?"; set +x; } 2>/dev/null
}

download () {
    set -x  # Print commands and their arguments as they are executed.
    # wget \
    #       https://wordpress.org/latest.zip \
    #       https://files.phpmyadmin.net/phpMyAdmin/5.1.3/phpMyAdmin-5.1.3-all-languages.zip \
    #       https://downloads.wordpress.org/plugin/code-snippets.zip \
    #       https://downloads.wordpress.org/plugin/jwt-authentication-for-wp-rest-api.1.2.6.zip \
    #       --directory-prefix=$prjd/map/database
    # unzip phpMyAdmin-5.1.3-all-languages.zip
    # unzip latest.zip
    # Don't print commands
    { retval="$?"; set +x; } 2>/dev/null
    printf "Open:\n"
    printf "  http://localhost:%s/wordpress/wp-admin/install.php\n" $port_php
    printf "  http://localhost:%s/phpMyAdmin-5.1.3-all-languages/index.php\n" $port_php
    printf "  http://localhost:%s/wordpress/index.php?rest_route=/\n" $port_php
    printf "  http://localhost:%s/wordpress/index.php?rest_route=/jwt-auth/v1\n" $port_php
    printf "  http://localhost:%s/wordpress/index.php?rest_route=/jwt-auth/v1/token\n" $port_php
}

start_db () {
    set -x  # Print commands and their arguments as they are executed.
    mysqld_safe 1>/dev/null &
    # Don't print commands
    { retval="$?"; set +x; } 2>/dev/null
}

start_php () {
    start_db
    # phpApi paths
    sed -i -e "s|localhost/AssociationMap|localhost:4200|" \
        $prjd/map/app-map/src/environments/environment.ts \
        $prjd/map/app-form/src/environments/environment.ts

    # php -c /usr/etc -f /usr/etc/db-connect-test.php

    # --no-header / -q  means quiet-mode
    # -c <path>|<file>  Look for php.ini file in this directory
    # -t <docroot>      Specify document root <docroot> for built-in web server.
    # redirection '... 1>/var/log/php_stdout.log &' doesn't work
    set -x  # Print commands and their arguments as they are executed.
    php -q -c /usr/etc \
        -S localhost:$port_php \
        -t $prjd/map/database/ \
        &>/var/log/php_stdout.log &
    # Don't print commands
    { retval="$?"; set +x; } 2>/dev/null

#     xterm -e 'env DISPLAY=":1.0" PROMPT_COMMAND="unset PROMPT_COMMAND
# ls -la
# echo $DISPLAY
# " bash'


#     xfce4-terminal \
#         --title="php" \
#         --command='env PROMPT_COMMAND="unset PROMPT_COMMAND
# # php -c /usr/etc -f /usr/etc/db-connect-test.php
# php -c /usr/etc -S localhost:4200 -t $prjd/map/database/ 1>/dev/null &
# " bash'
}

# kill_all is broken: killing a node process messes up the terminal
kill_all () {
    # mysqladmin shutdown
    # set -x  # Print commands and their arguments as they are executed.
    killall mariadbd # 'killall mysqld_safe' doesn't work
    killall php
    pkill -f "ng serve --port $port_map"
    pkill -f "ng serve --port $port_form"
    # # Don't print commands
    # { retval="$?"; set +x; } 2>/dev/null
}

create_environment_php () {
    local env_php=$prjd/map/database/api/environment.php
    if [[ ! -f $env_php ]]; then
        cp $(dirname $env_php)/_$(basename $env_php) $env_php
        sed -i -e "s|'DB_NAME',.*''|'DB_NAME', 'associations'|" $env_php
        sed -i -e "s|'DB_USER',.*''|'DB_USER', '$USER'|" $env_php
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
    set -x  # Print commands and their arguments as they are executed.
    # test_php
    create_environment_php
    cd $prjd/map/app-map/ && install_node_modules
    local logfile=/var/log/serve_map.log
    printf "See %s\n" $logfile
    # ng serve --port $port_map &>$logfile &
    ng serve --port $port_map
    # Don't print commands
    { retval="$?"; set +x; } 2>/dev/null
    # cd -
#     xfce4-terminal \
#         --working-directory="$prjd/map/app-map/" \
#         --title="app-map" \
#         --command='env PROMPT_COMMAND="unset PROMPT_COMMAND
# curl --request GET http://localhost:4200/api/associations/read-associations.php
# ng serve --port 4201
# " bash'
}

serve_form () {
    # test_php
    create_environment_php
    cd $prjd/map/app-form/ && install_node_modules
    logfile=/var/log/serve_form.log
    printf "See %s\n" $logfile
    # ng serve --port $port_form &>$logfile &
    ng serve --port $port_form
    # cd -
#     xfce4-terminal \
#         --working-directory="$prjd/map/app-form/" \
#         --title="app-form" \
#         --command='env PROMPT_COMMAND="unset PROMPT_COMMAND
# curl --request GET http://localhost:4200/api/associations/read-associations.php
# ng serve --port $port_form
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

get_version () {
    local file=$1
    grep "version" $file \
    | grep --only-matching "\([0-9]*\?\.[0-9]*\?\.[0-9]*\?\)"
}

version () {
    cd $prjd && git stash

    cd $(dirname $p1) && npm run app-map:version  # no autocommit
    # npm run app-map:version:commit
    local ver_map=$(get_version $p1)

    cd $(dirname $p2) && npm run app-form:version # no autocommit
    # npm run app-form:version:commit
    local ver_form=$(get_version $p2)

    cd $prjd
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
    cd $prjd && git stash
    set_ng $p1
    cd $prjd/map/app-map && npm run app-map:build:prod

    set_ng $p2
    sed -i "s|del-cli --force|rm -rf|" $p2
    sed -i "s|robocopy \(.*\) \*\.\* \/S \/E \/IS|cp -r \1|" $p2
    sed -i \
        "s|\(npm-run-all\)|node $HOME/dec/fdk/map/app-form/node_modules/npm-run-all/bin/npm-run-all/main.js \1|" \
        $p2
    cd $prjd/map/app-form && npm run app-form:build:prod
    distd=$prjd/map/dist
    rm -rf $distd/AssociationMap/edit/api
    mv $distd/AssociationMap/edit/.htaccess $distd/AssociationMap/.htaccess

    git checkout -- $p1 $p2 $p11 $p22
    cd $prjd && git stash pop
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
    printf "\n"
    printf "    fdk_login:  %s\n" $fdk_login
    printf "    fdk_server: %s\n" $fdk_server
    printf "    fdk_home:   %s\n" $fdk_home
    printf "\n"
    if [[ -z "$fdk_login" || -z "$fdk_server" || -z "$fdk_home" ]]; then
        printf "ERR: All fdk_* variables must be defined.\n"
    else
        local tstp=$(date '+%F_%T')
        local dst=~/AssociationMap-$tstp

        [ ! -d $fdk_home ] && mkdir -p $fdk_home

        src="./map/dist/AssociationMap"
        remote_path=$prjd/$fdk_home
        version=$(get_version $p1)
        fzip=AssociationMap-$version.zip

        # Use a subshell to avoid changing the current directory
        #   (cd $(basename "$src") && zip -r ../$fzip .)  # --recurse-paths
        # Or:
        #   (cd $(basename "$src") && zip -j ../$fzip .)  # --junk-paths
        # -j --junk-paths
        # Store just the name of a saved file (junk the path), and do not
        # store directory names. By default, zip will store the full path
        # (relative to the current directory).

        cd $(dirname $src)
        zip -q -r ../../$fzip $(basename "$src")
        cd -
        checksum=$(sha1sum $fzip | cut -d ' ' -f 1)
        cfzip="${checksum}-$fzip"
        mv $fzip $cfzip

        ssh "${fdk_login}@${fdk_server}" -- "[ ! -d $remote_path ] && mkdir -p $remote_path"
        scp "${cfzip}" "${fdk_login}@${fdk_server}:${remote_path}"

        td=$(mktemp --directory)
        unzip -q $remote_path/$cfzip -d $td
        mv $td/$(basename "$src") "${remote_path}/$checksum-$(basename "$src")-$version"
        rm $cfzip

        # ssh "${fdk_login}@${fdk_server}"

        # # At first transfer everything
        # cd $prjd
        # # file transfer DEV -> TEST:
        # # --archive --verbose --compress
        # set -x  # Print commands and their arguments as they are executed.
        # rsync -az \
        #       --exclude="AssociationMap/api/environment.php" \
        #       ./map/dist/AssociationMap \
        #       $fdk_login@$fdk_server:$dst
        # local result="$?"
        # if [ "$result" -ne 0 ]; then
        #     return $result
        # fi
        # # Don't print commands
        # { retval="$?"; set +x; } 2>/dev/null

        # local AMO=$fdk_home/AssociationMap
        # local AMB=$AMO.backup-$tstp
        # echo "" > /tmp/script.sh
        # echo "set -v"                                                                           >> /tmp/script.sh
        # echo "host=\$(hostname)"                                                                >> /tmp/script.sh
        # echo "if [ -d $AMO ]; then"                                                             >> /tmp/script.sh
        # echo "    cp -r $AMO $AMB"                                                              >> /tmp/script.sh
        # echo "    local result=\"$?\""                                                          >> /tmp/script.sh
        # echo "    if [ \"$result\" -ne 0 ]; then"                                               >> /tmp/script.sh
        # echo "        return $result"                                                           >> /tmp/script.sh
        # echo "    else"                                                                         >> /tmp/script.sh
        # echo "        printf \"[%s] Backup successful. Emptying %s...\\n\" \$host $AMO"         >> /tmp/script.sh
        # echo "        chmod -R -w $AMB"                                                         >> /tmp/script.sh
        # echo "        find $AMO -not -name environment.php -delete"                             >> /tmp/script.sh
        # echo "        find $AMO -empty -type d -delete"                                         >> /tmp/script.sh
        # echo "        printf \"[%s] Items in %s : %s\\n\" \$host $AMO \$(ls -la $AMO | wc -l)"  >> /tmp/script.sh
        # echo "        cp -r $dst $AMO"                                                          >> /tmp/script.sh
        # echo "        printf \"[%s] Items in %s : %s\\n\" \$host $AMO \$(ls -la $AMO | wc -l)"  >> /tmp/script.sh
        # echo "    fi"                                                                           >> /tmp/script.sh
        # echo "else"                                                                             >> /tmp/script.sh
        # echo "    printf \"[%s] ERR: Directory doesn't exist: %s\\n\" \$host $AMO"              >> /tmp/script.sh
        # echo "fi"                                                                               >> /tmp/script.sh
        # set -x  # Print commands and their arguments as they are executed.
        # # ssh -t $fdk_login@$fdk_server < /tmp/script.sh
        # # Don't print commands
        # { retval="$?"; set +x; } 2>/dev/null
    fi
}

deploy_dev () {
    deploy bost ecke ./tmp/fdk
}

deploy_test () {
    if [[   -z "$fdk_test_login"
         || -z "$fdk_test_server"
         || -z "$fdk_test_home" ]]; then
        printf "ERR: undefined variable(s):\n"
        printf "    fdk_test_login:  %s\n" $fdk_test_login
        printf "    fdk_test_server: %s\n" $fdk_test_server
        printf "    fdk_test_home:   %s\n" $fdk_test_home
    else
        deploy $fdk_test_login $fdk_test_server $fdk_test_home
    fi
}

deploy_prod () {
    if [[   -z "$fdk_prod_login"
         || -z "$fdk_prod_server"
         || -z "$fdk_prod_home" ]]; then
        printf "ERR: undefined variable(s):\n"
        printf "    fdk_prod_login:  %s\n" $fdk_prod_login
        printf "    fdk_prod_server: %s\n" $fdk_prod_server
        printf "    fdk_prod_home:   %s\n" $fdk_prod_home
    else
        deploy $fdk_prod_login $fdk_prod_server $fdk_prod_home
    fi
}

# Random password generator
# @param $1 password length
randpw () {
    head /dev/urandom | tr -dc '_?!#A-Za-z0-9' | head -c $1 ; echo ''
}

## Install nodejs packages on the first run
cntMatches=$(npm list @angular/cli 2>/dev/null | grep -c "UNMET DEPENDENCY")
if [ $cntMatches -eq 1 ]; then
    # printf "DBG: first run: cntMatches: %s\n" $cntMatches
    # printf "DBG: install nodejs packages...\n"
    wd=$(pwd)
    set -x  # Print commands and their arguments as they are executed.
    npm install @angular/cli << EOF
N
EOF
    cd $prjd/map/app-form/ && npm install
    cd $prjd/map/app-map/  && npm install
    cd $wd
    # Don't print commands
    { retval="$?"; set +x; } 2>/dev/null
    # printf "DBG: install nodejs packages... done\n"
# else
#     printf "DBG: consecutive run: cntMatches: %s\n" $cntMatches
fi

test_db () {
    set -x  # Print commands and their arguments as they are executed.
    mysql --user $USER << EOF
SELECT count(*) as "count-of-activities (should be ~130):"
FROM associations.activities;
EOF
    { retval="$?"; set +x; } 2>/dev/null
    if [ ! $retval -eq 0 ]; then
        printf "INF: \`start_db\` executed?\n"
        return $retval
    fi
}

## Install MariaDB on the first run
dbd=/var/lib/mysql/data/mysql
if [ ! -d $dbd ]; then
    # printf "DBG: first run: dbd doesn't exist: %s\n" $dbd
    # printf "DBG: install MariaDB...\n"

    ### The 'sed ...'-hack below, required to solve a bug on mariadb guix'
    ### package is not needed.
    ### Regarding locating of a guix package in the store:
    ### 1. "mariadb:lib" must be present in the manifest.scm
    ### 2. The guix-daemon is not running, so this doesn't work in the `guix
    ### shell ...`:
    ###   guile -c '
    ###   (use-modules (guix) (gnu packages databases))
    ###   (define store (open-connection))
    ###   (format #t
    ###           (derivation->output-path (package-derivation
    ###                                     store mariadb #:graft? #f)
    ###                                    "lib"))'
    lc_messages_dir=$(readlink \
                          $(dirname \
                                $(dirname \
                                      $(which mariadb)))/share/mysql/english)
    printf "lc_messages_dir: %s\n" $lc_messages_dir
    sed -i -e "s|#lc_messages_dir#|$lc_messages_dir|" /usr/etc/my.cnf

    # TODO if the PAM authentication plugin is needed
    # guix_plugind=$(find /gnu/store/ -name auth_pam.so -type f | xargs dirname)
    # cp -r $guix_plugind /var/lib/mysql

    ## ignore the text:
    # chown: cannot access '/auth_pam_tool_dir/auth_pam_tool': No such file or directory
    # Couldn't set an owner to '/auth_pam_tool_dir/auth_pam_tool'.
    # It must be root, the PAM authentication plugin doesn't work otherwise..
    #
    # chown: cannot access '/auth_pam_tool_dir': No such file or directory
    # Cannot change ownership of the '/auth_pam_tool_dir' directory
    # to the 'bost' user. Check that you have the necessary permissions and try again.

    set -x
    mysql_install_db 2>&1 | sed '/^chown: cannot access/,/try again\.$/d'
    mysqld_safe &
    # execution of `mysql_secure_installation` is not needed
    sleep 3
    # --verbose   show executed SQL commands
    mysql --user $USER << EOF
DROP DATABASE IF EXISTS associations;
CREATE DATABASE IF NOT EXISTS associations;
DELETE FROM mysql.user WHERE User='';
GRANT ALL PRIVILEGES ON associations.* TO '$USER'@'localhost' WITH GRANT OPTION;
CREATE USER 'foo'@'localhost' IDENTIFIED BY '';
GRANT ALL PRIVILEGES ON *.* TO 'foo'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
SELECT concat(user, '  \'', password, '\'') FROM mysql.user;
SELECT '-- Loading test data ...' AS '';
SOURCE map/database/db-export/associations.sql;
-- SHOW TABLES;
-- SHOW COLUMNS IN activities;
EOF
    mysqladmin --user $USER shutdown
#     printf "DBG: install MariaDB... done\n"
# else
#     printf "DBG: first run: dbd exists already: %s\n" $dbd
    { retval="$?"; set +x; } 2>/dev/null
fi

guix_prompt () {
    cat << "EOF"
    ░░░                                     ░░░
    ░░▒▒░░░░░░░░░               ░░░░░░░░░▒▒░░
     ░░▒▒▒▒▒░░░░░░░           ░░░░░░░▒▒▒▒▒░
         ░▒▒▒░░▒▒▒▒▒         ░░░░░░░▒▒░
               ░▒▒▒▒░       ░░░░░░
                ▒▒▒▒▒      ░░░░░░
                 ▒▒▒▒▒     ░░░░░
                 ░▒▒▒▒▒   ░░░░░
                  ▒▒▒▒▒   ░░░░░
                   ▒▒▒▒▒ ░░░░░
                   ░▒▒▒▒▒░░░░░
                    ▒▒▒▒▒▒░░░
                     ▒▒▒▒▒▒░
     _____ _   _ _    _    _____       _
    / ____| \ | | |  | |  / ____|     (_)
   | |  __|  \| | |  | | | |  __ _   _ ___  __
   | | |_ | . ' | |  | | | | |_ | | | | \ \/ /
   | |__| | |\  | |__| | | |__| | |_| | |>  <
    \_____|_| \_|\____/   \_____|\__,_|_/_/\_\

Available commands:
  start_php, serve_map, serve_form, version, build, deploy_test, deploy_prod
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

alias dpd=deploy_dev
alias dpt=deploy_test
alias sfrm=serve_form
alias smap=serve_map
alias sphp=start_php
alias sdb=start_db
alias mbost='mysql --user bost'
alias mfoo='mysql --user foo'
alias tphp=test_php
# alias twt=wp_auth_test
# alias twd=test_wp_dev

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

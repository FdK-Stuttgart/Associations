;; What follows is a "manifest" equivalent to the command line you gave.
;; You can store it in a file that you may then pass to any 'guix' command
;; that accepts a '--manifest' (or '-m') option.

;; This file was initially created by
;;     guix shell PACKAGES --export-manifest

(specifications->manifest
  (list
   "bash"

   ;; 1. The `ls' from busybox is causing problems. However it is overshadowed
   ;; when this list is reversed. (Using Guile or even on the command line.)
   ;;
   ;; 2. It seems like busybox is not needed if invoked with:
   ;;     guix shell ... --share=/usr/bin
   #;"busybox"

   ;; see also `guix search clojure'
   "clojure"
   "clojure-tools" ; adding this makes clojure binary available on the CLI

   "coreutils"
   "curl"
   "findutils" ; provides: find, updatedb, xargs
   "procps"    ; provides: free, pgrep, pidof, pkill, pmap, ps, pwdx, slabtop,
               ;           tload, top, vmstat, w, watch and sysctl
   "fish"
   "git"
   "gnupg"
   "grep"
   "iproute2" ; contains ss - socket statistics
   "jq"
   "leiningen"
   "less"
   "mariadb"
   ;; "mariadb:lib" ; see the 'sed ...'-hack in the .bashrc

   ;; https://github.com/dbcli/mycli/issues/534
   ;; $ mycli --user bost
   ;; (1698, "Access denied for user 'bost'@'localhost'")
   ;; $ mycli --user foo # works
   "mycli"
   "util-linux" ;  provides: dmesg, namei, ...

   "ncurses"
   "node"
   "nss-certs"

   ;; `guix shell openjdk@<version>:jdk PACKAGES --export-manifest' ignores the
   ;; '@<version>' if it matches the installed version.
   "openjdk:jdk"

   "openssh"
   "pgcli"
   "php"
   "ripgrep"
   "rsync"
   "sed"
   "which"
   "zip"
   "unzip"
   ))

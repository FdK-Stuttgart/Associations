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
   "jq"
   "leiningen"
   "less"
   "mariadb"
   ;; "mariadb:lib" ; see the 'sed ...'-hack in the .bashrc
   "mycli"
   "ncurses"

;;; AngularJS requires >=node@14.20.0 which doesn't compile however. And the
;;; local node-installation $HOME/dev/node-v14.20.0/node doesn't work if the gcc
;;; is not present. The error is 'libstdc++.so.6 ... No such file or directory'.
;;; See also "alias ng='...'" in the .bashrc
   ;; "node@14.19.3"
   "gcc"

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
   ))

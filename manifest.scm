;; What follows is a "manifest" equivalent to the command line you gave.
;; You can store it in a file that you may then pass to any 'guix' command
;; that accepts a '--manifest' (or '-m') option.

;; This file was initially created by
;;     guix shell PACKAGES --export-manifest

(use-modules
 (guix profiles)
 ((bost gnu packages clojure) #:prefix bstc:))

(define general-packages
  (list
    "bash" ;; see also "bash-minimal"

    ;; 1. The `ls' from busybox is causing problems. However it is overshadowed
    ;; when this list is reversed. (Using Guile or even on the command line.)
    ;;
    ;; 2. It seems like busybox is not needed if invoked with:
    ;;     guix shell ... --share=/usr/bin
    #;"busybox"

    "coreutils"
    "curl"
    "direnv"
    "findutils" ; provides: find, updatedb, xargs
    "procps"    ; provides: free, pgrep, pidof, pkill, pmap, ps, pwdx, slabtop,
                                        ;           tload, top, vmstat, w, watch and sysctl
    "fish"
    "git"
    "gnupg"
    "grep"
    "iproute2" ; provides `ss' socket statistics

    ;; Command-line JSON processor
    "jq"

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

    "openssh"
    ;; PostgreSQL CLI with autocompletion and syntax highlighting
    "pgcli"

    "php"
    "ripgrep"
    "rsync"
    "sed"
    "inetutils" ;; provides hostname, etc.
    "which"
    "zip"
    "unzip"
    "pinentry"
    ))

(define clojure-packages
  (list
   ;; see also `guix search clojure'
   ;;
   ;; https://issues.guix.gnu.org/53765#164
   ;; * gnu/packages/clojure.scm (clojure-tools) [inputs]: Add dependency on slf4j to silence logging warnings.
   ;;
   ;; "clojure"
   ;; "clojure-lsp" ;; needed only for emacs

   ;; CLI tools to start a Clojure repl, use Clojure and Java libraries, and
   ;; start Clojure programs. See https://clojure.org/releases/tools
   ;; "clojure-tools" ; adding this makes clojure binary available on the CLI

   "leiningen"

   ;; `guix shell openjdk@<version>:jdk PACKAGES --export-manifest' ignores the
   ;; '@<version>' if it matches the installed version.
   "openjdk:jdk"
   ))

(define clojure-manifest
  (concatenate-manifests
   (list
    (specifications->manifest clojure-packages)
    (manifest
     (list
      (package->manifest-entry bstc:clojure)
      (package->manifest-entry bstc:clojure-tools))))))

(concatenate-manifests
 (list
  (specifications->manifest general-packages)
  clojure-manifest))
